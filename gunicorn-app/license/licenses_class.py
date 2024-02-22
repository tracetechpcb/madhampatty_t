from mongodb.mongodb_model import MongoDBModel
from typing import List
from license.license_class import License

class Licenses(MongoDBModel):
    licenses: List[License] = ...

    @property
    def licenses_property(self):
        return self.licenses

    @licenses_property.setter
    def licenses_property(self, licenses):
        self.licenses = licenses