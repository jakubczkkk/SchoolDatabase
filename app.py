from flask import Flask, render_template
from connect_to_db import db

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('main.html')

@app.route('/klasa')
def uczniowie():

    db.execute("SELECT nazwa FROM klasa;");
    classes = db.fetchall()
    
    return render_template('classes.html', classes=classes)

@app.route('/klasa/<klasa>')
def uczniowie_w_klasie(klasa):

    db.execute("SELECT nazwa FROM klasa;");
    classes = db.fetchall()

    db.execute(f"SELECT imie, nazwisko, id_uczen FROM uczen JOIN klasa ON uczen.id_klasa=klasa.id_klasa WHERE klasa.nazwa like '{klasa}' ORDER BY nazwisko, imie;")
    students = db.fetchall()

    return render_template('students.html', students=students, classes=classes)

@app.route('/uczen/<id_uczen>')
def uczen(id_uczen):

    db.execute(f"SELECT imie, nazwisko, id_uczen FROM uczen WHERE uczen.id_uczen = {id_uczen};")
    student_info = db.fetchall()

    return render_template('student.html', student_info=student_info)

@app.route('/uczen/<id_uczen>/oplaty')
def uczen_oplaty(id_uczen):

    db.execute(f"SELECT imie, nazwisko, id_uczen FROM uczen WHERE uczen.id_uczen = {id_uczen};")
    student_info = db.fetchall()

    db.execute(f"SELECT ile_do_zaplacenia, ile_zostalo_zaplacone, opis FROM oplata WHERE id_uczen={id_uczen}")
    oplaty = db.fetchall()

    return render_template('student_oplaty.html', student_info=student_info, oplaty=oplaty)

@app.route('/uczen/<id_uczen>/oceny')
def uczen_oceny(id_uczen):


    db.execute(f"SELECT imie, nazwisko, id_uczen FROM uczen WHERE id_uczen={id_uczen}")
    student_info = db.fetchall()

    db.execute(f"SELECT przedmiot.nazwa, opis FROM ocena JOIN przedmiot_nauczany_w_klasie pnk ON pnk.id_przedmiot_nauczany_w_klasie=ocena.id_przedmiot JOIN przedmiot ON pnk.id_przedmiot=przedmiot.id_przedmiot WHERE id_uczen = {id_uczen};")
    grades = db.fetchall()

    return render_template('student_grades.html', student_info=student_info, grades=grades)

@app.route('/uczen/<id_uczen>/frekwencja')
def uczen_frekwencja(id_uczen):

    db.execute(f"SELECT imie, nazwisko, id_uczen FROM uczen WHERE uczen.id_uczen = {id_uczen};")
    student_info = db.fetchall()

    db.execute(f"SELECT id_lekcja, opis FROM frekwencja WHERE id_uczen={id_uczen}")
    frequency = db.fetchall()

    return render_template('student_frekwencja.html', student_info=student_info, frequency=frequency)
