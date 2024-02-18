from django.urls import path, include
from django.views.generic.base import RedirectView

from rest_framework_simplejwt.views import (
    TokenObtainSlidingView,
    TokenRefreshSlidingView
)

urlpatterns = [
    path('api/token/sliding/', TokenObtainSlidingView.as_view(), name='token_obtain_sliding'),
    path('api/token/sliding/refresh/', TokenRefreshSlidingView.as_view(), name='token_refresh_sliding'),
]
