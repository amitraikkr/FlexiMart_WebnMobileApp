<?php

namespace App\Http\Controllers\Api;

use App\Models\CustomerOrder;
use App\Models\CustomerOrderDetail;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    /**
     * Get count of new orders
     */
    public function getCountNewOrder()
    {
        $count = CustomerOrder::where('order_status', 'new')->count();

        return response()->json([
            'message' => __('Data fetched successfully.'),
            'data' => $count
        ]);
    }

    /**
     * Get orders by date range
     */
    public function getListingByDate(Request $request)
    {
        $request->validate([
            'start_date' => 'required|date',
            'end_date' => 'required|date'
        ]);

        $orders = CustomerOrder::whereBetween('order_date', [$request->start_date, $request->end_date])
            ->orderByRaw("CASE 
                WHEN order_status = 'new' THEN 1 
                WHEN order_status = 'processed' THEN 2 
                WHEN order_status = 'delivering' THEN 3 
                WHEN order_status = 'delivered' THEN 4 
                ELSE 5 
            END")
            ->orderBy('created_at', 'desc')
            ->with('orderDetails')
            ->get()
            ->map(function($order) {
                return [
                    'id' => $order->id,
                    'customer_name' => $order->customer_name,
                    'customer_phone' => $order->customer_phone,
                    'customer_address' => $order->customer_address,
                    'order_status' => $order->order_status,
                    'order_total' => $order->order_total,
                    'created_at' => $order->created_at,
                    'items' => $order->orderDetails->map(function($item) {
                        return [
                            'item_id' => $item->item_id,
                            'item_name' => $item->item_name,
                            'item_price' => $item->item_price,
                            'item_quantity' => $item->item_quantity,
                            'item_total' => $item->item_total,
                            'misc' => $item->misc
                        ];
                    })
                ];
            });

        return response()->json([
            'message' => __('Data fetched successfully.'),
            'data' => $orders
        ]);
    }

    /**
     * Update order status
     */
    public function updateOrderStatus(Request $request, $id)
    {
        $request->validate([
            'order_status' => 'required|in:new,processing,completed,cancelled'
        ]);

        $order = CustomerOrder::findOrFail($id);
        $order->update(['order_status' => $request->order_status]);

        return response()->json([
            'message' => __('Status updated successfully.'),
            'data' => $order
        ]);
    }

    /**
     * Create new order
     */
    public function createNewOrder(Request $request)
    {
        $request->validate([
            'customer_name' => 'required|string',
            'customer_phone' => 'required|string',
            'customer_address' => 'required|string',
            'items' => 'required|array',
            'items.*.item_id' => 'required',
            'items.*.item_name' => 'required|string',
            'items.*.item_price' => 'required|numeric',
            'items.*.item_quantity' => 'required|numeric|min:1',
            'items.*.misc' => 'nullable'
        ]);

        try {
            DB::beginTransaction();

            // Calculate total
            $orderTotal = collect($request->items)->sum(function($item) {
                return $item['item_price'] * $item['item_quantity'];
            });

            // Create order
            $order = CustomerOrder::create([
                'customer_name' => $request->customer_name,
                'customer_phone' => $request->customer_phone,
                'customer_address' => $request->customer_address,
                'order_status' => 'new',
                'order_total' => $orderTotal
            ]);

            // Create order items
            foreach ($request->items as $item) {
                CustomerOrderDetail::create([
                    'order_id' => $order->id,
                    'item_id' => $item['item_id'],
                    'item_name' => $item['item_name'],
                    'item_price' => $item['item_price'],
                    'item_quantity' => $item['item_quantity'],
                    'item_total' => $item['item_price'] * $item['item_quantity'],
                    'misc' => $item['misc'] ?? null
                ]);
            }

            DB::commit();

            return response()->json([
                'message' => __('Order created successfully.'),
                'data' => $order->load('orderDetails')
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'message' => __('Failed to create order.'),
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
