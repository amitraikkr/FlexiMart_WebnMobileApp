@foreach ($expire_shops as $subscriber)
<tr class="{{ $loop->iteration % 2 == 0 ? 'even-row' : 'odd-row' }}">
    <td class='table-data'>{{ $loop->index + 1 }} <i class="{{ request('id') == $subscriber->id ? 'fas fa-bell text-red' : '' }}"></i>
    </td>
    <td class='table-data'>{{ $subscriber->business->companyName ?? 'N/A' }}</td>
    <td class='table-data'>{{ optional($subscriber->business->category)->name ?? 'N/A' }}</td>
    <td class='table-data'>{{ $subscriber->business->phoneNumber ?? 'N/A' }}</td>
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
    <td class='table-data'>{{ formatted_date($subscriber->business->will_expire) }}</td>
</tr>
@endforeach
