from flask import Flask, render_template
from connect_to_db import db

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('main.html')

@app.route('/raporty')
def raporty():
    return render_template('raporty.html')

@app.route('/raporty/uczen')
def raporty_uczen():
    db.execute("SELECT * FROM uczen_raport;");
    students = db.fetchall()
    return render_template('raporty_uczen.html', students=students)

@app.route('/raporty/klasa')
def raporty_klasa():
    db.execute("SELECT * FROM klasa_raport;");
    classes = db.fetchall()
    return render_template('raporty_klasa.html', classes=classes)

@app.route('/raporty/nauczyciel')
def raporty_nauczyciel():
    db.execute("SELECT * FROM nauczyciel_raport;");
    teachers = db.fetchall()
    return render_template('raporty_nauczyciel.html', teachers=teachers)

@app.route('/dodawanie')
def dodawanie():
    return render_template('dodawanie.html')

@app.route('/edytowanie')
def edytowanie():
    return render_template('edytowanie.html')

@app.route('/usuwanie')
def usuwanie():
    return render_template('usuwanie.html')