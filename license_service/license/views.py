from django.http import HttpRequest
from license.license_config_service import LicenseConfigService
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from vendor.license_service.license_class import License
from vendor.license_service.license_detail_class import LicenseDetail
from vendor.license_service.license_details_class import LicenseDetails
from vendor.license_service.licenses_class import Licenses


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_licenses(request):
    licenses_obj: Licenses = LicenseConfigService.get_all_licenses()
    return Response(licenses_obj.model_dump())


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_license(request, uid):
    license_obj: License = LicenseConfigService.get_license(uid)
    return Response(license_obj.model_dump())


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_license_details(request):
    license_details_obj: LicenseDetails = LicenseConfigService.get_all_license_details()
    return Response(license_details_obj.model_dump())


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_license_detail(request, uid):
    license_detail_obj: LicenseDetail = LicenseConfigService.get_license_detail(uid)
    return Response(license_detail_obj.model_dump())