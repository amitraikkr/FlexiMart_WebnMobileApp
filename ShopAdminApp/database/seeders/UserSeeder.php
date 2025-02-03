<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = array(
            array('business_id' => '1','email' => 'rafawyzely@mailinator.com','name' => 'Acnoo','role' => 'shop-owner','phone' => '+1 (197) 298-7982','image' => NULL,'lang' => 'en','visibility' => NULL,'status' => NULL,'password' => '$2y$10$9qf15x7fCjSoLm5Ngj972.0O7VzM43DHAFx3yVkgACx2ldwbQMjCW','email_verified_at' => NULL,'remember_token' => NULL,'created_at' => '2024-10-27 11:21:21','updated_at' => '2024-10-27 11:21:21'),
            array('business_id' => '2','email' => 'vileban@mailinator.com','name' => 'Dhaka IT','role' => 'shop-owner','phone' => '+1 (569) 836-1751','image' => NULL,'lang' => 'en','visibility' => NULL,'status' => NULL,'password' => '$2y$10$onWaEcTqTIIa5c1dMEIj9en1FR8Kygtw90yI.E2ai3D4KbC/U7Ln6','email_verified_at' => NULL,'remember_token' => NULL,'created_at' => '2024-10-27 11:21:30','updated_at' => '2024-10-27 11:21:30'),
            array('business_id' => '3','email' => 'quzuw@mailinator.com','name' => 'Rocha and Mcdonald Traders','role' => 'shop-owner','phone' => '+1 (176) 838-7381','image' => NULL,'lang' => 'en','visibility' => NULL,'status' => NULL,'password' => '$2y$10$ia.AACUq7WIyBJ01HxbNR.2B6zkumN1d7BFdFx6lhTVrG4pPfeKza','email_verified_at' => NULL,'remember_token' => NULL,'created_at' => '2024-10-27 11:21:39','updated_at' => '2024-10-27 11:21:39')
          );

        User::insert($users);
    }
}
