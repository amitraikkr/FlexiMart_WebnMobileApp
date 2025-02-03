<nav class="side-bar">
    <div class="side-bar-logo">
        <a href="javascript:void(0)"><img
                src="{{ asset(get_option('general')['admin_logo'] ?? 'assets/images/logo/backend_logo.png') }}"
                alt="Logo"></a>
        <button class="close-btn"><i class="fal fa-times"></i></button>
    </div>
    <div class="side-bar-manu">
        <ul>
            @canany(['dashboard-read'])
                <li class="{{ Request::routeIs('admin.dashboard.index') ? 'active' : '' }}">
                    <a href="{{ route('admin.dashboard.index') }}" class="active">
                        <span class="sidebar-icon">
                            <svg class='' width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M16 19.75H4C1.582 19.75 0.25 18.418 0.25 16V9.65004C0.25 7.52704 0.835992 6.93401 1.79199 6.14101L7.91199 1.01003C9.12099 -0.00497067 10.879 -0.00497067 12.088 1.01003L18.208 6.14101C19.164 6.93401 19.75 7.52804 19.75 9.65004V16C19.75 18.418 18.418 19.75 16 19.75ZM10 1.75002C9.601 1.75002 9.201 1.88705 8.875 2.16005L2.74902 7.29604C2.00202 7.91604 1.75 8.12502 1.75 9.65102V16.001C1.75 17.578 2.423 18.251 4 18.251H16C17.577 18.251 18.25 17.578 18.25 16.001V9.65102C18.25 8.12502 17.998 7.91604 17.251 7.29604L11.125 2.16005C10.799 1.88605 10.399 1.75002 10 1.75002ZM10 16.25C9.919 16.25 9.83801 16.237 9.76001 16.21C7.82201 15.554 5.75 13.8551 5.75 11.0551V8.83303C5.75 8.49903 5.97197 8.20508 6.29297 8.11208C8.07597 7.60008 8.90695 7.213 9.66895 6.829C9.88395 6.722 10.136 6.72307 10.349 6.83107C11.103 7.21707 11.9251 7.60002 13.6851 8.04702C14.0181 8.13102 14.25 8.43107 14.25 8.77407V11.054C14.25 13.854 12.179 15.553 10.24 16.209C10.162 16.237 10.081 16.25 10 16.25ZM7.25 9.39406V11.056C7.25 13.352 9.208 14.379 10 14.7C10.792 14.379 12.75 13.352 12.75 11.056V9.35305C11.554 9.02205 10.76 8.70603 10.005 8.33803C9.238 8.70803 8.459 9.02606 7.25 9.39406Z" />
                            </svg>
                        </span>
                        {{ __('Dashboard') }}
                    </a>
                </li>
            @endcanany

            @canany(['plans-read'])
                <li class="{{ Route::is('admin.plans.index', 'admin.plans.create', 'admin.plans.edit') ? 'active' : '' }}">
                    <a class="{{ Route::is('admin.plans.index', 'admin.plans.edit') ? 'active' : '' }}" href="{{ route('admin.plans.index') }}">
                        <span class="sidebar-icon">
                            <svg width="18" height="22" viewBox="0 0 18 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M14.4299 0.25H7.57104C5.46105 0.25 4.25098 1.45995 4.25098 3.56995V4.25H3.57202C1.43002 4.25 0.250977 5.43005 0.250977 7.57104V21C0.250977 21.268 0.394 21.515 0.625 21.649C0.741 21.716 0.870977 21.75 1.00098 21.75C1.12898 21.75 1.25805 21.717 1.37305 21.651L7.00098 18.4351L12.6289 21.651C12.8609 21.784 13.147 21.7829 13.377 21.6479C13.608 21.5139 13.751 21.267 13.751 21V16.004L16.6279 17.651C16.7439 17.717 16.872 17.75 17.001 17.75C17.131 17.75 17.261 17.716 17.377 17.649C17.608 17.515 17.751 17.268 17.751 17V3.56995C17.75 1.45995 16.5399 0.25 14.4299 0.25ZM12.25 19.707L7.37207 16.92C7.14207 16.788 6.85793 16.788 6.62793 16.92L1.75 19.708V7.57202C1.75 6.27902 2.27704 5.75098 3.57104 5.75098H10.428C11.722 5.75098 12.249 6.27902 12.249 7.57202V19.707H12.25ZM16.25 15.707L13.75 14.275V7.57104C13.75 5.42904 12.57 4.25 10.429 4.25H5.75V3.56995C5.75 2.27795 6.27707 1.75 7.57007 1.75H14.429C15.722 1.75 16.249 2.27695 16.249 3.56995V15.707H16.25ZM8.43994 7.68103C8.43594 7.68103 8.432 7.68103 8.427 7.68103C7.819 7.68103 7.34702 7.91097 6.99902 8.21497C6.65102 7.91097 6.18005 7.68103 5.57104 7.68103C5.56704 7.68103 5.56211 7.68103 5.55811 7.68103C4.76811 7.68503 4.10301 7.98798 3.63501 8.55798C3.07501 9.23998 2.871 10.228 3.073 11.269C3.564 13.804 6.56001 15.194 6.68701 15.252C6.78601 15.297 6.89105 15.319 6.99805 15.319C7.10505 15.319 7.21008 15.297 7.30908 15.252C7.43608 15.194 10.4311 13.804 10.9231 11.27C11.1251 10.228 10.9211 9.23898 10.3621 8.55798C9.89606 7.98698 9.23094 7.68503 8.43994 7.68103ZM9.4519 10.983C9.1829 12.366 7.665 13.353 7 13.724C6.335 13.352 4.8151 12.366 4.5481 10.983C4.4351 10.399 4.52912 9.83406 4.79712 9.50806C4.97712 9.28906 5.22912 9.18105 5.56812 9.18005C5.56912 9.18005 5.57002 9.18005 5.57202 9.18005C6.06902 9.18005 6.27106 9.69597 6.28906 9.74597C6.39106 10.049 6.67392 10.249 6.99292 10.254C6.99592 10.254 6.99893 10.254 7.00293 10.254C7.31693 10.254 7.60196 10.052 7.70996 9.755C7.73096 9.696 7.93291 9.18005 8.43091 9.18005C8.43191 9.18005 8.43308 9.18005 8.43408 9.18005C8.77408 9.18105 9.02608 9.28906 9.20508 9.50806C9.47108 9.83306 9.5659 10.399 9.4519 10.983Z" />
                            </svg>
                        </span>
                        {{ __('Manage Plans') }}
                    </a>
                </li>
            @endcanany

            @canany(['business-categories-read'])
                <li class="{{ Request::routeIs('admin.business-categories.index','admin.business-categories.create','admin.business-categories.edit') ? 'active' : '' }}">
                    <a href="{{ route('admin.business-categories.index') }}" class="active">
                        <span class="sidebar-icon">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M15.625 19.75H4.375C1.715 19.75 0.25 18.285 0.25 15.625V4.375C0.25 1.715 1.715 0.25 4.375 0.25H15.625C18.285 0.25 19.75 1.715 19.75 4.375V15.625C19.75 18.285 18.285 19.75 15.625 19.75ZM4.375 1.75C2.535 1.75 1.75 2.535 1.75 4.375V15.625C1.75 17.465 2.535 18.25 4.375 18.25H15.625C17.465 18.25 18.25 17.465 18.25 15.625V4.375C18.25 2.535 17.465 1.75 15.625 1.75H4.375ZM14.75 14C14.75 13.586 14.414 13.25 14 13.25H6C5.586 13.25 5.25 13.586 5.25 14C5.25 14.414 5.586 14.75 6 14.75H14C14.414 14.75 14.75 14.414 14.75 14ZM13.25 10C13.25 9.586 12.914 9.25 12.5 9.25H7.5C7.086 9.25 6.75 9.586 6.75 10C6.75 10.414 7.086 10.75 7.5 10.75H12.5C12.914 10.75 13.25 10.414 13.25 10ZM11.75 6C11.75 5.586 11.414 5.25 11 5.25H9C8.586 5.25 8.25 5.586 8.25 6C8.25 6.414 8.586 6.75 9 6.75H11C11.414 6.75 11.75 6.414 11.75 6Z" />
                            </svg>
                        </span>
                        {{ __('Shop Category') }}
                    </a>
                </li>
            @endcanany

            @canany(['business-read'])
                <li class="{{ Request::routeIs('admin.business.index','admin.business.create','admin.business.edit') ? 'active' : '' }}">
                    <a href="{{ route('admin.business.index') }}" class="active">
                        <span class="sidebar-icon">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M19.545 5.87097L18.506 2.79897C18.017 1.35497 17.412 0.250977 14.5 0.250977H5.50001C2.58801 0.250977 1.983 1.35497 1.495 2.79897L0.453985 5.87196C-0.00701529 7.23596 0.336005 8.68797 1.25001 9.64397V16C1.25001 18.418 2.58201 19.75 5.00001 19.75H15C17.418 19.75 18.75 18.418 18.75 16V9.64297C19.664 8.68697 20.0061 7.23497 19.545 5.87097ZM1.87501 6.35197L2.91602 3.27898C3.26002 2.26098 3.43301 1.74997 5.50001 1.74997H14.5C16.567 1.74997 16.74 2.26098 17.085 3.27898L18.124 6.35097C18.468 7.36497 18.104 8.45497 17.261 8.94197C16.034 9.64997 14.177 8.94396 13.752 7.74896C13.646 7.44996 13.362 7.24997 13.045 7.24997C13.044 7.24997 13.043 7.24997 13.042 7.24997C12.724 7.25097 12.4401 7.45297 12.3361 7.75397C12.0401 8.60697 11.036 9.24997 10 9.24997C8.964 9.24997 7.95995 8.60697 7.66395 7.75397C7.55995 7.45297 7.27601 7.25097 6.95801 7.24997C6.67301 7.28397 6.35405 7.44896 6.24805 7.74896C5.94405 8.60396 4.93505 9.24997 3.89905 9.24997C3.48805 9.24997 3.08702 9.14397 2.73902 8.94197C1.89602 8.45597 1.53201 7.36597 1.87501 6.35197ZM11.28 18.25H8.78003V15.5C8.78003 14.811 9.34103 14.25 10.03 14.25C10.719 14.25 11.28 14.811 11.28 15.5V18.25ZM15 18.25H12.78V15.5C12.78 13.983 11.547 12.75 10.03 12.75C8.51303 12.75 7.28003 13.983 7.28003 15.5V18.25H5.00001C3.42301 18.25 2.75001 17.577 2.75001 16V10.554C4.22001 10.986 5.95606 10.501 6.95106 9.41296C7.69306 10.228 8.82401 10.749 10 10.749C11.176 10.749 12.307 10.228 13.049 9.41296C13.795 10.228 14.927 10.749 16.101 10.749C16.494 10.749 16.88 10.682 17.25 10.566V16C17.25 17.577 16.577 18.25 15 18.25Z" />
                            </svg>
                        </span>
                        {{ __('Shop List') }}
                    </a>
                </li>
            @endcanany

            @can('banners-read')
                <li class="{{ Request::routeIs('admin.banners.index', 'admin.banners.create', 'admin.banners.edit') ? 'active' : '' }}">
                    <a href="{{ route('admin.banners.index') }}" class="active">
                        <span class="sidebar-icon">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M18.8 0.417007C18.214 0.136007 17.5341 0.212033 17.0291 0.619033L15.9969 1.44301C14.5399 2.60901 12.71 3.25099 10.845 3.25099H5.5C2.605 3.25099 0.250977 5.60601 0.250977 8.50001C0.250977 11.228 2.34896 13.45 5.01196 13.7L7.27698 18.23C7.74598 19.168 8.68906 19.75 9.73706 19.75H11C11.221 19.75 11.43 19.653 11.572 19.485C11.714 19.317 11.776 19.094 11.74 18.877L10.886 13.751C12.737 13.761 14.55 14.4 15.996 15.557L17.026 16.381C17.332 16.625 17.6989 16.75 18.0699 16.75C18.3169 16.75 18.566 16.695 18.799 16.582C19.385 16.301 19.749 15.722 19.749 15.072V1.92702C19.75 1.27802 19.386 0.699007 18.8 0.417007ZM1.75 8.50001C1.75 6.43301 3.43202 4.75099 5.49902 4.75099H10.844C11.659 4.75099 12.467 4.646 13.25 4.446V12.554C12.467 12.354 11.658 12.249 10.844 12.249H5.49902C3.43202 12.249 1.75 10.567 1.75 8.50001ZM9.73596 18.25C9.25896 18.25 8.83104 17.985 8.61804 17.559L6.71301 13.749H9.36401L10.114 18.25H9.73596ZM18.25 15.072C18.25 15.145 18.217 15.199 18.15 15.231C18.084 15.262 18.019 15.256 17.963 15.21L16.933 14.386C16.264 13.851 15.528 13.412 14.749 13.072V3.92799C15.527 3.58799 16.263 3.149 16.932 2.61501L17.964 1.78999C18.02 1.74499 18.082 1.737 18.15 1.769C18.195 1.791 18.25 1.83599 18.25 1.92799V15.072Z" />
                            </svg>
                        </span>
                        {{ __('Ad Promotion') }}
                    </a>
                </li>
            @endcan

            @canany(['users-read'])
                <li class="{{ Request::routeIs('admin.users.index', 'admin.users.create', 'admin.users.edit') ? 'active' : '' }}">
                    <a class="{{ Request::routeIs('admin.users.index', 'admin.users.edit') ? 'active' : '' }}" href="{{ route('admin.users.index') }}">
                        <span class="sidebar-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M15.553 21.75H8.448C6.243 21.75 5.02795 20.542 5.02795 18.35C5.02795 15.946 6.38802 13.139 10.223 13.139H13.778C17.613 13.139 18.973 15.946 18.973 18.35C18.973 20.542 17.758 21.75 15.553 21.75ZM10.223 14.639C6.79402 14.639 6.52795 17.479 6.52795 18.35C6.52795 19.7 7.085 20.25 8.448 20.25H15.553C16.916 20.25 17.473 19.699 17.473 18.35C17.473 17.479 17.206 14.639 13.778 14.639H10.223ZM12.0081 11.762C9.93706 11.762 8.25195 10.077 8.25195 8.00598C8.25195 5.93498 9.93706 4.25 12.0081 4.25C14.0791 4.25 15.765 5.93498 15.765 8.00598C15.765 10.077 14.0791 11.762 12.0081 11.762ZM12.0081 5.75C10.7641 5.75 9.75195 6.76198 9.75195 8.00598C9.75195 9.24998 10.7641 10.262 12.0081 10.262C13.2521 10.262 14.265 9.24998 14.265 8.00598C14.265 6.76198 13.2521 5.75 12.0081 5.75ZM22.75 12.65C22.75 10.674 21.525 8.68005 18.79 8.68005H17.8199C17.4059 8.68005 17.0699 9.01605 17.0699 9.43005C17.0699 9.84405 17.4059 10.1801 17.8199 10.1801H18.79C21.011 10.1801 21.25 11.907 21.25 12.65C21.25 13.514 20.9409 13.8199 20.0699 13.8199H19.71C19.296 13.8199 18.96 14.1559 18.96 14.5699C18.96 14.9839 19.296 15.3199 19.71 15.3199H20.0699C21.7729 15.3199 22.75 14.347 22.75 12.65ZM18.099 8.03503C19.45 7.76303 20.4301 6.55704 20.4301 5.17004C20.4301 3.56004 19.12 2.25 17.51 2.25C16.749 2.25 16.041 2.53197 15.517 3.04297C15.22 3.33197 15.2141 3.807 15.5031 4.104C15.7911 4.401 16.268 4.40704 16.564 4.11804C16.807 3.88104 17.143 3.75098 17.51 3.75098C18.293 3.75098 18.9301 4.38802 18.9301 5.17102C18.9301 5.84702 18.455 6.43404 17.802 6.56604C17.396 6.64804 17.133 7.04395 17.215 7.44995C17.287 7.80595 17.6 8.052 17.949 8.052C17.999 8.05 18.049 8.04503 18.099 8.03503ZM5.03003 14.5699C5.03003 14.1559 4.69403 13.8199 4.28003 13.8199H3.92896C3.05796 13.8199 2.74902 13.514 2.74902 12.65C2.74902 11.907 2.98798 10.1801 5.20898 10.1801H6.19897C6.61297 10.1801 6.94897 9.84405 6.94897 9.43005C6.94897 9.01605 6.61297 8.68005 6.19897 8.68005H5.20898C2.28598 8.68005 1.24902 10.819 1.24902 12.65C1.24902 14.347 2.22596 15.3199 3.92896 15.3199H4.28003C4.69403 15.3199 5.03003 14.9839 5.03003 14.5699ZM6.80603 7.448C6.88803 7.042 6.62499 6.64596 6.21899 6.56396C5.55899 6.43096 5.07996 5.84495 5.07996 5.16895C5.07996 4.38595 5.72201 3.74902 6.51001 3.74902C6.87001 3.74902 7.20894 3.88202 7.46594 4.12402C7.76694 4.40902 8.241 4.39499 8.526 4.09399C8.811 3.79299 8.79697 3.31806 8.49597 3.03406C7.96097 2.52806 7.25599 2.24902 6.51099 2.24902C4.89599 2.24902 3.58105 3.55895 3.58105 5.16895C3.58105 6.55495 4.56597 7.76006 5.92297 8.03406C5.97297 8.04406 6.02302 8.04895 6.07202 8.04895C6.42102 8.04995 6.73303 7.804 6.80603 7.448Z" />
                            </svg>
                        </span>
                        {{ __('Manage Staff') }}
                    </a>
                </li>
            @endcanany

            @canany(['subscription-reports-read'])
                <li class="dropdown {{ Route::is('admin.subscription-reports.index','admin.shop-reports.allshop','admin.expire-shop-reports') ? 'active' : '' }}">
                    <a href="#">
                        <span class="sidebar-icon">
                            <svg width="18" height="20" viewBox="0 0 18 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M14 2.25H13.73C13.633 0.996 12.821 0.25 11.5 0.25H6.5C5.179 0.25 4.36702 0.996 4.27002 2.25H4C1.582 2.25 0.25 3.582 0.25 6V16C0.25 18.418 1.582 19.75 4 19.75H14C16.418 19.75 17.75 18.418 17.75 16V6C17.75 3.582 16.418 2.25 14 2.25ZM5.75 2.5C5.75 1.911 5.911 1.75 6.5 1.75H11.5C12.089 1.75 12.25 1.911 12.25 2.5V3.5C12.25 4.089 12.089 4.25 11.5 4.25H6.5C5.911 4.25 5.75 4.089 5.75 3.5V2.5ZM16.25 16C16.25 17.577 15.577 18.25 14 18.25H4C2.423 18.25 1.75 17.577 1.75 16V6C1.75 4.423 2.423 3.75 4 3.75H4.27002C4.36702 5.004 5.179 5.75 6.5 5.75H11.5C12.821 5.75 13.633 5.004 13.73 3.75H14C15.577 3.75 16.25 4.423 16.25 6V16ZM14.25 10C14.25 10.414 13.914 10.75 13.5 10.75H9.5C9.086 10.75 8.75 10.414 8.75 10C8.75 9.586 9.086 9.25 9.5 9.25H13.5C13.914 9.25 14.25 9.586 14.25 10ZM14.25 14C14.25 14.414 13.914 14.75 13.5 14.75H9.5C9.086 14.75 8.75 14.414 8.75 14C8.75 13.586 9.086 13.25 9.5 13.25H13.5C13.914 13.25 14.25 13.586 14.25 14ZM7.03003 8.80298C7.32303 9.09598 7.32303 9.57101 7.03003 9.86401L5.69702 11.197C5.55602 11.338 5.36599 11.417 5.16699 11.417C4.96799 11.417 4.77696 11.338 4.63696 11.198L3.96997 10.531C3.67697 10.238 3.67697 9.76297 3.96997 9.46997C4.26297 9.17697 4.73801 9.17697 5.03101 9.46997L5.16797 9.60699L5.97095 8.80402C6.26295 8.51002 6.73703 8.50998 7.03003 8.80298ZM7.03003 12.803C7.32303 13.096 7.32303 13.571 7.03003 13.864L5.69702 15.197C5.55602 15.338 5.36599 15.417 5.16699 15.417C4.96799 15.417 4.77696 15.338 4.63696 15.198L3.96997 14.531C3.67697 14.238 3.67697 13.763 3.96997 13.47C4.26297 13.177 4.73801 13.177 5.03101 13.47L5.16797 13.607L5.97095 12.804C6.26295 12.51 6.73703 12.51 7.03003 12.803Z"/>
                            </svg>
                        </span>
                        {{ __('Reports') }}
                    </a>
                    <ul>
                        <li><a class="{{ Route::is('admin.shop-reports.allshop') ? 'active' : '' }}" href="{{ route('admin.shop-reports.allshop') }}">{{ __('Shop Reports') }}</a></li>
                        <li><a class="{{ Route::is('admin.expire-shop-reports') ? 'active' : '' }}" href="{{ route('admin.expire-shop-reports') }}">{{ __('Expire Shop Reports') }}</a></li>
                        @can('plans-create')
                            <li><a class="{{ Route::is('admin.subscription-reports.index') ? 'active' : '' }}" href="{{ route('admin.subscription-reports.index') }}">{{ __('Subscription Reports') }}</a></li>
                        @endcan
                    </ul>
                </li>
            @endcanany

            @canany(['roles-read', 'permissions-read'])
                <li class="dropdown {{ Request::routeIs('admin.roles.index', 'admin.roles.create', 'admin.roles.edit', 'admin.permissions.index') ? 'active' : '' }}">
                    <a href="#">
                        <span class="sidebar-icon">
                            <svg width="20" height="22" viewBox="0 0 20 22" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M1.00102 10.855C0.974023 10.855 0.945992 10.854 0.918992 10.851C0.506992 10.806 0.209052 10.435 0.255052 10.024C0.617052 6.70605 2.61903 3.84996 5.61003 2.38196C5.84303 2.26796 6.11708 2.28195 6.33708 2.41895C6.55708 2.55595 6.69109 2.79703 6.69109 3.05603V6.10596C6.69109 6.51996 6.35509 6.85596 5.94109 6.85596C5.52709 6.85596 5.19109 6.51996 5.19109 6.10596V4.36499C3.26709 5.70299 2.00602 7.80499 1.74602 10.188C1.70302 10.571 1.37902 10.855 1.00102 10.855ZM14.3901 19.729C17.3811 18.261 19.383 15.404 19.745 12.087C19.791 11.675 19.4931 11.305 19.0811 11.26C18.6681 11.218 18.3001 11.512 18.2551 11.924C17.9941 14.3069 16.7341 16.4079 14.8101 17.7469V16.006C14.8101 15.592 14.4741 15.256 14.0601 15.256C13.6461 15.256 13.3101 15.592 13.3101 16.006V19.056C13.3101 19.315 13.444 19.556 13.664 19.693C13.785 19.768 13.9231 19.806 14.0601 19.806C14.1731 19.806 14.2851 19.78 14.3901 19.729ZM13.5051 5.25C12.1261 5.25 11.0051 4.128 11.0051 2.75C11.0051 1.372 12.1261 0.25 13.5051 0.25C14.8841 0.25 16.0051 1.372 16.0051 2.75C16.0051 4.128 14.8841 5.25 13.5051 5.25ZM13.5051 1.75C12.9531 1.75 12.5051 2.199 12.5051 2.75C12.5051 3.301 12.9531 3.75 13.5051 3.75C14.0571 3.75 14.5051 3.301 14.5051 2.75C14.5051 2.199 14.0571 1.75 13.5051 1.75ZM15.4991 11.75H11.501C10.092 11.75 9.25005 10.912 9.25005 9.50903C9.25005 7.88603 10.255 6.25 12.5 6.25H14.5C16.745 6.25 17.75 7.88703 17.75 9.50903C17.75 10.912 16.9081 11.75 15.4991 11.75ZM12.5 7.75C10.978 7.75 10.75 8.85203 10.75 9.50903C10.75 10.084 10.918 10.25 11.501 10.25H15.4991C16.0821 10.25 16.25 10.084 16.25 9.50903C16.25 8.85203 16.022 7.75 14.5 7.75H12.5ZM5.50505 15.25C4.12605 15.25 3.00505 14.128 3.00505 12.75C3.00505 11.372 4.12605 10.25 5.50505 10.25C6.88405 10.25 8.00505 11.372 8.00505 12.75C8.00505 14.128 6.88405 15.25 5.50505 15.25ZM5.50505 11.75C4.95305 11.75 4.50505 12.199 4.50505 12.75C4.50505 13.301 4.95305 13.75 5.50505 13.75C6.05705 13.75 6.50505 13.301 6.50505 12.75C6.50505 12.199 6.05705 11.75 5.50505 11.75ZM7.49907 21.75H3.50102C2.09202 21.75 1.25005 20.912 1.25005 19.509C1.25005 17.886 2.25505 16.25 4.50005 16.25H6.50005C8.74505 16.25 9.75005 17.887 9.75005 19.509C9.75005 20.912 8.90807 21.75 7.49907 21.75ZM4.50005 17.75C2.97805 17.75 2.75005 18.852 2.75005 19.509C2.75005 20.084 2.91802 20.25 3.50102 20.25H7.49907C8.08207 20.25 8.25005 20.084 8.25005 19.509C8.25005 18.852 8.02205 17.75 6.50005 17.75H4.50005Z" />
                            </svg>
                        </span>
                        {{ __('Roles & Permissions') }}
                    </a>
                    <ul>
                        @can('roles-read')
                            <li>
                                <a class="{{ Request::routeIs('admin.roles.index', 'admin.roles.create', 'admin.roles.edit') ? 'active' : '' }}"
                                    href="{{ route('admin.roles.index') }}">
                                    {{ __('Roles') }}
                                </a>
                            </li>
                        @endcan

                        @can('permissions-read')
                            <li>
                                <a class="{{ Request::routeIs('admin.permissions.index') ? 'active' : '' }}"
                                    href="{{ route('admin.permissions.index') }}">
                                    {{ __('Permissions') }}
                                </a>
                            </li>
                        @endcan
                    </ul>
                </li>
            @endcanany

            @canany(['settings-read', 'notifications-read', 'currencies-read', 'gateways-read', 'addons-read','login-pages-read'])
                <li class="dropdown {{ Request::routeIs('admin.settings.index', 'admin.notifications.index', 'admin.system-settings.index', 'admin.currencies.index', 'admin.currencies.create', 'admin.currencies.edit', 'admin.sms-settings.index', 'admin.gateways.index', 'admin.addons.index','admin.login-pages.index') ? 'active' : '' }}">
                    <a href="#">
                        <span class="sidebar-icon">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M10 6.24997C7.93205 6.24997 6.25005 7.93197 6.25005 9.99997C6.25005 12.068 7.93205 13.75 10 13.75C12.068 13.75 13.75 12.068 13.75 9.99997C13.75 7.93197 12.068 6.24997 10 6.24997ZM10 12.25C8.75905 12.25 7.75005 11.241 7.75005 9.99997C7.75005 8.75897 8.75905 7.74997 10 7.74997C11.241 7.74997 12.25 8.75897 12.25 9.99997C12.25 11.241 11.241 12.25 10 12.25ZM19.2081 11.953C18.5141 11.551 18.082 10.803 18.081 9.99997C18.08 9.19897 18.5091 8.45198 19.2121 8.04498C19.7271 7.74598 19.9031 7.08296 19.6051 6.56696L17.9331 3.68097C17.6351 3.16597 16.972 2.98898 16.456 3.28598C15.757 3.68898 14.8881 3.68898 14.1871 3.28198C13.4961 2.88098 13.0661 2.13598 13.0661 1.33698C13.0661 0.737975 12.578 0.250977 11.979 0.250977H8.02403C7.42403 0.250977 6.93706 0.737975 6.93706 1.33698C6.93706 2.13598 6.50704 2.88097 5.81404 3.28397C5.11504 3.68897 4.24705 3.68996 3.54805 3.28696C3.03105 2.98896 2.36906 3.16698 2.07106 3.68198L0.397049 6.57098C0.0990486 7.08598 0.276035 7.74796 0.796035 8.04996C1.48904 8.45096 1.92105 9.19796 1.92305 9.99896C1.92505 10.801 1.49504 11.55 0.793045 11.957C0.543045 12.102 0.363047 12.335 0.289047 12.615C0.215047 12.894 0.253056 13.185 0.398056 13.436L2.06905 16.32C2.36705 16.836 3.03005 17.015 3.54805 16.716C4.24705 16.313 5.11405 16.314 5.80305 16.713L5.80504 16.714C5.80804 16.716 5.81105 16.718 5.81505 16.72C6.50605 17.121 6.93504 17.866 6.93404 18.666C6.93404 19.265 7.42103 19.752 8.02003 19.752H11.979C12.578 19.752 13.065 19.265 13.065 18.667C13.065 17.867 13.495 17.122 14.189 16.719C14.887 16.314 15.755 16.312 16.455 16.716C16.971 17.014 17.6331 16.837 17.9321 16.322L19.606 13.433C19.903 12.916 19.7261 12.253 19.2081 11.953ZM16.831 15.227C15.741 14.752 14.476 14.817 13.434 15.42C12.401 16.019 11.7191 17.078 11.5871 18.25H8.41005C8.28005 17.078 7.59603 16.017 6.56303 15.419C5.52303 14.816 4.25605 14.752 3.16905 15.227L1.89305 13.024C2.84805 12.321 3.42504 11.193 3.42104 9.99298C3.41804 8.80098 2.84204 7.68097 1.89204 6.97797L3.16905 4.77396C4.25705 5.24796 5.52405 5.18396 6.56605 4.57996C7.59805 3.98196 8.28003 2.92198 8.41203 1.75098H11.5871C11.7181 2.92298 12.4011 3.98197 13.4361 4.58197C14.475 5.18497 15.742 5.24896 16.831 4.77496L18.108 6.97797C17.155 7.67997 16.579 8.80597 16.581 10.004C16.582 11.198 17.1581 12.32 18.1091 13.025L16.831 15.227Z" />
                            </svg>
                        </span>
                        {{ __('Settings') }}
                    </a>
                    <ul>
                        @can('currencies-read')
                            <li><a class="{{ Request::routeIs('admin.currencies.index', 'admin.currencies.create', 'admin.currencies.edit') ? 'active' : '' }}" href="{{ route('admin.currencies.index') }}">{{ __('Currencies') }}</a></li>
                        @endcan

                        @can('notifications-read')
                            <li>
                                <a class="{{ Request::routeIs('admin.notifications.index') ? 'active' : '' }}" href="{{ route('admin.notifications.index') }}">
                                    {{ __('Notifications') }}
                                </a>
                            </li>
                        @endcan

                        @can('gateways-read')
                            <li>
                                <a class="{{ Request::routeIs('admin.gateways.index') ? 'active' : '' }}" href="{{ route('admin.gateways.index') }}">
                                    {{ __('Payment Gateway') }}
                                </a>
                            </li>
                        @endcan

                        @can('settings-read')
                            <li>
                                <a class="{{ Request::routeIs('admin.system-settings.index') ? 'active' : '' }}" href="{{ route('admin.system-settings.index') }}">{{ __('System Settings') }}</a>
                            </li>
                            <li>
                                <a class="{{ Request::routeIs('admin.settings.index') ? 'active' : '' }}" href="{{ route('admin.settings.index') }}">{{ __('General Settings') }}</a>
                            </li>
                        @endcan

                        @can('login-pages-read')
                            <li>
                                <a class="{{ Request::routeIs('admin.login-pages.index') ? 'active' : '' }}" href="{{ route('admin.login-pages.index') }}">{{ __('Login Page Settings') }}</a>
                            </li>
                        @endcan
                    </ul>
                </li>
            @endcanany
        </ul>
    </div>
</nav>
