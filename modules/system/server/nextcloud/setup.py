from setuptools import setup

setup(
    entry_points={
        'console_scripts': [
            'cloudbackup = cloud_scripts.cloudbackup:main',
            'preview_generator = cloud_scripts.preview_generator:main',
        ]
    }
)