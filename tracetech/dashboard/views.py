from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render
from django.views import View

class DashboardView(LoginRequiredMixin, View):
    def __init__(self, *args, **kwargs):
        super(DashboardView, self).__init__(*args, **kwargs)
        self.context = {}

    def get(self, request, *args, **kwargs):
        return render(request, "dashboard.html", self.context)