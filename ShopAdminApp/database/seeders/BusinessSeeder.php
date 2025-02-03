<?php

namespace Database\Seeders;

use App\Models\Business;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class BusinessSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
          $businesses = array(
            array('plan_subscribe_id' => '1','business_category_id' => '1','companyName' => 'Acnoo','will_expire' => '2024-11-26','address' => 'Dhaka','phoneNumber' => '1871165401','pictureUrl' => NULL,'subscriptionDate' => '2024-10-27 11:21:21','remainingShopBalance' => '0','shopOpeningBalance' => '100','created_at' => '2024-10-27 11:21:20','updated_at' => '2024-10-27 11:21:21'),
            array('plan_subscribe_id' => '2','business_category_id' => '2','companyName' => 'Dhaka IT','will_expire' => '2024-11-26','address' => 'Dhaka','phoneNumber' => '1871165401','pictureUrl' => NULL,'subscriptionDate' => '2024-10-27 11:21:30','remainingShopBalance' => '0','shopOpeningBalance' => '200','created_at' => '2024-10-27 11:21:30','updated_at' => '2024-10-27 11:21:30'),
            array('plan_subscribe_id' => '3','business_category_id' => '2','companyName' => 'Maan Theme','will_expire' => '2025-04-25','address' => 'Dhaka','phoneNumber' => '1871165401','pictureUrl' => NULL,'subscriptionDate' => '2024-10-27 11:21:39','remainingShopBalance' => '0','shopOpeningBalance' => '500','created_at' => '2024-10-27 11:21:39','updated_at' => '2024-10-27 11:21:39')
          );

        Business::insert($businesses);
    }
}
