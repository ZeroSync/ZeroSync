from setuptools import setup

setup(
    name="ZeroSync",
    license="MIT",
    version="0.1.0",
    author="ZeroSync Developers",
    author_email="robin@zerosync.org",
    packages=["zerosync"],
    package_dir={"zerosync": "zerosync"},
    include_package_data=True,
    url="https://zerosync.org",
    keywords="Bitcoin, STARK, Cairo",
)
