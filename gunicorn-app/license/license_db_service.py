from mongodb import mongodb_utils
from license.license_class import License
from license.licenses_class import Licenses
from django.http import Http404


class LicenseDBService():
    @staticmethod
    def get_all_licenses() -> Licenses:
        documents = mongodb_utils.get_all_documents(License)
        print(documents)
        return Licenses(licenses=documents)

    @staticmethod
    def get_license(uid: str) -> License:
        document = mongodb_utils.get_document_by_uid(License, uid)
        if document is None:
            raise Http404("License not found")
        return License(**document)

    @staticmethod
    def create_license(license_obj: License) -> None:
        mongodb_utils.insert_document(License, license_obj.model_dump())

    @staticmethod
    def delete_license(uid: str) -> None:
        document = mongodb_utils.get_document_by_uid(License, uid)
        if document is None:
            raise Http404("License not found")
        mongodb_utils.delete_document_by_uid(License, uid)
