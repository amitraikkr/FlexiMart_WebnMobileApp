@foreach($plans as $plan)
    <tr class="{{ $loop->iteration % 2 == 0 ? 'even-row' : 'odd-row' }}">
        @can('plans-delete')
            <td class="w-60 checkbox table-data">
                <label class="table-custom-checkbox">
                    <input type="checkbox" name="ids[]" class="table-hidden-checkbox checkbox-item" value="{{ $plan->id }}" data-url="{{ route('admin.plans.delete-all') }}">
                    <span class="table-custom-checkmark custom-checkmark"></span>
                </label>
            </td>
        @endcan
        <td class='table-data'>{{ ($plans->perPage() * ($plans->currentPage() - 1)) + $loop->iteration }}</td>
        <td  class="text-start table-data">{{ $plan->subscriptionName }} </td>
        <td class='table-data'>{{ $plan->duration }} </td>
        <td class="fw-bold text-dark table-data">{{ $plan->offerPrice ? currency_format($plan->offerPrice) : '' }} </td>
        <td class="fw-bold text-dark table-data">{{ currency_format($plan->subscriptionPrice) }} </td>

        <td class="text-center table-data">
            @can('plans-update')
                <label class="switch">
                    <input type="checkbox" {{ $plan->status == 1 ? 'checked' : '' }} class="status" data-url="{{ route('admin.plans.status', $plan->id)}}">
                    <span class="slider round"></span>
                </label>
            @else
                <div class="badge bg-{{ $plan->status == 1 ? 'success' : 'danger' }}">
                    {{ $plan->status == 1 ? 'Active' : 'Deactive' }}
                </div>
            @endcan
        </td>
        <td class='table-data'>
            <div class="dropdown table-action">
                <button type="button" data-bs-toggle="dropdown">
                    <i class="far fa-ellipsis-v"></i>
                </button>
                <ul class="dropdown-menu">
                    @can('plans-update')
                        <li>
                            <a href="{{ route('admin.plans.edit', $plan->id) }}" class="">
                                <i class="fal fa-edit"></i>
                                {{ __('Edit') }}
                            </a>
                        </li>
                    @endcan
                    @can('plans-delete')
                        <li>
                            <a href="{{ route('admin.plans.destroy', $plan->id) }}" class="confirm-action" data-method="DELETE">
                                <i class="fal fa-trash-alt"></i>
                                {{ __('Delete') }}
                            </a>
                        </li>
                    @endcan
                </ul>
            </div>
        </td>
    </tr>
@endforeach

