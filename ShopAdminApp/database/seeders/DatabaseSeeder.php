<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            PlanSeeder::class,
            BusinessCategorySeeder::class,
            BusinessSeeder::class,
            PermissionSeeder::class,
            OptionTableSeeder::class,
            UserSeeder::class,
            LanguageSeeder::class,
            CurrencySeeder::class,
            GatewaySeeder::class,
            AdvertiseSeeder::class,
            PlanSubscribeSeeder::class,
        ]);
    }
}
