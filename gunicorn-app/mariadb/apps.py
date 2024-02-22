import os
from django.apps import AppConfig
from django.db.models.signals import post_migrate

class MariadbConfig(AppConfig):
    name = 'mariadb'
    default_username = os.getenv("DEFAULT_APPLICATION_USERNAME")
    default_password = os.getenv("DEFAULT_APPLICATION_PASSWORD")
    default_email = os.getenv("DEFAULT_APPLICATION_EMAIL")

    def ready(self):
        post_migrate.connect(self.create_default_user, sender=None)

    def create_default_user(self, sender, **kwargs):
        from django.contrib.auth.models import User
        # Function to create a default user
        if not User.objects.filter(username=self.default_username).exists():
            User.objects.create_user(self.default_username, self.default_email, self.default_password)
