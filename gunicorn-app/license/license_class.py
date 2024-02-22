from mongodb.mongodb_model import MongoDBModel
from uuid import uuid4


class License(MongoDBModel):
    uid: str = str(uuid4())
    license_key: str = ...
    is_active: bool = ...

    @property
    def uid_property(self):
        return self.uid

    @property
    def license_key_property(self):
        return self.license_key

    @license_key_property.setter
    def license_key_property(self, license_key):
        self.license_key = license_key

    @property
    def is_active_property(self):
        return self.is_active

    @is_active_property.setter
    def is_active_property(self, is_active):
        self.is_active = is_active