#!/usr/bin/env python

from __future__ import print_function

from datetime import datetime
import os
from os import path
import re
import shutil
import subprocess
from subprocess import Popen
import sys

SHARE_DIR = path.join(path.dirname(__file__), "../share/")


def run(args):
    return Popen(args, stdout=sys.stdout, stderr=sys.stderr).wait()


status = subprocess.check_output(["git", "status", "--porcelain"])
if len(status) > 0:
    print("Unclean working tree. Commit or stash changes first.", file=sys.stderr)
    sys.exit(1)

timestamp = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S +0000")

cheatly_curr = path.join(SHARE_DIR, "cheatly.khulnasoft.com.txt")
cheatly_new = path.join(SHARE_DIR, "cheatly.khulnasoft.com.txt.new")

re_version = re.compile(r"^__CHEATLY_VERSION=(.*)$")
re_timestamp = re.compile(r"^__CHEATLY_DATETIME=.*$")

with open(cheatly_curr, "rt") as fin:
    with open(cheatly_new, "wt") as fout:
        for line in fin:
            match = re_version.match(line)
            if match:
                version = int(match.group(1)) + 1
                fout.write("__CHEATLY_VERSION=%s\n" % version)
                continue

            match = re_timestamp.match(line)
            if match:
                fout.write('__CHEATLY_DATETIME="%s"\n' % timestamp)
                continue

            fout.write(line)

shutil.copymode(cheatly_curr, cheatly_new)
os.remove(cheatly_curr)
os.rename(cheatly_new, cheatly_curr)

message = "cheatly: v%s" % version
run(["git", "add", cheatly_curr])
run(["git", "commit", "-m", message])
run(["git", "tag", "cheatly@%s" % version, "-m", message])
