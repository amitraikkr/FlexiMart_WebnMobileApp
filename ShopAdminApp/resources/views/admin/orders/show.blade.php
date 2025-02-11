@extends('layouts.master')

@section('main_content')
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h2>Order Details:  #{{ $order->id }}</h2>
            </div>
            <!-- <div class="col-sm-6 text-right">
                <a href="{{ route('admin.orders.index') }}" class="btn btn-secondary">Back to Orders</a>
            </div> -->
        </div>
    </div>
</div>

<div class="content">
    <div class="container-fluid">
        <!-- Customer Information -->
        <div class="customer-info mb-3">
            <div class="d-flex gap-4">
                <p class="mb-0"><strong>Name:</strong> {{ $order->customer_name }}</p>
                <p class="mb-0"><strong>Phone:</strong> {{ $order->customer_phone }}</p>
                <p class="mb-0"><strong>Address:</strong> {{ $order->customer_address }}</p>
            </div>
        </div>

        <!-- Status Update -->
        <div class="status-update mb-4">
            <form action="{{ route('admin.orders.updateStatus', $order->id) }}" method="POST" class="d-flex gap-2 align-items-center">
                @csrf
                @method('PUT')
                <div style="width: 200px;">
                    <select name="status" class="form-control form-control-sm">
                        <option value="pending" {{ $order->order_status === 'pending' ? 'selected' : '' }}>Pending</option>
                        <option value="processing" {{ $order->order_status === 'processing' ? 'selected' : '' }}>Processing</option>
                        <option value="completed" {{ $order->order_status === 'completed' ? 'selected' : '' }}>Completed</option>
                        <option value="cancelled" {{ $order->order_status === 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-sm btn-primary">Update Status</button>
            </form>
        </div>

        <!-- Order Items -->
        <div class="card">
            <div class="card-header py-2">
                <h3 class="card-title">Order Items</h3>
            </div>
            <div class="card-body p-0">
                <table class="table table-sm mb-0">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($order->orderDetails as $item)
                        <tr>
                            <td>{{ $item->item_name }}</td>
                            <td>{{ $item->item_quantity }}</td>
                            <td>${{ number_format((float)$item->item_price, 2) }}</td>
                            <td>${{ number_format((float)$item->item_total, 2) }}</td>
                        </tr>
                        @endforeach
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" class="text-right"><strong>Total:</strong></td>
                            <td>
                                <strong>
                                    ${{ 
                                        $order->orderDetails->sum('item_total') 
                                        ? number_format($order->orderDetails->sum('item_total'), 2) 
                                        : '0.00' 
                                    }}
                                </strong>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<style>
.customer-info {
    font-size: 13px;
    line-height: 1.2;
}
.gap-4 {
    gap: 2rem;
}
.gap-2 {
    gap: 0.5rem;
}
.card {
    box-shadow: 0 0 1px rgba(0,0,0,.125), 0 1px 3px rgba(0,0,0,.2);
}
.card-header {
    background-color: transparent;
    border-bottom: 1px solid rgba(0,0,0,.125);
}
.card-title {
    margin-bottom: 0;
    font-size: 0.9rem;
    font-weight: 500;
}
.table th {
    border-top: none;
}
.form-control-sm {
    height: calc(1.5em + 0.5rem + 2px);
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
}
</style>
@endsection