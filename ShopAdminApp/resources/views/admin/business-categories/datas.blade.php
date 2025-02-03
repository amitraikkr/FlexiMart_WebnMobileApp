@foreach($categories as $category)
    <tr class="{{ $loop->iteration % 2 == 0 ? 'even-row' : 'odd-row' }}">
        <td  class="w-60 checkbox table-data">
            <label class="table-custom-checkbox">
                <input type="checkbox" class="table-hidden-checkbox checkbox-item" name="ids[]" value="{{ $category->id }}" data-url="{{ route('admin.business-categories.delete-all') }}">
                <span class="table-custom-checkmark custom-checkmark"></span>
            </label>
        </td>
        <td class='table-data'>{{ $loop->index+1 }}</td>
        <td class="text-start table-data">{{ $category->name }}</td>
        <td class="text-center table-data">
            @can('business-categories-update')
                <label class="switch">
                    <input type="checkbox" {{ $category->status == 1 ? 'checked' : '' }} class="status" data-url="{{ route('admin.business-categories.status', $category->id) }}">
                    <span class="slider round"></span>
                </label>
            @else
                <div class="badge bg-{{ $category->status == 1 ? 'success' : 'danger' }}">
                    {{ $category->status == 1 ? 'Active' : 'Deactive' }}
                </div>
            @endcan
        </td>
        <td class="print-d-none table-data">
            <div class="dropdown table-action">
                <button type="button" data-bs-toggle="dropdown">
                    <i class="far fa-ellipsis-v"></i>
                </button>
                <ul class="dropdown-menu">
                    @can('business-categories-update')
                        <li>
                            <a href="#edit-business-category" class="edit-business-category-btn" data-bs-toggle="modal"
                                data-url="{{ route('admin.business-categories.update', $category->id) }}"
                                data-name="{{ $category->name }}">
                                <i class="fal fa-edit"></i>
                                {{ __('Edit') }}
                            </a>
                        </li>
                    @endcan

                    @can('business-categories-delete')
                        <li>
                            <a href="{{ route('admin.business-categories.destroy', $category->id) }}" class="confirm-action" data-method="DELETE">
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
