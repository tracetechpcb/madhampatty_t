from django.urls import path
from license.views import (get_license, get_license_detail,
                           list_license_details, list_licenses)

# Order of the paths is very important. Always up the fixed paths on top
urlpatterns = [
    path('', list_licenses),
    path('details/', list_license_details),
    path('details/<str:uid>/', get_license_detail),
    path('<str:uid>/', get_license),
]
