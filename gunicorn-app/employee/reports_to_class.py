from pydantic import EmailStr
from mongodb.mongodb_model import MongoDBModel


class ReportsTo(MongoDBModel):
    uid: str = ...
    name: str
    email_address: EmailStr


    @property
    def uid_property(self):
        return self.uid

    @uid_property.setter
    def uid_property(self, uid):
        self.uid = uid

    @property
    def name_property(self):
        return self.name

    @name_property.setter
    def name_property(self, name):
        self.name = name

    @property
    def email_address_property(self):
        return self.email_address

    @email_address_property.setter
    def email_address_property(self, email_address):
        self.email_address = email_address