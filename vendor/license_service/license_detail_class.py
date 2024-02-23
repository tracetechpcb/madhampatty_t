from datetime import datetime
from typing import Optional

from vendor.mongo_interface.model import MongoDBModel


class LicenseDetail(MongoDBModel):
    users: int
    expiry_on: str
    is_expired: Optional[bool] = False

    @property
    def users_property(self):
        return self.users

    @users_property.setter
    def users_property(self, users):
        self.users = users

    @property
    def expiry_on_property(self):
        return self.expiry_on

    @expiry_on_property.setter
    def expiry_on_property(self, expiry_on):
        self.expiry_on = expiry_on

    @property
    def is_expired_property(self):
        # Convert expiry_on from "dd-mm-yyyy" to a datetime object
        expiry_date = datetime.strptime(self.expiry_on, "%d-%m-%Y")
        # Compare expiry_date with the current date
        return expiry_date < datetime.now()