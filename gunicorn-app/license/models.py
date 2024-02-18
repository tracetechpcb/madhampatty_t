from django.db import models

class License(models.Model):
    licensekey = models.CharField(max_length=255, unique=True)
    status = models.CharField(max_length=255)

    class Meta:
        db_table = 'license'

    def __str__(self):
        return self.licensekey
