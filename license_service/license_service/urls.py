from django.urls import path, include

urlpatterns = [
    path('api/license/', include('license.urls')),
]
