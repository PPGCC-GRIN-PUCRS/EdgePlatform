from setuptools import setup, find_packages
import os
import re


def read_metadata(data):
    with open(os.path.join("agent/metadata.py"), encoding="utf-8") as f:
        content = f.read()
        return re.search(rf"^__{data}__ = ['\"]([^'\"]+)['\"]", content, re.M).group(1)

def read_requirements(filename="requirements.txt"):
    with open(filename, encoding="utf-8") as f:
        return [line.strip() for line in f if line.strip() and not line.startswith("#")]

setup(
    name='agent',
    include_package_data=True,
    version=read_metadata("version"),
    packages=find_packages(),
    install_requires=read_requirements(),
    entry_points={
        'console_scripts': [
            'agent = agent.agent:main',
        ],
    },
    author=read_metadata("author"),
    description=read_metadata("description"),
    classifiers=[
        'Programming Language :: Python :: 3',
        'Operating System :: Unix',
    ],
    python_requires='>=3.7',
)
