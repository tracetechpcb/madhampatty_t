from django.db import models

class UserCredentails(models.Model):
    username = models.CharField(max_length=255, unique=True)
    password = models.CharField(max_length=255)
    reset = models.BooleanField(default=False)

    class Meta:
        db_table = 'user_creds'

    def __str__(self):
        return f"{self.username} (Reset: {self.reset})"