@foreach ($subscribers as $subscriber)
    <tr class="{{ $loop->iteration % 2 == 0 ? 'even-row' : 'odd-row' }}">
        <td class='table-data'>{{ $loop->index + 1 }} <i class="{{ request('id') == $subscriber->id ? 'fas fa-bell text-red' : '' }}"></i>
        </td>
        <td class='table-data'>{{ formatted_date($subscriber->created_at) }}</td>
        <td class='table-data'>{{ $subscriber->business->companyName ?? 'N/A' }}</td>
        <td class='table-data'>{{ optional($subscriber->business->category)->name ?? 'N/A' }}</td>
        <!-- <td class='table-data'>{{ $subscriber->plan->subscriptionName ?? 'N/A' }}</td> -->
        <td class='table-data'>
        <button class=" 
            @if($subscriber->plan->subscriptionName === 'Premium') btn-premium 
            @elseif($subscriber->plan->subscriptionName === 'Free') btn-free 
            @elseif($subscriber->plan->subscriptionName === 'Standard') btn-standard 
            @else btn-danger 
            @endif">
            {{ $subscriber->plan->subscriptionName ?? 'N/A' }}
        </button>
        </td>
        <td class='table-data'>{{ formatted_date($subscriber->created_at) }}</td>
        <td class='table-data'>{{ $subscriber->created_at ? formatted_date($subscriber->created_at->addDays($subscriber->duration)) : '' }}</td>
        <td class='table-data'>{{ $subscriber->gateway->name ?? 'N/A' }}</td>
        <td class='table-data'>
            <div class="badge {{ $subscriber->payment_status == 'unpaid' ? 'badge-unpaid' : 'badge-paid' }}">
                {{ ucfirst($subscriber->payment_status) }}
            </div>
        </td>
        <td class='table-data'>
            <div class="dropdown table-action">
                <button type="button" data-bs-toggle="dropdown">
                    <i class="far fa-ellipsis-v"></i>
                </button>
                <ul class="dropdown-menu">
                    <li>
                        <a href="#approve-modal" class="modal-approve" data-bs-toggle="modal" data-bs-target="#approve-modal" data-url="{{ route('admin.subscription-reports.paid', $subscriber->id) }}">
                            <i class="fal fa-edit"></i>
                           {{ __('Paid') }}
                        </a>
                    </li>

                    <li>
                        <a href="#reject-modal" class="modal-reject" data-bs-toggle="modal" data-bs-target="#reject-modal" data-url="{{ route('admin.subscription-reports.reject', $subscriber->id) }}">
                            <i class="fal fa-trash-alt"></i>
                            {{ __('Reject') }}
                        </a>
                    </li>
                </ul>
            </div>
        </td>
    </tr>
@endforeach

<div class="modal fade" id="reject-modal">
    <div class="modal-dialog modal-dialog-centered modal-md">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5">{{ __('Why are you reject It?') }}</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="personal-info">
                    <form action="" method="post" enctype="multipart/form-data"
                        class="add-brand-form pt-0 ajaxform_instant_reload modalRejectForm">
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
