from setuptools import setup, find_packages
import sys

if len(sys.argv) > 1 and sys.argv[1] == 'dev':
    setup(
        name="starkRelay-dev",
        version="0.0.1",
        py_modules=["starkRelay_dev_cli"],
        packages=find_packages(),
        install_requires=["click", "python-bitcoinrpc", "toml", "wheel"],
        entry_points={"console_scripts": ["starkRelay-dev = starkRelay_dev_cli:starkRelay_dev_cli"]},
    )
else:
    setup(
        name="starkRelay",
        version="0.0.1",
        py_modules=["starkRelay_cli"],
        packages=find_packages(),
        install_requires=["click", "python-bitcoinrpc", "toml", "wheel"],
        entry_points={"console_scripts": ["starkRelay = starkRelay_cli:starkRelay_cli"]},
    )
