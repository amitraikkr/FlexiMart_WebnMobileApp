<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class CustomerOrder extends Model
{
    use HasFactory;

    protected $table = 'customer_orders';

    protected $fillable = [
        'customer_name',
        'customer_phone',
        'customer_address',
        'order_status',
        'order_total',
        'created_at'
    ];

    // Cast attributes to proper types
    protected $casts = [
        'order_total' => 'float',
        'created_at' => 'datetime',
        'updated_at' => 'datetime'
    ];

    // Define relationships
    public function orderDetails()
    {
        return $this->hasMany(OrderDetail::class, 'order_id');
    }
}
