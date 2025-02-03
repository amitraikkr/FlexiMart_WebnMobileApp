@extends('layouts.master')

@section('main_content')
    <div class="erp-table-section">
        <div class="container-fluid">
            <div class="card">
                <div class="card-bodys ">
                    <div class="table-header p-16">
                        <h4>{{ __('Staff List') }}</h4>

                        @can('users-create')
                            <a href="{{ route('admin.users.create') }}" class="theme-btn print-btn text-light">
                                <i class="far fa-plus" aria-hidden="true"></i>
                                {{ __('Add Staff') }}
                            </a>
                        @endcan
                    </div>

                    <div class="d-flex align-items-center justify-content-between flex-wrap">
                        <div class="table-top-form p-16-0">
                            <form action="{{ route('admin.users.filter') }}" method="post" class="filter-form" table="#users-data">
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

                    <div class="responsive-table m-0">
                        <table class="table bg-striped" id="datatable">
                            <thead>
                                <tr>
                                    <th class='striped-th'>
                                        <div class="d-flex align-items-center gap-1">
                                            <label class="table-custom-checkbox">
                                                <input type="checkbox" class="table-hidden-checkbox selectAllCheckbox">
                                                <span class="table-custom-checkmark custom-checkmark"></span>
                                            </label>
                                            <i class="fal fa-trash-alt delete-selected"></i>
                                        </div>
                                    </th>
                                    <th class='striped-th'>{{ __('SL') }}.</th>
                                    <th class="text-start striped-th">{{ __('Name') }}</th>
                                    <th class="text-start striped-th">{{ __('Phone') }}</th>
                                    <th class="text-start striped-th">{{ __('User Email') }}</th>
                                    <th class="text-start striped-th">{{ __('User Role') }}</th>
                                    <th class='striped-th'>{{ __('Action') }}</th>
                                </tr>
                            </thead>
                            <tbody id="users-data" class="searchResults">
                                @include('admin.users.datas')
                            </tbody>
                        </table>
                    </div>
                    <div class="mt-3">
                        {{ $users->links('vendor.pagination.bootstrap-5') }}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="User-view">
        <div class="modal-dialog modal-dialog-centered modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5">{{ __('View') }}</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body order-form-section">
                    <div class="costing-list">
                        <ul>
                            <li><span>{{ __('Name') }}</span> <span>:</span> <span id="staff_view_name"></span></li>
                            <li><span>{{ __('Phone') }}</span> <span>:</span> <span id="staff_view_phone_number"></span>
                            </li>

                            <li><span>{{ __('Email') }}</span> <span>:</span> <span id="staff_view_email_number"></span>
                            </li>

                            <li><span>{{ __('Role') }}</span> <span>:</span> <span id="staff_view_role"></span>
                            </li>

                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('modal')
    @include('admin.components.multi-delete-modal')
@endpush
