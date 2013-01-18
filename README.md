e3 Webmachine Application
=========================

## Introduction

This is a basic webmachine application that implements a simple RESTful API.
The API enables a user to PUT and GET files from a file cache.

Here is the API implemented

| HTTP method | Route                        | Content Type | Request Body          | Status Code                        | Response                   |
|-------------|------------------------------|--------------|-----------------------|------------------------------------|----------------------------|
| GET         | /file/id                     | text/plain   |                       | 200 (if found), 404 (otherwise)    | text from file             |
| PUT         | /file/id[?expiry=duration]   | text/plain   | text to be uploaded   | 201 (if created), 200 (if updated) | id in the body of html doc |

## Compilation

Run the following command from the root directory:

    make

## Unit tests

To execute unit tests, in one terminal window start the server:

    ./start.sh

In another terminal window, type the following command:

    make api-tests

You should see something like this:

    $ make api-tests
    test_get_on_file_returns_plain_text (api_tests.TestPaperAPI) ... ok
    test_get_on_nonexisting_file_returns_404 (api_tests.TestPaperAPI) ... ok
    test_get_on_root_returns_html_hello_world (api_tests.TestPaperAPI) ... ok
    test_upload_file (api_tests.TestPaperAPI) ... ok

    ----------------------------------------------------------------------
    Ran 4 tests in 0.271s

    OK
    make: `api-tests' is up to date.

## Usage

### File upload

To upload a file to the cache, you can use a tool like *curl*:

    curl -X PUT\
        -H "Content-Type: text/plain"\
        -T 'test.txt'\
        http://localhost:8000/file/test.txt


### File download

To retrieve a file that is in the cache, you can use a similar approach:

    curl -X GET\
        -H "Content-Type: text/plain"\
        http://localhost:8000/file/test.txt

## Questions

Please email any questions to <delapsley@gmail.com>.
