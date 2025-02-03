<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\BusinessCategory;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class BusinessCategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $business_categories = array(
            array('name' => 'Fashion Store','status' => 1,'created_at' => now(),'updated_at' => now()),
            array('name' => 'Electronics Store','status' => 1,'created_at' => now(),'updated_at' => now()),
            array('name' => 'Computer Store','status' => 1,'created_at' => now(),'updated_at' => now()),
            array('name' => 'Vegetable Store','status' => 1,'created_at' => now(),'updated_at' => now()),
            array('name' => 'Meat Store','status' => 1,'created_at' => now(),'updated_at' => now()),
            array('name' => 'BR','status' => 1,'created_at' => now(),'updated_at' => now()),
            array('name' => 'Restaurant','status' => 1,'created_at' => now(),'updated_at' => now()),
            array('name' => 'CAR WASH','status' => 1,'created_at' => now(),'updated_at' => now()),
        );

        BusinessCategory::insert($business_categories);
    }
}
