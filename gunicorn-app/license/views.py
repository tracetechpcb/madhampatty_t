from django.http import HttpRequest
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from license.license_config_service import LicenseConfigService
from license.license_class import License
from license.licenses_class import Licenses


class LicenseAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request: HttpRequest, uid: str=None) -> Response:
        if uid is not None:
            license_obj: License = LicenseConfigService.get_license(uid)
            return Response(license_obj.model_dump())
        else:
            licenses_obj: Licenses = LicenseConfigService.get_all_licenses()
            return Response(licenses_obj.model_dump())
