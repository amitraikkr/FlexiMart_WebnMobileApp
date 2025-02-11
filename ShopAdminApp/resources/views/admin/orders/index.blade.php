@extends('layouts.master')

@section('main_content')
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h2>Customer Orders2</h2>
            </div>
        </div>
    </div>
</div>

<div class="content">
    <div class="container-fluid">
        <!-- Filters -->
        <div class="row mb-3">
            <div class="col-md-12">
                <form action="{{ route('admin.orders.index') }}" method="GET" class="d-flex gap-3">
                    <div class="d-flex align-items-center gap-2">
                        <select name="per_page" class="form-control form-control-sm" onchange="this.form.submit()">
                            <option value="10" {{ request('per_page') == 10 ? 'selected' : '' }}>Show 10</option>
                            <option value="25" {{ request('per_page') == 25 ? 'selected' : '' }}>Show 25</option>
                            <option value="50" {{ request('per_page') == 50 ? 'selected' : '' }}>Show 50</option>
                        </select>
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <input type="date" name="from_date" class="form-control form-control-sm" value="{{ request('from_date') }}" placeholder="From Date">
                        <input type="date" name="to_date" class="form-control form-control-sm" value="{{ request('to_date') }}" placeholder="To Date">
                    </div>

                    <div class="d-flex align-items-center gap-2">
                        <select name="status" class="form-control form-control-sm">
                            <option value="">All Status</option>
                            <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                            <option value="processing" {{ request('status') == 'processing' ? 'selected' : '' }}>Processing</option>
                            <option value="completed" {{ request('status') == 'completed' ? 'selected' : '' }}>Completed</option>
                            <option value="cancelled" {{ request('status') == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                        </select>
                    </div>

                    <div class="flex-grow-1 d-flex gap-2">
                        <input type="text" name="search" class="form-control form-control-sm" placeholder="Search..." value="{{ request('search') }}">
                        <button type="submit" class="btn btn-sm btn-primary">Search</button>
                        @if(request()->hasAny(['search', 'status', 'from_date', 'to_date']))
                            <a href="{{ route('admin.orders.index') }}" class="btn btn-sm btn-secondary">Clear</a>
                        @endif
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-body p-0">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th><input type="checkbox" class="select-all"></th>
                            <th>Order ID</th>
                            <th>Customer Name</th>
                            <th>Phone</th>
                            <th>Order Date</th>
                            <th>Status</th>
                            <th>Total</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($orders as $order)
                        <tr>
                            <td><input type="checkbox" class="select-item"></td>
                            <td>{{ $order->id }}</td>
                            <td>{{ $order->customer_name }}</td>
                            <td>{{ $order->customer_phone }}</td>
                            <td>{{ $order->created_at ? $order->created_at->format('d M, Y') : 'N/A' }}</td>
                            <td>
                                <span class="badge bg-{{ $order->order_status === 'completed' ? 'success' : ($order->order_status === 'pending' ? 'warning' : 'info') }}">
                                    {{ ucfirst($order->order_status ?? 'N/A') }}
                                </span>
                            </td>
                            <td>
                                @php
                                    try {
                                        $total = $order->orderDetails->sum('item_total') ?? 0;
                                        echo '$' . number_format(max((float)$total, 0), 2);
                                    } catch (\Exception $e) {
                                        echo '$0.00';
                                    }
                                @endphp
                            </td>
                            <td class="text-end">
                                <a href="{{ route('admin.orders.show', $order->id) }}" class="btn btn-sm btn-info">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>

        <div class="d-flex justify-content-end mt-3">
            {{ $orders->appends(request()->query())->links() }}
        </div>
    </div>
</div>

<style>
.gap-2 {
    gap: 0.5rem;
}
.gap-3 {
    gap: 1rem;
}
.form-control-sm {
    height: calc(1.5em + 0.5rem + 2px);
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
}
.table th, .table td {
    padding: 1rem;
    vertical-align: middle;
}
</style>
@endsection