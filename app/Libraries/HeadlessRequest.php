<?php

namespace App\Libraries;

use CodeIgniter\HTTP\IncomingRequest;

/**
 * A custom request class for headless applications.
 *
 * It extends the default IncomingRequest but overrides the getPost() method
 * to source its data from the JSON request body instead of the $_POST superglobal.
 */
class HeadlessRequest extends IncomingRequest
{
    /**
     * Overrides the default getPost method.
     *
     * This method retrieves data from a JSON request body instead of
     * from form-data (`$_POST`). It mimics the behavior of the original
     * getPost, allowing for fetching the entire dataset or a specific key.
     *
     * @param mixed|null $index  The specific key to retrieve. Returns all data if null.
     * @param int|null   $filter The filter type to apply (e.g., FILTER_SANITIZE_STRING).
     * @param mixed      $flags  Filter flags.
     *
     * @return mixed The JSON data, a specific value from it, or null.
     */
    public function getPost($index = null, $filter = null, $flags = null)
    {
        // Use the existing getJSON() method to parse the raw request body.
        // The `true` argument ensures the JSON is returned as an associative array,
        // which is consistent with the format of the $_POST array.
        $jsonData = $this->getJSON(true);

        // If the request body was empty, not valid JSON, or an error occurred, return null.
        if (!is_array($jsonData)) {
            return null;
        }

        // If no specific index was requested, return the entire JSON payload.
        if ($index === null) {
            return $jsonData;
        }

        // If a specific index is requested, check if it exists in the payload.
        if (!array_key_exists($index, $jsonData)) {
            return null;
        }

        $value = $jsonData[$index];

        // If a filter is specified, apply it to the value.
        // This maintains compatibility with the original getPost() signature.
        if ($filter !== null) {
            return filter_var($value, $filter, $flags);
        }

        return $value;
    }
}
