import unittest
from __init__ import parse_remote_url

class GitUpstreamUrl(unittest.TestCase):
    def test_https_urls(self):
        def test(remote, expected_url, expected_service):
            repo = parse_remote_url(remote)
            self.assertEqual(repo.home_url, expected_url)
            self.assertEqual(repo.service, expected_service)

        test("https://github.com/jennings/example", "https://github.com/jennings/example", "github")
        test("https://github.com/jennings/example.git", "https://github.com/jennings/example", "github")
        test("https://bitbucket.org/jennings/example", "https://bitbucket.org/jennings/example", "bitbucket")
        test("https://bitbucket.org/jennings/example.git", "https://bitbucket.org/jennings/example", "bitbucket")

    def test_ssh_urls(self):
        def test(remote, expected_url, expected_service):
            repo = parse_remote_url(remote)
            self.assertEqual(repo.home_url, expected_url)
            self.assertEqual(repo.service, expected_service)

        test("git@github.com:jennings/example", "https://github.com/jennings/example", "github")
        test("git@github.com:jennings/example.git", "https://github.com/jennings/example", "github")
        test("git@bitbucket.org:jennings/example", "https://bitbucket.org/jennings/example", "bitbucket")
        test("git@bitbucket.org:jennings/example.git", "https://bitbucket.org/jennings/example", "bitbucket")

    def test_pr_url(self):
        def test(remote, branch, expected_url):
            repo = parse_remote_url(remote)
            self.assertEqual(repo.new_pr(branch), expected_url)

        test("git@github.com:jennings/example", "foo", "https://github.com/jennings/example/pull/new/foo")
        test("git@bitbucket.org:jennings/example", "foo", "https://bitbucket.org/jennings/example/pull-requests/new?source=foo")

if __name__ == "__main__":
    unittest.main()
