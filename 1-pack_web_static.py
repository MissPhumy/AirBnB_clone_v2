#!/usr/bin/python3
"""Generates a .tgz archive from the contents of the web_static folder."""
from fabric.api import local
import time


def do_pack():
    """Generates a .tgz archive from the contents of the web_static folder.

    Returns:
        str: Path to the generated .tgz archive if successful, otherwise None.
    """
    try:
        local("mkdir -p versions")
        timestamp = time.strftime("%Y%m%d%H%M%S")
        archive_name = "web_static_{}.tgz".format(timestamp)
        local("tar -cvzf versions/{} web_static/".format(archive_name))
        return "versions/{}".format(archive_name)
    except Exception as e:
        print("Error:", e)
        return None
