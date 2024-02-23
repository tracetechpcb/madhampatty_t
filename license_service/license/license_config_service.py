import base64
import json

from license.license_db_service import LicenseDBService
from vendor.license_service.license_class import License
from vendor.license_service.license_detail_class import LicenseDetail
from vendor.license_service.license_details_class import LicenseDetails
from vendor.license_service.licenses_class import Licenses


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
    def delete_all_licenses() -> None:
        LicenseDBService.delete_all_licenses()

    @staticmethod
    def delete_license(uid: str) -> None:
        LicenseDBService.delete_license(uid)

    @staticmethod
    def get_all_license_details() -> LicenseDetails:
        license_details_list: list[LicenseDetail] = []
        licenses_obj: Licenses = LicenseDBService.get_all_licenses()
        for license in licenses_obj.licenses_property:
            uid: str = license.uid_property
            license_details_list.append(LicenseConfigService.get_license_detail(uid))
        return LicenseDetails(license_details=license_details_list)

    @staticmethod
    def get_license_detail(uid: str) -> LicenseDetail:
        license_obj: License = LicenseDBService.get_license(uid)
        license_key: str = license_obj.license_key_property
        license_details: dict = LicenseConfigService._parser_license(license_key)
        license_details_obj: LicenseDetail = LicenseDetail(**license_details)
        return license_details_obj

    @staticmethod
    def is_license_valid(license_key: str) -> bool:
        try:
            LicenseConfigService._parser_license(license_key)
            return True
        except:
            return False

    @staticmethod
    def _parser_license(license_key: str) -> dict:
        decoded_bytes: bytes = base64.b64decode(license_key)
        decoded_str: str = decoded_bytes.decode('utf-8')
        return json.loads(decoded_str)