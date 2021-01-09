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
