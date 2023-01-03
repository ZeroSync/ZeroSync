from setuptools import setup

setup(
    name="ZeroSync",
    license="MIT",
    author="ZeroSync Developers",
    author_email="robin@zerosync.org",
    packages=["zerosync"],
    package_dir={"zerosync": "zerosync"},
    include_package_data=True,
    url="https://zerosync.org",
    keywords="Bitcoin, STARK, Cairo",
)
