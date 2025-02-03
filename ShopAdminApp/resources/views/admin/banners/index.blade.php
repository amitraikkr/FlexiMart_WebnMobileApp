@extends('layouts.master')

@section('title')
    {{ __('Promotion') }}
@endsection

@section('main_content')
    <div class="erp-table-section">
        <div class="container-fluid">
            <div class="card">
                <div class="card-bodys">
                    <div class="table-header p-16">
                        <h4>{{ __('Ad Promotion') }}</h4>
                        @can('banners-create')
                            <a type="button" href="#create-banner-modal" data-bs-toggle="modal" class="add-order-btn rounded-2 active" class="btn btn-primary"><i class="fas fa-plus-circle me-1"></i> {{ __('Add Ad Promotion') }}</a>
                        @endcan
                    </div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap">

                        <div class="table-top-form p-16-0">
                            <form action="{{ route('admin.banners.filter') }}" method="post" class="filter-form mb-0" table="#banner-data">
                                @csrf
                                <div class="table-top-left d-flex gap-3 margin-l-16">
                                    <div class="gpt-up-down-arrow position-relative">
                                        <select name="per_page" class="form-control">
                                            <option value="10">{{ __('Show- 10') }}</option>
                                            <option value="25">{{ __('Show- 25') }}</option>
                                            <option value="50">{{ __('Show- 50') }}</option>
                                            <option value="100">{{ __('Show- 100') }}</option>
                                        </select>
                                        <span></span>
                                    </div>

                                    <div class="table-search position-relative">
                                        <input class="form-control searchInput" type="text" name="search" placeholder="{{ __('Search...') }}" value="{{ request('search') }}">
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
                                @can('banners-delete')
                                    <th class='striped-th'>
                                        <div class="d-flex align-items-center gap-1">

                                            <label class="table-custom-checkbox">
                                                <input type="checkbox" class="table-hidden-checkbox selectAllCheckbox">
                                                <span class="table-custom-checkmark custom-checkmark"></span>
                                            </label>
                                            <i class="fal fa-trash-alt delete-selected"></i>
                                        </div>
                                    </th>
                                @endcan

                                <th class='striped-th'>{{ __('SL') }}.</th>
                                <th class='striped-th'>{{ __('Name') }}</th>
                                <th class='striped-th'>{{ __('Image') }}</th>
                                <th class='striped-th'>{{ __('Status') }}</th>
                                <th class='striped-th'>{{ __('Action') }}</th>
                            </tr>
                        </thead>
                        <tbody id="banner-data" class="searchResults">
                            @include('admin.banners.search')
                        </tbody>
                    </table>
                </div>
                <div class="mt-3">
                    {{ $banners->links('vendor.pagination.bootstrap-5') }}
                </div>
            </div>
        </div>
    </div>
@endsection

@push('modal')
    @include('admin.banners.create')
    @include('admin.banners.edit')
    @include('admin.components.multi-delete-modal')
@endpush




