# -*- coding: utf-8 -*-

#!/usr/bin/python
import requests
import unittest

class TestPaperAPI(unittest.TestCase):

    def setUp(self):
        self.base_url = "http://localhost:8000"
        self.file_url = "http://localhost:8000/file/"
        self.json_headers ={"Content-Type": "application/json", "Accept": "application/json"}
        self.new_file = {"title": "ABC"}
        self.new_file2 =  {"title": "DEF"}
        self.put_headers = {"Content-Type": "text/plain"}

    def test_get_on_root_returns_html_hello_world(self):
        resp = requests.get(self.base_url)
        self.assertEqual(resp.content, "<html><body>Hello, new world</body></html>")

    def test_get_on_file_returns_id_in_html(self):
        for id in 1,2,3:
            resp = requests.get(self.file_url + str(id))
            self.assertEqual(resp.status_code, 200)
            self.assertEqual(resp.content, "<html><body>" + str(id) + "</body></html>")

    def test_get_on_nonexisting_file_returns_404(self):
        resp = requests.get(self.file_url + '1235')
        self.assertEqual(resp.status_code, 404)

    def notest_put_new_file(self):
        url = self.file_url + '0'
        resp = requests.put(url, data=self.new_file, headers=self.json_headers)
        self.assertEqual(resp.status_code, 200)
        self.assertEqual(resp.content, '{"id":"0","title":"ABC"}')

        # Test durability
        resp2 = requests.get(url)

    def notest_get_on_file_returns_id_in_json(self):
        for id in 1,2,3:
            resp = requests.get(self.file_url + str(id), headers=self.json_headers)
            self.assertEqual(resp.status_code, 200)
            self.assertEqual(resp.content, '{"id":' + '"' + str(id) + '",'\
                    '"title":'+ '"' + str(id) + '"}')

    def test_upload_file(self):
        url = self.file_url + '0'
        data = 'this\nis\nvery\cool\n'
        resp = requests.put(url, data=data, headers=self.put_headers)
        self.assertEqual(resp.status_code, 200)

        # Test durability
        resp2 = requests.get(url)

if __name__ == "__main__":
    suite = unittest.TestLoader(verbosity=2).loadTestsFromTestCase(TestPaperAPI)
    unittest.TextTestRunner.run(suite)
