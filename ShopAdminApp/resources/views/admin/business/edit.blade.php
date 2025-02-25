@extends('layouts.master')

@section('title')
    {{ __('Edit Shop') }}
@endsection

@section('main_content')
<div class="erp-table-section">
    <div class="container-fluid">
        <div class="card border-0">
            <div class="card-bodys">
                <div class="table-header p-16">
                    <h4>{{ __('Edit Shop') }}</h4>
                    @can('plans-read')
                        <a href="{{ route('admin.business.index') }}" class="add-order-btn rounded-2 {{ Route::is('admin.users.create') ? 'active' : '' }}"><i class="far fa-list" aria-hidden="true"></i> {{ __('Shop List') }}</a>
                    @endcan
                </div>
                <div class="order-form-section p-16">
                    <form action="{{ route('admin.business.update', $business->id) }}" method="POST" class="ajaxform_instant_reload">
                        @csrf
                        @method('PUT')
                        <div class="add-suplier-modal-wrapper d-block">
                            <div class="row ">
                                <div class="col-lg-9">
                                    <div class="row">

                                        <div class="col-lg-6 mb-2">
                                            <label>{{ __('Business Name') }}</label>
                                            <input type="text" name="companyName" value="{{ $business->companyName }}" required class="form-control" placeholder="{{ __('Enter Company Name') }}">
                                        </div>

                                        <div class="col-lg-6 mb-2">
                                            <label>{{__('Business Category')}}</label>
                                            <div class="gpt-up-down-arrow position-relative">
                                                <select name="business_category_id" required
                                                        class="form-control table-select w-100 role">
                                                    <option value=""> {{__('Select Business Category')}}</option>
                                                    @foreach ($categories as $category)
                                                        <option @selected($category->id == $business->business_category_id) value="{{ $category->id }}"> {{ ucfirst($category->name) }} </option>
                                                    @endforeach
                                                </select>
                                                <span></span>
                                            </div>
                                        </div>

                                        <div class="col-lg-6 mb-2">
                                            <label>{{ __('Subscription Plan') }}</label>
                                            <div class="gpt-up-down-arrow position-relative">
                                                <select name="plan_subscribe_id" class="form-control table-select w-100 role">
                                                    <option value="">{{ __('Select One') }}</option>
                                                    @foreach ($plans as $plan)
                                                        <option @selected($plan->id == $business->plan_subscribe_id ) value="{{ $plan->id }}">
                                                            {{ ucfirst($plan->subscriptionName) }}
                                                        </option>
                                                    @endforeach
                                                </select>
                                                <span></span>
                                            </div>
                                        </div>

                                        <div class="col-lg-6 mb-2">
                                            <label>{{ __('Phone') }}</label>
                                            <input type="text" name="phoneNumber" value="{{ $business->phoneNumber }}" required class="form-control" placeholder="{{ __('Enter Phone Number') }}">
                                        </div>

                                        <div class="col-lg-6 mb-2">
                                            <label>{{ __('Email') }}</label>
                                            <input type="email" name="email" value="{{ $user->email }}" class="form-control" placeholder="{{ __('Enter Email') }}">
                                        </div>

                                        <div class="col-lg-6 mb-2">
                                            <label>{{ __('Shop Opening Balance') }}</label>
                                            <input type="number" name="shopOpeningBalance" value="{{ $business->shopOpeningBalance }}" required class="form-control" placeholder="{{ __('Enter Balance') }}">
                                        </div>

                                        <div class="col-lg-6 mb-2">
                                            <label>{{ __('Address') }}</label>
                                            <input type="text" name="address" value="{{ $business->address }}" required class="form-control" placeholder="{{ __('Enter Address') }}">
                                        </div>

                                        <div class="col-lg-6 mb-2">
                                            <label>{{__('Password')}}</label>
                                            <input type="password" name="password" class="form-control" placeholder="{{ __('Enter Password') }}">
                                        </div>

                                        <div class="col-lg-12">
                                            <div class="button-group text-center mt-5">
                                                <button type="reset" class="theme-btn border-btn m-2">{{ __('Cancel') }}</button>
                                                <button class="theme-btn m-2 submit-btn">{{ __('Save') }}</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3 pb-4">
                                 <h5 class='drop-img-title'>{{ __('Image') }}</h5>
                                 <div class="d-flex align-items-center justify-content-start mt-2 w-100 upload-drag-img" id="uploadContainer">
                                    <label class="upload-v4 start-0 bg-none">
                                        <div class="drag-img bg-light d-flex align-items-center justify-content-center">
                                            <input type="file" accept="image/*" name="pictureUrl" id="imageInput" class="d-none" data-id="image" accept="image/*">
                                            <div class="d-flex align-items-center justify-content-center flex-column">
                                                <img src="{{ asset($business->pictureUrl ?? 'assets/images/icons/placeholder.svg') }}" id="imagePreview" class="input-img" alt="Image Preview">
                                                <p class='text-center'>
                                                    {{ __('Drag & drop your Image') }} <br> {{ __('or') }} <span class='browse'>{{ __('Browse') }}</span>
                                                </p>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('js')
    <script src="{{ asset('assets/js/custom/custom.js') }}"></script>
@endpush
