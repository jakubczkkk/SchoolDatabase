import os
import urllib.parse as up
import psycopg2
from db_url import db_url

up.uses_netloc.append("postgres")
url = up.urlparse(db_url)
conn = psycopg2.connect(database=url.path[1:],
    user=url.username,
    password=url.password,
    host=url.hostname,
    port=url.port
)

db = conn.cursor()

create_base_file = open('sql/create_base.sql', encoding='utf-8', mode='r')
db.execute(create_base_file.read())

default_inserts_file = open('sql/default_inserts.sql', encoding='utf-8', mode='r')
db.execute(default_inserts_file.read())

conn.commit()
