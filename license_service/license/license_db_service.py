
from django.http import Http404
from vendor.license_service.license_class import License
from vendor.license_service.licenses_class import Licenses
from vendor.mongo_interface import connector


class LicenseDBService():
    @staticmethod
    def get_all_licenses() -> Licenses:
        documents = connector.get_all_documents(License)
        return Licenses(licenses=documents)

    @staticmethod
    def get_license(uid: str) -> License:
        document = connector.get_document_by_uid(License, uid)
        if document is None:
            raise Http404("License not found")
        return License(**document)

    @staticmethod
    def create_license(license_obj: License) -> None:
        connector.insert_document(License, license_obj.model_dump())

    @staticmethod
    def delete_license(uid: str) -> None:
        document = connector.get_document_by_uid(License, uid)
        if document is None:
            raise Http404("License not found")
        connector.delete_document_by_uid(License, uid)

    @staticmethod
    def delete_all_licenses() -> None:
        connector.delete_all_documents(License)