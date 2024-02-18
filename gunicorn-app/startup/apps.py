from django.apps import AppConfig
from django.db.models.signals import post_migrate
from django.dispatch import receiver

class StartupConfig(AppConfig):
    name = 'startup'
    default_username = "admin@tracetech.com"
    default_password = "admin123A!!"
    default_email = "admin@tracetech.com"  # Fixed typo from 'defualt_email' to 'default_email'

    def ready(self):
        # Connect the post_migrate signal to the handler
        post_migrate.connect(self.post_migrate_handler, sender=self)

    def post_migrate_handler(self, *args, **kwargs):
        # Call the methods to perform actions after migration
        self.create_default_user()
        self.add_default_license()

    def create_default_user(self):
        from django.contrib.auth.models import User
        # Function to create a default user
        if not User.objects.filter(username=self.default_username).exists():
            User.objects.create_user(self.default_username, self.default_email, self.default_password)

    def add_default_license(self):
        from license.models import License
        import os
        # Function to create or update default license
        if os.getenv("LICENSE_KEY"):
            License.objects.all().delete()
            License.objects.create(licensekey=os.getenv("LICENSE_KEY"), status="active")
