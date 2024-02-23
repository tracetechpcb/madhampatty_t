from vendor.mongo_interface.model import MongoDBModel
from uuid import uuid4

class License(MongoDBModel):
    uid: str = str(uuid4())
    license_key: str

    @property
    def uid_property(self):
        return self.uid

    @property
    def license_key_property(self):
        return self.license_key

    @license_key_property.setter
    def license_key_property(self, license_key):
        self.license_key = license_key