<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Only the /api/* prefix is exposed. Allowed origins are set via the
    | CORS_ALLOWED_ORIGINS env variable. For local Flutter dev the Android
    | emulator loopback is 10.0.2.2 and the iOS simulator uses localhost.
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    'allowed_origins' => array_filter(
        explode(',', env('CORS_ALLOWED_ORIGINS', 'http://localhost:8000'))
    ),

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [
        'Content-Disposition', // Required for CSV file downloads
    ],

    'max_age' => 0,

    'supports_credentials' => false,

];
