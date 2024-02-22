from mongodb.mongodb_model import MongoDBModel
from typing import List

class MobileNumber(MongoDBModel):
    country_code: int = ...
    device_number: int = ...

    @property
    def country_code_property(self):
        return self.country_code

    @country_code_property.setter
    def country_code_property(self, country_code):
        self.country_code = country_code

    @property
    def device_number_property(self):
        return self.device_number

    @device_number_property.setter
    def device_number_property(self, device_number):
        self.device_number = device_number