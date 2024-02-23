from vendor.license_service.license_detail_class import LicenseDetail
from vendor.mongo_interface.model import MongoDBModel


class LicenseDetails(MongoDBModel):
    license_details: list[LicenseDetail]

    @property
    def license_details_property(self):
        return self.license_details

    @license_details_property.setter
    def license_details_property(self, license_details):
        self.license_details = license_details