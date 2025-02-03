@extends('layouts.master')

@section('title')
    {{ __('Subscriptions List') }}
@endsection

@section('main_content')
<div class="erp-table-section">
    <div class="container-fluid">
        <div class="card">
            <div class="card-bodys ">
                <div class="table-header p-16">
                    <h4>{{ __('Subscriptions List') }}</h4>
                </div>
                <div class="d-flex align-items-center justify-content-between flex-wrap">
                    <div class="table-top-form p-16-0">
                        <form action="{{ route('admin.subscription-reports.filter') }}" method="post" class="filter-form" table="#subscriber-data">
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
                <table class="table  bg-striped" id="datatable">
                    <thead>
                    <tr>
                        <th class='striped-th'>{{ __('SL') }}.</th>
                        <th class='striped-th'>{{ __('Date') }}</th>
                        <th class='striped-th'>{{ __('Shop Name') }}</th>
                        <th class='striped-th'>{{ __('Category') }}</th>
                        <th class='striped-th'>{{ __('Package') }}</th>
                        <th class='striped-th'>{{ __('Started') }}</th>
                        <th class='striped-th'>{{ __('End') }}</th>
                        <th class='striped-th'>{{ __('Gateway Method') }}</th>
                        <th class='striped-th'>{{ __('Status') }}</th>
                        <th class='striped-th'>{{ __('Action') }}</th>
                    </tr>
                    </thead>
                    <tbody  id="subscriber-data" class="searchResults">
                        @include('admin.subscribers.datas')
                    </tbody>
                </table>
            </div>
            <div class="mt-3">
                {{ $subscribers->links('vendor.pagination.bootstrap-5') }}
            </div>
        </div>
    </div>
</div>

@endsection

<div class="modal fade" id="approve-modal">
    <div class="modal-dialog modal-dialog-centered modal-md">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5">{{ __('Are you sure?') }}</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="personal-info">
                    <form action="" method="post" enctype="multipart/form-data"
                        class="add-brand-form pt-0 ajaxform_instant_reload modalApproveForm">
                        @csrf
                        <div class="row">
                            <div class="mt-3">
                                <label class="custom-top-label">{{ __('Enter Reason') }}</label>
                               <textarea name="notes" rows="2" class="form-control" placeholder="{{ __('Enter reason') }}"></textarea>
                            </div>
                        </div>

                        <div class="col-lg-12">
                            <div class="button-group text-center mt-5">
                                <a href="" class="theme-btn border-btn m-2">{{__('Cancel')}}</a>
                                <button class="theme-btn m-2 submit-btn">{{__('Save')}}</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

@push('js')
    <script src="{{ asset('assets/js/custom/custom.js') }}"></script>
@endpush
