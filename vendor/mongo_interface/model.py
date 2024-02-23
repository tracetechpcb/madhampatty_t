from pydantic import BaseModel


# Base model that includes the common Config
class MongoDBModel(BaseModel):
    class Config:
        # Disallow extra fields
        allow_extra = False
