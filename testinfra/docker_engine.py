import docker
import fcntl
import struct
import pytest

def test_arrrr(host):
    svc = host.service("docker")
    assert svc.is_running
    assert svc.is_enabled
