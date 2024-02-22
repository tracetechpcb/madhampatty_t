from django.apps import AppConfig

class MongodbConfig(AppConfig):
    name = 'mongodb'

    def ready(self):
        # Establish connection to mongo
        from .mongodb_utils import setup_mongo_connection
        setup_mongo_connection()
