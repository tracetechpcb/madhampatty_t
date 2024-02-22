from django.urls import path
from license.views import LicenseAPIView

urlpatterns = [
    path('', LicenseAPIView.as_view()),
    path('<str:uid>/', LicenseAPIView.as_view()),
]
