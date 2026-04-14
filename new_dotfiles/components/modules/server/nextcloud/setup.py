from setuptools import setup

setup(
    entry_points={
        'console_scripts': [
            'my_nextcloud_cloudbackup = cloud_scripts.cloudbackup:main',
            'my_nextcloud_preview_generator = cloud_scripts.preview_generator:main',
        ]
    }
)