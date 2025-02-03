<?php

namespace Database\Seeders;

use App\Models\PlanSubscribe;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class PlanSubscribeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $plan_subscribes = array(
            array('plan_id' => '2','business_id' => '1','gateway_id' => NULL,'price' => '10','payment_status' => 'unpaid','duration' => '30','notes' => NULL,'created_at' => '2024-10-27 11:21:21','updated_at' => '2024-10-27 11:21:21'),
            array('plan_id' => '2','business_id' => '2','gateway_id' => NULL,'price' => '10','payment_status' => 'unpaid','duration' => '30','notes' => NULL,'created_at' => '2024-10-27 11:21:30','updated_at' => '2024-10-27 11:21:30'),
            array('plan_id' => '3','business_id' => '3','gateway_id' => NULL,'price' => '60','payment_status' => 'unpaid','duration' => '180','notes' => NULL,'created_at' => '2024-10-27 11:21:39','updated_at' => '2024-10-27 11:21:39')
          );

        PlanSubscribe::insert($plan_subscribes);
    }
}
