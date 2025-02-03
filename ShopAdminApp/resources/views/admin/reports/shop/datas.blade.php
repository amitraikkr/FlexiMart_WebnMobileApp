@foreach ($allshops as $business)
    <tr class="{{ $loop->iteration % 2 == 0 ? 'even-row' : 'odd-row' }}">
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
    </tr>
@endforeach
