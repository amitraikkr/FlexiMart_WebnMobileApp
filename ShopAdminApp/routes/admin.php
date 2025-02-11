<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin as ADMIN;

Route::group(['as' => 'admin.', 'prefix' => 'admin', 'middleware' => ['auth', 'admin']], function () {
    Route::get('/', [ADMIN\DashboardController::class, 'index'])->name('dashboard.index');
    Route::get('/get-dashboard', [ADMIN\DashboardController::class, 'getDashboardData'])->name('dashboard.data');
    Route::get('/yearly-subscriptions', [ADMIN\DashboardController::class, 'yearlySubscriptions'])->name('dashboard.subscriptions');
    Route::get('/plans-overview', [ADMIN\DashboardController::class, 'plansOverview'])->name('dashboard.plans-overview');

    Route::resource('users', ADMIN\UserController::class);
    Route::post('users/filter', [ADMIN\UserController::class, 'acnooFilter'])->name('users.filter');
    Route::post('users/status/{id}', [ADMIN\UserController::class,'status'])->name('users.status');
    Route::post('users/delete-all', [ADMIN\UserController::class,'deleteAll'])->name('users.delete-all');

    Route::resource('banners', ADMIN\AcnooBannerController::class)->except('show', 'edit', 'create');
    Route::post('banners/filter', [ADMIN\AcnooBannerController::class, 'acnooFilter'])->name('banners.filter');
    Route::post('banners/status/{id}', [ADMIN\AcnooBannerController::class,'status'])->name('banners.status');
    Route::post('banners/delete-all', [ADMIN\AcnooBannerController::class,'deleteAll'])->name('banners.delete-all');

    //Subscription Plans
    Route::resource('plans', ADMIN\AcnooPlanController::class)->except('show');
    Route::post('plans/filter', [ADMIN\AcnooPlanController::class, 'acnooFilter'])->name('plans.filter');
    Route::post('plans/status/{id}', [ADMIN\AcnooPlanController::class,'status'])->name('plans.status');
    Route::post('plans/delete-all', [ADMIN\AcnooPlanController::class, 'deleteAll'])->name('plans.delete-all');

    // Business
    Route::resource('business', ADMIN\AcnooBusinessController::class);
    Route::put('business/upgrade-plan/{id}', [ADMIN\AcnooBusinessController::class, 'upgradePlan'])->name('business.upgrade.plan');
    Route::post('business/filter', [ADMIN\AcnooBusinessController::class, 'acnooFilter'])->name('business.filter');
    Route::post('business/status/{id}',[ADMIN\AcnooBusinessController::class,'status'])->name('business.status');
    Route::post('business/delete-all', [ADMIN\AcnooBusinessController::class,'deleteAll'])->name('business.delete-all');

    // Business Categories
    Route::resource('business-categories',ADMIN\AcnooBusinessCategoryController::class)->except('show');
    Route::post('business-category/filter', [ADMIN\AcnooBusinessCategoryController::class, 'acnooFilter'])->name('business-categories.filter');
    Route::post('business-categories/status/{id}',[ADMIN\AcnooBusinessCategoryController::class,'status'])->name('business-categories.status');
    Route::post('business-categories/delete-all', [ADMIN\AcnooBusinessCategoryController::class,'deleteAll'])->name('business-categories.delete-all');

    Route::resource('profiles', ADMIN\ProfileController::class)->only('index', 'update');

    Route::resource('subscription-reports', ADMIN\SubscriptionReport::class)->only('index');
    Route::post('subscription-reports/filter', [ADMIN\SubscriptionReport::class, 'acnooFilter'])->name('subscription-reports.filter');
    Route::post('subscription-reports/reject/{id}',[ADMIN\SubscriptionReport::class,'reject'])->name('subscription-reports.reject');
    Route::post('subscription-reports/paid/{id}',[ADMIN\SubscriptionReport::class,'paid'])->name('subscription-reports.paid');

    // Shop Report
    Route::get('shop-reports', [ADMIN\AcnooReportController::class, 'showAllShop'])->name('shop-reports.allshop');
    Route::post('shop-reports/filter', [ADMIN\AcnooReportController::class, 'acnooFilter'])->name('shop-reports.filter');
    Route::get('expire-shop-reports', [ADMIN\AcnooReportController::class, 'showExpireShop'])->name('expire-shop-reports');
    Route::post('expire-shop-reports/filter', [ADMIN\AcnooReportController::class, 'acnooFilterExpire'])->name('expire-shop-reports.filter');

    // Roles & Permissions
    Route::resource('roles', ADMIN\RoleController::class)->except('show');
    Route::resource('permissions', ADMIN\PermissionController::class)->only('index', 'store');

    // Settings
    Route::resource('addons', ADMIN\AddonController::class)->only('index', 'store');
    Route::resource('settings', ADMIN\SettingController::class)->only('index', 'update');
    Route::resource('system-settings', ADMIN\SystemSettingController::class)->only('index', 'store');
    Route::resource('login-pages', ADMIN\AcnooLoginPageController::class)->only('index', 'update');

    // Gateway
    Route::resource('gateways', ADMIN\GatewayController::class)->only('index', 'update');

    Route::resource('currencies', ADMIN\AcnooCurrencyController::class)->except('show');
    Route::post('currencies/filter', [ADMIN\AcnooCurrencyController::class, 'acnooFilter'])->name('currencies.filter');
    Route::match(['get', 'post'], 'currencies/default/{id}', [ADMIN\AcnooCurrencyController::class, 'default'])->name('currencies.default');
    Route::post('currencies/delete-all', [ADMIN\AcnooCurrencyController::class,'deleteAll'])->name('currencies.delete-all');

    // Notifications manager
    Route::prefix('notifications')->controller(ADMIN\NotificationController::class)->name('notifications.')->group(function () {
        Route::get('/', 'mtIndex')->name('index');
        Route::get('/{id}', 'mtView')->name('mtView');
        Route::get('view/all/', 'mtReadAll')->name('mtReadAll');
    });

    // Add these new routes for orders
    Route::resource('orders', ADMIN\OrderController::class)->only(['index', 'show']);
    Route::put('orders/{id}/status', [ADMIN\OrderController::class, 'updateStatus'])->name('orders.updateStatus');
});
