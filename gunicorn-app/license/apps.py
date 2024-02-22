import os

from django.apps import AppConfig
from mongodb import mongodb_utils
from license.license_class import License

import logging
logger = logging.getLogger(__name__)


class LicenseConfig(AppConfig):
    name = 'license'

    def ready(self):
        self.add_license_key()

    def add_license_key(self):
        mongodb_utils.delete_all_documents(License)
        license_object = License(license_key=os.getenv("LICENSE_KEY"), is_active=True)

        mongodb_utils.insert_document(License, license_object.model_dump ())

        logger.info(mongodb_utils.get_all_documents(License))