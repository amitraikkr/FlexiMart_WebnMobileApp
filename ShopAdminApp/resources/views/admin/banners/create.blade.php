<div class="modal modal-md fade" id="create-banner-modal" tabindex="-1" aria-labelledby="exampleModalLabel"
    aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">{{ __('Add Ad Promotion') }}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="{{ route('admin.banners.store') }}" method="post" enctype="multipart/form-data" class="ajaxform_instant_reload ">
                    @csrf
                    <div class="mt-3">
                        <label>{{ __('Name') }}</label>
                        <input type="text" class="form-control" name="name" id="name" required placeholder="{{ __('Enter Ad name') }}">
                    </div>

                    <div class="mt-3 position-relative">
                        <label>{{ __('Image') }}</label>
                        <div class="upload-img-v2">
                            <div class="d-flex upload-v4 align-items-center gap-3 ">
                                <input name="imageUrl" onchange="document.getElementById('profile-img').src = window.URL.createObjectURL(this.files[0])" class="form-control" type="file" id="formFile">
                                <div class="img-wrp">
                                    <img src="{{ asset('assets/images/icons/no-img.svg') }}" alt="user" id="profile-img">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-12">
                        <div class="button-group text-center mt-5">
                            <button type="reset" class="theme-btn border-btn m-2">{{ __('Cancel') }}</button>
                            <button class="theme-btn m-2 submit-btn">{{ __('Save') }}</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
