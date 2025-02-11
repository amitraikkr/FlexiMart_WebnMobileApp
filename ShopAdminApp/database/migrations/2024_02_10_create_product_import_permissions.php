<?php

use Illuminate\Database\Migrations\Migration;
use Spatie\Permission\Models\Permission;

return new class extends Migration
{
    public function up()
    {
        // Create product import permissions
        $permissions = [
            'product-import-read',
            'product-import-create'
        ];

        foreach ($permissions as $permission) {
            Permission::create([
                'name' => $permission,
                'guard_name' => 'web'
            ]);
        }
    }

    public function down()
    {
        // Remove the permissions if needed
        Permission::whereIn('name', [
            'product-import-read',
            'product-import-create'
        ])->delete();
    }
}; 