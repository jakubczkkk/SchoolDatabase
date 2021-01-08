from flask import Flask
from flask import render_template
from connect_to_db import db

app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/students')
def show_students():
    db.execute("""SELECT imie, nazwisko, nazwa FROM uczen u JOIN klasa k ON u.id_klasa = k.id_klasa ORDER BY nazwisko, imie;""")
    students = db.fetchall()
    return render_template('table.html', students=students)