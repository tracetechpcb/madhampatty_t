import os

from django.apps import AppConfig
from license.license_config_service import LicenseConfigService
from vendor.license_service.license_class import License
from vendor.mongo_interface import connector


class LicenseConfig(AppConfig):
    name = 'license'

    def ready(self):
        # Connect to mongo from this service
        connector.connect()
        self.create_collection()
        self.add_license_key()


    def create_collection(self):
        connector.create_collection(License)
        connector.create_index(License, [("uid", 1)], unique=True)
        connector.create_index(License, [("license_key", 1)], unique=True)


    def add_license_key(self):
        # Delete all licenses in the DB on startup
        LicenseConfigService.delete_all_licenses()

        license_key: str = os.getenv("LICENSE_KEY")

        is_valid = LicenseConfigService.is_license_valid(license_key)
        if is_valid:
            license_object: License = License(license_key=license_key)
            LicenseConfigService.create_license(license_object)
        else:
            raise Exception("License Key is not valid")