"""Pytest configuration and fixtures for testing the Cookiecutter template."""

from typing import List

import pytest
from pytest_cookies.plugin import Cookies
from pytest_cookies.plugin import Result


@pytest.fixture
def default_baked_project(cookies: Cookies) -> Result:
    """Bake the Cookiecutter template using default context."""
    return cookies.bake()


@pytest.fixture
def project_dir_structure() -> List[str]:
    """Expected top-level directory and file structure of a generated project."""
    return [
        "data",
        "notebooks",
        "references",
        "reports",
        "src",
        ".gitignore",
        "Dockerfile",
        "Makefile",
        "README.md",
        "requirements.txt",
    ]
