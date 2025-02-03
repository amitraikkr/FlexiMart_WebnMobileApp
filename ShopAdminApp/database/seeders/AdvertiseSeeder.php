<?php

namespace Database\Seeders;

use App\Models\Banner;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AdvertiseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $banners = array(
            array('name' => 'Free Shipping & Cashback Offer','imageUrl' => 'uploads/24/10/1729584140-184.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Free Shipping & Cashback Offer','imageUrl' => 'uploads/24/10/1729584178-618.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Ramadan Supper Offer','imageUrl' => 'uploads/24/10/1729584207-937.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Ramadan Supper Offer','imageUrl' => 'uploads/24/10/1729584235-936.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Super Sales 70% OFF','imageUrl' => 'uploads/24/10/1729584264-596.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Free Shipping & Cashback Offer','imageUrl' => 'uploads/24/10/1729584295-885.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Super Sales 70% OFF','imageUrl' => 'uploads/24/10/1729584332-86.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Ramadan Supper Offer','imageUrl' => 'uploads/24/10/1729584359-118.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Free Shipping & Cashback Offer','imageUrl' => 'uploads/24/10/1729584386-222.svg','status' => '1','created_at' => now(),'updated_at' => now()),
            array('name' => 'Super Sales 70% OFF','imageUrl' => 'uploads/24/10/1729584412-854.svg','status' => '1','created_at' => now(),'updated_at' => now())
          );


        Banner::insert($banners);
    }
}
