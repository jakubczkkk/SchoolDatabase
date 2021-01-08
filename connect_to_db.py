import os
import urllib.parse as up
import psycopg2

up.uses_netloc.append("postgres")
url = up.urlparse("postgres://hteoajtw:2uSjqGQVjyBFqIFZVX2u_mJndOIN9kpk@dumbo.db.elephantsql.com:5432/hteoajtw")
conn = psycopg2.connect(database=url.path[1:],
    user=url.username,
    password=url.password,
    host=url.hostname,
    port=url.port
)
db = conn.cursor()