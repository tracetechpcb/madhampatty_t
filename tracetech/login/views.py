from django.shortcuts import render
from license.models import License

import base64
import json
from datetime import date

from django.shortcuts import render, redirect
from django.contrib.auth import login
from django.contrib.auth.models import User
from django.views import View

import logging

logger = logging.getLogger(__name__)

class LoginView(View):
    def __init__(self, *args, **kwargs):
        super(LoginView, self).__init__(*args, **kwargs)
        self.context = {}  # Now it's an instance variable

    def get(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            next_url = request.GET.get('next', 'dashboard')  # Get 'next' parameter or set default
            return redirect(next_url)

        self.check_license()
        return render(request, "login.html", self.context)


    def post(self, request, *args, **kwargs):
        username = request.POST.get('email', '')
        password = request.POST.get('password', '')
        logger.debug("David")
        logger.info("Daniel")
        logger.info(username)
        logger.info(password)
        try:
            user = User.objects.get(username=username)
        except User.DoesNotExist:
            self.context["alert"] = "Invalid username or password"
        else:
            if user.password == password:
                login(request, user)
                # Directly read 'next' from the request's GET parameters
                next_url = request.GET.get('next', 'dashboard')
                return redirect(next_url)
            else:
                self.context["alert"] = "Invalid username or password"

        return render(request, "login.html", self.context)


    def check_license(self):
        # Compute the license validity
        license_list = License.objects.filter(status='active')
        license = license_list[0]
        license_key = license.licensekey

        decoded_license_dict  = {}
        try:
            # Decode the Base64 encoded string
            decoded_license_bytes = base64.b64decode(license_key, validate=True)
            decoded_license_str = decoded_license_bytes.decode('utf-8')
            decoded_license_dict = json.loads(decoded_license_str)
        except Exception:
            self.context["license_status"] = "invalid"
            self.context["license_message"] = "License Invalid. Configure a valid license to log in."
        else:
            current_date = date.today()

            target_date_list = decoded_license_dict["expiry_on"].split("-")
            target_date = date(int(target_date_list[2]), int(target_date_list[1]), int(target_date_list[0]))

            difference = target_date - current_date

            if difference.days > 0:
                self.context["license_status"] = "valid"
                if difference.days <= 7:
                    self.context["license_message"] = f"License is valid for {difference.days}"
                elif difference.days <=30:
                    self.context["license_message"] = f"License is valid till {decoded_license_dict['expiry_on']}"
            else:
                self.context["license_status"] = "expired"
                self.context["license_message"] = "License expired. Configure a valid license to log in."