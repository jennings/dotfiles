import re
import sys
from dataclasses import dataclass

@dataclass
class Repo:
    home_url: str
    service: str

    def new_pr(self, branch):
        if self.service == "github":
            return self.home_url + "/pull/new/" + branch
        elif self.service == "bitbucket":
            return self.home_url + "/pull-requests/new?source=" + branch
        elif self.service == "azuredevops":
            return f"{self.home_url}/pullrequestcreate?sourceRef={branch}"
        else:
            return None

def parse_remote_url(remote):
    if remote.startswith("git@github.com:"):
        match = re.search(r"^git@github.com:(.+)/(.*?)(?:\.git)?(/|$)", remote)
        if not match: sys.exit(f"did not match GitHub SSH remote: {remote}")
        return Repo(
            f"https://github.com/{match.group(1)}/{match.group(2)}",
            "github"
        )

    elif remote.startswith("git@ssh.dev.azure.com:"):
        match = re.search(r"^git@ssh.dev.azure.com:v3/(.+)/(.+)/(.*?)(?:\.git)?(/|$)", remote)
        if not match: sys.exit(f"did not match Azure DevOps SSH remote: {remote}")
        return Repo(
            f"https://dev.azure.com/{match.group(1)}/{match.group(2)}/_git/{match.group(3)}",
            "azuredevops"
        )

    elif remote.startswith("git@bitbucket.org:"):
        match = re.search(r"^git@bitbucket.org:(.+)/(.*?)(?:\.git)?(/|$)", remote)
        if not match: sys.exit(f"did not match Bitbucket SSH remote: {remote}")
        return Repo(
            f"https://bitbucket.org/{match.group(1)}/{match.group(2)}",
            "bitbucket"
        )

    elif remote.startswith("https://github.com/"):
        match = re.search(r"^https://github.com/(.+)/(.*?)(?:\.git)?(/|$)", remote)
        if not match: sys.exit(f"did not match GitHub HTTPS remote: {remote}")
        return Repo(
            f"https://github.com/{match.group(1)}/{match.group(2)}",
            "github"
        )

    elif remote.startswith("https://bitbucket.org/"):
        match = re.search(r"^https://bitbucket.org/(.+)/(.*?)(?:\.git)?(/|$)", remote)
        if not match: sys.exit(f"did not match Bitbucket HTTPS remote: {remote}")
        return Repo(
            f"https://bitbucket.org/{match.group(1)}/{match.group(2)}",
            "bitbucket"
        )

    else:
        sys.exit(f"unknown URL format: {remote}")
