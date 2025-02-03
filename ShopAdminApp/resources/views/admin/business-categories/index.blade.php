@extends('layouts.master')

@section('title')
{{ __('Shop Category') }}
@endsection

@section('main_content')
<div class="erp-table-section">
    <div class="container-fluid">
        <div class="card">
            <div class="card-bodys">
                <div class="table-header p-16">
                    <h4>{{ __('Shop Category') }}</h4>
                    @can('business-categories-create')
                    <a type="button" href="#create-business-category" data-bs-toggle="modal" class="add-order-btn rounded-2 active" class="btn btn-primary"><i class="fas fa-plus-circle me-1"></i> {{ __('Add Category') }}</a>
                    @endcan
                </div>
                <div class="d-flex align-items-center justify-content-between flex-wrap">
                    <div class="table-top-form p-16-0">
                        <form action="{{ route('admin.business-categories.filter') }}" method="post" class="filter-form m-0" table="#business-category-data">
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
                                    <input type="text" name="search" class="form-control" placeholder="{{ __('Search...') }}">
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
                        @can('business-categories-delete')
                            <th class='striped-th'>
                                <div class="d-flex align-items-center gap-3">
                                    <label class="table-custom-checkbox">
                                        <input type="checkbox" class="table-hidden-checkbox selectAllCheckbox">
                                        <span class="table-custom-checkmark custom-checkmark"></span>
                                    </label>
                                    <i class="fal fa-trash-alt delete-selected"></i>
                                </div>
                            </th>
                        @endcan
                        <th class='striped-th'>{{ __('SL') }}.</th>
                        <th class="text-start striped-th">{{ __('Category Name') }}</th>
                        <th class='striped-th'>{{ __('Status') }}</th>
                        <th class='striped-th'>{{ __('Action') }}</th>
                    </tr>
                    </thead>
                    <tbody id="business-category-data" class="searchResults">
                        @include('admin.business-categories.datas')
                    </tbody>
                </table>
            </div>
            <div class="mt-3">
                {{ $categories->links('vendor.pagination.bootstrap-5') }}
            </div>
        </div>
    </div>
</div>

@endsection

@push('modal')
    @include('admin.business-categories.create')
    @include('admin.business-categories.edit')
    @include('admin.components.multi-delete-modal')
@endpush

@push('js')
    <script src="{{ asset('assets/js/custom/custom.js') }}"></script>
@endpush
