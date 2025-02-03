@extends('layouts.master')

@section('title')
    {{ __('Expire Shop') }}
@endsection

@section('main_content')
<div class="erp-table-section">
    <div class="container-fluid">
        <div class="card">
            <div class="card-bodys ">
                <div class="table-header p-16">
                    <h4>{{ __('Expire Shop') }}</h4>
                </div>
                <div class="d-flex align-items-center justify-content-between flex-wrap">
                    <div class="table-top-form p-16-0">
                        <form action="{{ route('admin.expire-shop-reports.filter') }}" method="post" class="filter-form" table="#expire-shop-data">
                            @csrf

                            <div class="table-top-left d-flex gap-3 margin-l-16">
                                <div class="gpt-up-down-arrow position-relative">
                                    <select name="per_page" class="form-control">
                                        <option value="10">{{__('Show- 10')}}</option>
                                        <option value="25">{{__('Show- 25')}}</option>
                                        <option value="50">{{__('Show- 50')}}</option>
                                        <option value="100">{{__('Show- 100')}}</option>
                                    </select>
                                    <span></span>
                                </div>

                                <div class="table-search position-relative">
                                    <input class="form-control" type="text" name="search"
                                        placeholder="{{ __('Search...') }}" value="{{ request('search') }}">
                                    <span class="position-absolute">
                                        <img src="{{ asset('assets/images/search.svg') }}" alt="">
                                    </span>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="responsive-table m-0">
                <table class="table bg-striped" id="datatable">
                    <thead>
                    <tr>
                        <th class='striped-th'> {{ __('SL') }}. </th>
                        <th class='striped-th'> {{ __('Business Name') }} </th>
                        <th class='striped-th'> {{ __('Business Category') }} </th>
                        <th class='striped-th'> {{ __('Phone') }} </th>
                        <th class='striped-th'> {{ __('Package') }} </th>
                        <th class='striped-th'> {{ __('Last Enroll') }} </th>
                        <th class='striped-th'> {{ __('Expired Date') }} </th>
                    </tr>
                    </thead>
                    <tbody id="expire-shop-data" class="searchResults">
                        @include('admin.reports.expire-shop.datas')
                    </tbody>
                </table>
            </div>
            <div class="mt-3">
                {{ $expire_shops->links('vendor.pagination.bootstrap-5') }}
            </div>
        </div>
    </div>
</div>

@endsection

