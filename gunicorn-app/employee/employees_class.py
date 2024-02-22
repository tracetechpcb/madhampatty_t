from mongodb.mongodb_model import MongoDBModel
from typing import List
from employee.employee_class import Employee

class Employees(MongoDBModel):
    employees: List[Employee] = ...

    @property
    def employees_property(self):
        return self.employees

    @employees_property.setter
    def employees_property(self, employees):
        self.employees = employees