<?php

namespace App\Http\Controllers\Admin;

use Carbon\Carbon;
use App\Models\Business;
use Illuminate\Http\Request;
use App\Models\PlanSubscribe;
use App\Http\Controllers\Controller;

class AcnooReportController extends Controller
{
    public function showAllShop()
    {
        $allshops = Business::with('enrolled_plan:id,plan_id', 'enrolled_plan.plan:id,subscriptionName', 'category:id,name')->latest()->paginate(20);
        return view('admin.reports.shop.index', compact('allshops'));
    }

    public function acnooFilter(Request $request)
    {
        $search = $request->input('search');
        $allshops = Business::when($search, function ($q) use ($search) {
            $q->where(function ($q) use ($search) {
                $q->where('companyName', 'like', '%' . $search . '%')
                    ->orWhere('phoneNumber', 'like', '%' . $search . '%')
                    ->orWhereHas('category', function ($q) use ($search) {
                        $q->where('name', 'like', '%' . $search . '%');
                    })
                    ->orWhereHas('enrolled_plan.plan', function ($q) use ($search) {
                        $q->where('subscriptionName', 'like', '%' . $search . '%');
                    });
            });
        })
            ->latest()
            ->paginate($request->per_page ?? 10);

        if ($request->ajax()) {
            return response()->json([
                'data' => view('admin.reports.shop.datas', compact('allshops'))->render()
            ]);
        }

        return redirect(url()->previous());
    }

    public function showExpireShop()
    {
        $expire_shops = PlanSubscribe::whereHas('business', function ($query) {
            $query->where('will_expire', '<', Carbon::today());
        })
            ->with([
                'plan:id,subscriptionName',
                'business:id,companyName,business_category_id,will_expire,phoneNumber',
                'business.category:id,name'
            ])
            ->latest()
            ->paginate(20);

        return view('admin.reports.expire-shop.index', compact('expire_shops'));
    }

    public function acnooFilterExpire(Request $request)
    {
        $search = $request->input('search');
        $expire_shops = PlanSubscribe::with([
            'plan:id,subscriptionName',
            'business:id,companyName,business_category_id,will_expire,phoneNumber',
            'business.category:id,name'
        ])
            ->whereHas('business', function ($query) {
                $query->where('will_expire', '<', Carbon::today());
            })

            ->when($search, function ($q) use ($search) {
                $q->where(function ($q) use ($search) {
                    $q->where('duration', 'like', '%' . $search . '%')
                        ->orWhereHas('plan', function ($q) use ($search) {
                            $q->where('subscriptionName', 'like', '%' . $search . '%');
                        })
                        ->orWhereHas('business', function ($q) use ($search) {
                            $q->where('companyName', 'like', '%' . $search . '%')
                              ->orwhere('phoneNumber', 'like', '%' . $search . '%')
                                ->orWhereHas('category', function ($q) use ($search) {
                                    $q->where('name', 'like', '%' . $search . '%');
                        });
                    });
                });
            })
            ->latest()
            ->paginate($request->per_page ?? 20);

        if ($request->ajax()) {
            return response()->json([
                'data' => view('admin.reports.expire-shop.datas', compact('expire_shops'))->render()
            ]);
        }

        return redirect(url()->previous());
    }
}
