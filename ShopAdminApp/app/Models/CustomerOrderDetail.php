<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CustomerOrderDetail extends Model
{
    protected $table = 'customer_order_details';
    
    protected $fillable = [
        'order_id',
        'item_id',
        'item_name',
        'item_price',
        'item_quantity',
        'item_total',
        'misc'
    ];

    public function order()
    {
        return $this->belongsTo(CustomerOrder::class, 'order_id');
    }
}