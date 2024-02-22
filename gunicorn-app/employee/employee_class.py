from pydantic import EmailStr
from mongodb.mongodb_model import MongoDBModel
from uuid import uuid4
from typing import List
from employee.mobile_number_class import MobileNumber
from employee.reports_to_class import ReportsTo

class Employee(MongoDBModel):
    uid: str = str(uuid4())

    name: str = ...
    email_address: EmailStr = ...
    role: str = ...
    reports_to: ReportsTo = ...
    login_enabled: bool = ...

    age: int
    gender: str
    address: str
    contact_number: List[MobileNumber]
    first_time_login: bool

    @property
    def uid_property(self):
        return self.uid

    @property
    def name_property(self):
        return self.name

    @name_property.setter
    def name_property(self, name):
        self.name = name

    @property
    def role_property(self):
        return self.role_property

    @role_property.setter
    def role_property(self, role):
        self.role = role

    @property
    def reports_to_property(self):
        return self.reports_to

    @reports_to_property.setter
    def reports_to_property(self, reports_to):
        self.reports_to = reports_to

    @property
    def login_enabled_property(self):
        return self.login_enabled

    @reports_to_property.setter
    def login_enabled_property(self, login_enabled):
        self.login_enabled = login_enabled

    @property
    def age_property(self):
        return self.age

    @age_property.setter
    def age_property(self, age):
        self.age = age

    @property
    def gender_property(self):
        return self.gender

    @gender_property.setter
    def gender_property(self, gender):
        self.gender = gender

    @property
    def address_property(self):
        return self.address

    @address_property.setter
    def address_property(self, address):
        self.address = address

    @property
    def contact_number_property(self):
        return self.contact_number

    @contact_number_property.setter
    def contact_number_property(self, contact_number):
        self.contact_number = contact_number

    @property
    def first_time_login_property(self):
        return self.first_time_login

    @first_time_login_property.setter
    def first_time_login_property(self, first_time_login):
        self.first_time_login = first_time_login