from flask import Flask
from flask import render_template
from connect_to_db import db

app = Flask(__name__)

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/uczniowie')
def show_students():
    db.execute("""SELECT imie, nazwisko, nazwa klasa FROM uczen JOIN klasa ON uczen.id_klasa=klasa.id_klasa ORDER BY nazwisko, imie;""")
    students = db.fetchall()
    return render_template('table.html', data=students, column_names=["Imię", "Nazwisko", "Klasa"])

@app.route('/nauczyciele')
def show_teachers():
    db.execute("""SELECT imie, nazwisko FROM nauczyciel ORDER BY nazwisko, imie;""")
    teachers = db.fetchall()
    return render_template('table.html', data=teachers, column_names=["Imię", "Nazwisko"])

@app.route('/klasy')
def show_classes():
    db.execute("""SELECT nazwa klasa, concat(imie, ' ', nazwisko) wychowawca FROM klasa JOIN nauczyciel ON klasa.id_wychowawca=nauczyciel.id_nauczyciel ORDER BY nazwa;""")
    classes = db.fetchall()
    return render_template('table.html', data=classes, column_names=["Klasa", "Wychowawca"])

@app.route('/przedmioty')
def show_subjects():
    db.execute("""SELECT nazwa FROM przedmiot ORDER BY nazwa;""")
    subjects = db.fetchall()
    return render_template('table.html', data=subjects, column_names=["Nazwa"])

@app.route('/sale')
def show_classrooms():
    db.execute("""SELECT numer FROM sala ORDER BY numer;""")
    classrooms = db.fetchall()
    return render_template('table.html', data=classrooms, column_names=["Numer"])
