@foreach ($businesses as $business)
    <tr class="{{ $loop->iteration % 2 == 0 ? 'even-row' : 'odd-row' }}">
        <td class="w-60 checkbox table-data">
            <label class="table-custom-checkbox">
                <input type="checkbox" name="ids[]" class="table-hidden-checkbox checkbox-item"
                    value="{{ $business->id }}" data-url="{{ route('admin.business.delete-all') }}">
                <span class="table-custom-checkmark custom-checkmark"></span>
            </label>
        </td>
        <td class='table-data'>{{ $loop->index + 1 }} <i class="{{ request('id') == $business->id ? 'fas fa-bell text-red' : '' }}"></i></td>
        <td class='table-data'>{{ $business->companyName }}</td>
        <td class='table-data'>{{ $business->category->name ?? '' }}</td>
        <td class='table-data'>{{ $business->phoneNumber }}</td>
        <td class='table-data'>
        <div class="
            @if($business->enrolled_plan?->plan?->subscriptionName === 'Premium') btn-premium
            @elseif($business->enrolled_plan?->plan?->subscriptionName === 'Free') btn-free
            @elseif($business->enrolled_plan?->plan?->subscriptionName === 'Standard') btn-standard
            @else btn-danger
            @endif">
            {{ $business->enrolled_plan->plan->subscriptionName ?? '' }}
        </div>
        </td>
        <td class='table-data'>{{ formatted_date($business->subscriptionDate) }}</td>
        <td class='table-data'>{{ formatted_date($business->will_expire) }}</td>
        <td class='table-data' class="print-d-none">
            <div class="dropdown table-action">
                <button type="button" data-bs-toggle="dropdown">
                    <i class="far fa-ellipsis-v"></i>
                </button>
                <ul class="dropdown-menu">
                    <li>
                        <a href="#business-upgrade-modal" class="view-btn business-upgrade-plan" data-bs-toggle="modal"
                            data-id="{{ $business->id }}" data-name="{{ $business->companyName }}" data-url="{{ route('admin.business.upgrade.plan', $business->id) }}">
                            <i class="fas fa-paper-plane"></i>
                            {{ __('Upgrade Plan') }}
                        </a>
                    </li>
                    <li>
                        <a href="#business-view-modal" class="view-btn business-view" data-bs-toggle="modal"
                            data-image="{{ asset($business->pictureUrl ?? 'assets/img/default-shop.svg') }}"
                            data-name="{{ $business->companyName }}" data-address="{{ $business->address }}"
                            data-category="{{ $business->category->name ?? '' }}"
                            data-phone="{{ $business->phoneNumber }}"
                            data-package="{{ $business->enrolled_plan->plan->subscriptionName ?? '' }}"
                            data-last_enroll="{{ formatted_date($business->subscriptionDate) }}"
                            data-expired_date="{{ formatted_date($business->will_expire) }}"
                            data-created_date="{{ formatted_date($business->created_at) }}">
                            <i class="fal fa-eye"></i>
                            {{ __('View') }}
                        </a>

                    </li>
                    <li>
                        <a href="{{ route('admin.business.edit', $business->id) }}" class="">
                            <i class="fal fa-edit"></i>
                            {{ __('Edit') }}
                        </a>
                    </li>
                    <li>
                        <a href="{{ route('admin.business.destroy', $business->id) }}" class="confirm-action"
                            data-method="DELETE">
                            <i class="fal fa-trash-alt"></i>
                            {{ __('Delete') }}
                        </a>
                    </li>
                </ul>
            </div>
        </td>
    </tr>
@endforeach
