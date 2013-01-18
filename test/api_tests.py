# -*- coding: utf-8 -*-

#!/usr/bin/python
import requests
import unittest

class TestPaperAPI(unittest.TestCase):

    def setUp(self):
        self.base_url = "http://localhost:8000"
        self.file_url = "%s/file/" % self.base_url
        self.put_headers = {"Content-Type": "text/plain"}

        # Upload test data.
        url = self.file_url + '0'
        self.data = 'this\nis\nvery\cool\n'
        resp = requests.put(url, data=self.data, headers=self.put_headers)

    def test_get_on_root_returns_html_hello_world(self):
        resp = requests.get(self.base_url)
        self.assertEqual(resp.content, "<html><body>Hello, new world</body></html>")

    def test_get_on_file_returns_plain_text(self):
        id_ = 0
        resp = requests.get(self.file_url + str(id_))
        self.assertEqual(resp.status_code, 200)
        self.assertEqual(resp.content, self.data)

    def test_get_on_nonexisting_file_returns_404(self):
        resp = requests.get(self.file_url + '1235')
        self.assertEqual(resp.status_code, 404)

    def test_upload_file(self):
        url = self.file_url + '1'
        data = 'this\nis\nvery\cool\n'
        resp = requests.put(url, data=data, headers=self.put_headers)
        self.assertEqual(resp.status_code, 204)

        # Test durability
        resp2 = requests.get(url)

if __name__ == "__main__":
    suite = unittest.TestLoader(verbosity=2).loadTestsFromTestCase(TestPaperAPI)
    unittest.TextTestRunner.run(suite)
