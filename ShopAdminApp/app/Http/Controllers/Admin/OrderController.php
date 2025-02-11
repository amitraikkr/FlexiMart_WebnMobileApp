<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\CustomerOrder;
use Illuminate\Http\Request;
use Carbon\Carbon;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $query = CustomerOrder::with(['orderDetails']);

        // Date Range Filter
        if ($request->filled('from_date')) {
            $query->whereDate('created_at', '>=', Carbon::parse($request->from_date)->startOfDay());
        }
        if ($request->filled('to_date')) {
            $query->whereDate('created_at', '<=', Carbon::parse($request->to_date)->endOfDay());
        }

        // Status Filter
        if ($request->filled('status') && $request->status !== 'all') {
            $query->where('order_status', $request->status);
        }

        // Search Filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('customer_name', 'like', "%{$search}%")
                  ->orWhere('customer_phone', 'like', "%{$search}%")
                  ->orWhere('id', 'like', "%{$search}%");
            });
        }

        // Per Page
        $perPage = $request->get('per_page', 10);

        // Get Orders with Pagination
        $orders = $query->latest()
                       ->paginate($perPage)
                       ->withQueryString(); // This preserves other query parameters in pagination links

        return view('admin.orders.index', compact('orders'));
    }

    public function show($id)
    {
        // Add debug logging
        \Log::info('Fetching order:', ['id' => $id]);

        $order = CustomerOrder::with(['orderDetails'])->findOrFail($id);

        // Debug the retrieved data
        // \Log::info('Order data:', [
        //     'order' => $order->toArray(),
        //     'details' => $order->orderDetails->toArray()
        // ]);

        return view('admin.orders.show', compact('order'));
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:pending,processing,completed,cancelled'
        ]);

        $order = CustomerOrder::findOrFail($id);
        $order->order_status = $request->status;
        $order->save();

        return redirect()->back()->with('success', 'Order status updated successfully');
    }
}
