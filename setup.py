from setuptools import setup, find_packages
import sys

setup(
    name="sibd",
    version="0.0.1",
    py_modules=["sibd_cli"],
    packages=find_packages(),
    install_requires=[
        "click",
        "python-bitcoinrpc",
        "toml",
        "wheel"],
    entry_points={
        "console_scripts": ["sibd = sibd_cli:sibd_cli"]},
)
