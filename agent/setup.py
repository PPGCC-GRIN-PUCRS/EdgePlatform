from setuptools import setup, find_packages

setup(
    name='agent',
    version='0.1.0',
    include_package_data=True,
    packages=find_packages(),
    install_requires=[
        'fastapi',
        'uvicorn',
        'pyyaml',
    ],
    entry_points={
        'console_scripts': [
            'agent = agent.agent:main',
        ],
    },
    author='Oliveira, Cleyson',
    description='A system agent that exposes a REST API and ingresses system data.',
    classifiers=[
        'Programming Language :: Python :: 3',
        'Operating System :: Unix',
    ],
    python_requires='>=3.7',
)
