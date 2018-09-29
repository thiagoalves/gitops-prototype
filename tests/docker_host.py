import docker
import fcntl
import struct
import pytest

def test_ami(host):
    f = host.file("/etc/aurea_ansible_info")
    assert f.exists
