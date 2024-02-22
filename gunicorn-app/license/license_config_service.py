from license.license_db_service import LicenseDBService
from license.license_class import License
from license.licenses_class import Licenses

class LicenseConfigService():
    @staticmethod
    def get_all_licenses() -> Licenses:
        return LicenseDBService.get_all_licenses()

    @staticmethod
    def get_license(uid: str) -> License:
        return LicenseDBService.get_license(uid)

    @staticmethod
    def create_license(license_obj: License) -> None:
        LicenseDBService.create_license(license_obj)

    @staticmethod
    def delete_license(uid: str) -> None:
        LicenseDBService.delete_license(uid)

