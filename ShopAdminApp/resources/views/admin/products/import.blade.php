@extends('layouts.master')

@section('title')
    {{__('Import Products')}}
@endsection

@section('main_content')
    <div class="container-fluid">
        <div class="card">
            <div class="card-body">
                <div class="table-header p-16">
                    <h4>{{__('Import Products from CSV')}}</h4>
                    <small class="text-muted">{{__('Upload CSV file to bulk import products')}}</small>
                </div>

                <div class="row p-16">
                    <div class="col-md-6">
                        <form action="{{ route('admin.products.import') }}" method="POST" enctype="multipart/form-data" class="ajaxform_instant_reload">
                            @csrf
                            
                            <div class="form-group mb-3">
                                <label for="csv_file">{{__('Choose CSV File')}}</label>
                                <input type="file" name="csv_file" id="csv_file" class="form-control" accept=".csv" required>
                                <small class="text-muted">{{__('File must be in CSV format')}}</small>
                            </div>

                            <div class="form-group mb-3">
                                <a href="{{ route('admin.products.download-sample') }}" class="btn btn-sm btn-info">
                                    <i class="fas fa-download"></i> {{__('Download Sample CSV')}}
                                </a>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-upload"></i> {{__('Upload and Import')}}
                            </button>
                        </form>
                    </div>

                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h5>{{__('CSV Format Instructions')}}</h5>
                                <p class="text-muted">{{__('Your CSV file should have the following columns:')}}</p>
                                <ul class="list-unstyled">
                                    <li>productName (required)</li>
                                    <li>category_id (required)</li>
                                    <li>brand_id</li>
                                    <li>productCode</li>
                                    <li>productDealerPrice</li>
                                    <li>productPurchasePrice</li>
                                    <li>productSalePrice</li>
                                    <li>productWholeSalePrice</li>
                                    <li>productStock</li>
                                    <li>productManufacturer</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
