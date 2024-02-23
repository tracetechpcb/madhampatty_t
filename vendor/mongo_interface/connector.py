import os
from pymongo import MongoClient
from pymongo.errors import CollectionInvalid

# Global variable to hold the MongoDB client
mongo_client = None
db = None


def connect():
    global mongo_client
    global db

    uri = os.getenv("MONGODB_DATABASE_URL")
    mongo_client = MongoClient(uri)
    db = mongo_client[os.getenv("MONGODB_DB_NAME")]


def create_collection(klass) -> None:
    collection_name = klass.__name__
    try:
        collection = db.create_collection(collection_name)
    except CollectionInvalid:
        # collection already exists
        pass


def create_index(klass, fields: list, unique: bool = True) -> None:
    collection_name = klass.__name__
    collection = db[collection_name]
    collection.create_index(fields, unique=unique)


def get_all_documents(klass, filter_query=None, sort_field=None, sort_order=1):
    collection_name = klass.__name__
    collection = db[collection_name]


    query = {} if filter_query is None else filter_query

    documents = collection.find(query)

    if sort_field is not None:
        documents = documents.sort(sort_field, sort_order)

    return list(documents)


def get_all_documents_with_pagination(klass, page=1, per_page=10, filter_query=None, sort_field=None, sort_order=1):
    collection_name = klass.__name__
    collection = db[collection_name]

    # Calculate the offset based on the current page and number of documents per page
    offset = (page - 1) * per_page

    query = {} if filter_query is None else filter_query

    documents = collection.find(query).skip(offset).limit(per_page)

    if sort_field is not None:
        documents = documents.sort(sort_field, sort_order)

    return list(documents)


def get_document_by_uid(klass, uid):
    collection_name = klass.__name__
    collection = db[collection_name]
    document = collection.find_one({'uid': uid})
    return document


def insert_document(klass, document):
    collection_name = klass.__name__
    collection = db[collection_name]
    result = collection.insert_one(document)
    return result.inserted_id


def insert_documents(klass, documents):
    collection_name = klass.__name__
    collection = db[collection_name]
    result = collection.insert_many(documents)
    return result.inserted_ids


def delete_document_by_uid(klass, uid):
    collection_name = klass.__name__
    collection = db[collection_name]
    result = collection.delete_one({'uid': uid})
    return result.deleted_count


def delete_all_documents(klass):
    collection_name = klass.__name__
    collection = db[collection_name]
    result = collection.delete_many({})  # Empty filter matches all documents
    return result.deleted_count  # Returns the number of documents deleted