<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class OrderDetail extends Model
{
    use HasFactory;

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

    protected $casts = [
        'item_price' => 'float',
        'item_quantity' => 'integer',
        'item_total' => 'float'
    ];

    public function order()
    {
        return $this->belongsTo(CustomerOrder::class, 'order_id');
    }
}
