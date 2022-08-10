from setuptools import setup, find_packages
import sys

setup(
    name="zerosync",
    version="0.0.1",
    py_modules=["zerosync_cli"],
    packages=find_packages(),
    install_requires=[
        "click",
        "python-bitcoinrpc",
        "toml",
        "wheel"],
    entry_points={
        "console_scripts": ["zerosync = zerosync_cli:zerosync_cli"]},
)
