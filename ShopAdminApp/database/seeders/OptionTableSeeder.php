<?php

namespace Database\Seeders;

use App\Models\Option;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Artisan;

class OptionTableSeeder extends Seeder
{
    public function run(): void
    {
        $options = array(
            array('key' => 'general','value' => '{"title":"Grocery Shop","copy_right":"COPYRIGHT \\u00a9 2023 Acnoo, All rights Reserved","admin_footer_text":"Made By","admin_footer_link_text":"acnoo","admin_footer_link":"https:\\/\\/acnoo.com\\/","favicon":"uploads\\/24\\/10\\/1729699639-17.svg","admin_logo":"uploads\\/24\\/10\\/1729699639-515.svg"}','status' => '1','created_at' => '2024-10-26 17:29:19','updated_at' => '2024-10-26 17:29:50'),
            array('key' => 'login-page','value' => '{"login_page_icon":"uploads\\/24\\/10\\/1729930200-411.svg","login_page_image":"uploads\\/24\\/10\\/1729930200-648.svg"}','status' => '1','created_at' => '2024-10-26 17:29:19','updated_at' => '2024-10-26 17:29:19')
        );

        Artisan::call('cache:clear');
        Artisan::call('config:clear');
        Artisan::call('route:clear');
        Artisan::call('view:clear');

        Option::insert($options);
    }
}
