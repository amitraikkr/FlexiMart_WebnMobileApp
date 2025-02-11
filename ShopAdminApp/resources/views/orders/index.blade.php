@extends('layouts.app')

@section('content')
<div class="container">
    <h2>Customer Orders</h2>
    
    <div class="card">
        <div class="card-body">
            <table class="table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Order Type</th>
                        <th>Customer Name</th>
                        <th>Phone</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Status</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($orders as $order)
                    <tr>
                        <td>{{ $order->id }}</td>
                        <td>{{ $order->order_type }}</td>
                        <td>{{ $order->customer_name }}</td>
                        <td>{{ $order->customer_phone }}</td>
                        <td>{{ $order->order_date }}</td>
                        <td>{{ $order->order_time }}</td>
                        <td>
                            <span class="badge bg-{{ $order->order_status === 'completed' ? 'success' : 'warning' }}">
                                {{ ucfirst($order->order_status) }}
                            </span>
                        </td>
                        <td>${{ $order->order_total }}</td>
                        <td>
                            <a href="{{ route('orders.show', $order->id) }}" 
                               class="btn btn-sm btn-primary">
                                View Details
                            </a>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
            
            {{ $orders->links() }}
        </div>
    </div>
</div>
@endsection