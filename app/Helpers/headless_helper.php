<?php

use CodeIgniter\HTTP\ResponseInterface;
use Config\Services;

/**
 * This helper file is loaded by Composer before the CodeIgniter system helpers.
 * This allows us to define our own `view()` function, which will be used
 * instead of the default one, effectively making the application headless.
 */
if (! function_exists('view')) {
    /**
     * Globally overrides the default view() helper for a headless application.
     *
     * This implementation completely changes the function's behavior. Instead of
     * rendering an HTML view, it intercepts the data array and immediately
     * returns it as a JSON response with the correct headers.
     *
     * @param string $name      The name of the view file (will be ignored).
     * @param array  $data      The data that will be returned as a JSON payload.
     * @param array  $options   Rendering options (will be ignored).
     *
     * @return ResponseInterface An instance of the response object, ready to be sent.
     */
    function view(string $name, array $data = [], array $options = []): ResponseInterface
    {
        // We can unset the unused parameters to keep the code clean.
        unset($name, $options);

        // Get the main response service from the framework.
        $response = Services::response();

        // Use the setJSON() method to:
        // 1. Encode the $data array into a JSON string.
        // 2. Set the body of the response to this JSON string.
        // 3. Set the 'Content-Type' header to 'application/json'.
        return $response->setJSON($data);
    }
}
