from setuptools import setup, find_packages

setup(
    name="starkRelay",
    version="0.0.1",
    py_modules=["starkRelay_cli"],
    packages=find_packages(),
    install_requires=["click", "python-bitcoinrpc", "toml", "wheel"],
    entry_points={"console_scripts": ["starkRelay = starkRelay_cli:starkRelay_cli"]},
)
