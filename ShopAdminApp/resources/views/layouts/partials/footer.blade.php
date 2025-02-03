<footer class="container-fluid d-flex align-items-center justify-content-center justify-content-sm-between flex-wrap py-3 mt-4 ms-0 bg-white">
    <p class="mb-0 me-3"> {{ get_option('general')['copy_right'] ?? '' }}</p>
    <p class="mb-0">{{ get_option('general')['admin_footer_text'] ?? '' }}: <a class='text-success' href="{{ get_option('general')['admin_footer_link'] ?? '' }}" target="_blank">❤️ Acnoo</a></p>
</footer>
