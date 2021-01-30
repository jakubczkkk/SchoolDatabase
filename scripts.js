const SERVER_URL = "http://localhost:5000/";

function wyborAkcji(id) {

  [...document.getElementsByClassName("akcja-nav")]
  .forEach(element => element.style.display = element.id == id ? "block" : "none");

}

function JSONToTable(json) {

  let cols = Object.keys(json[0]);
  let headers = cols.map(col => `<th>${col}</th>`).join("");

  let rows = json
  .map(row => {
    let tds = cols.map(col => `<td>${row[col]}</td>`).join("");
    return `<tr>${tds}</tr>`;
  })
  .join("");

  const table = `
                <table>
                  <thead>
                    <tr>
                      ${headers}
                    </tr>
                  <thead>
                  <tbody>
                    ${rows}
                  <tbody>
                <table>`;

  return table;

}

function raport(tabela) {

  fetch(
    SERVER_URL + `raport/${tabela}`,
    {method: 'get', headers: {'Content-Type': 'application/json'}}
  )
  .then(res => res.json().then(json => document.getElementById("raporty-tabela").innerHTML = JSONToTable(json)));

}

function dodawanie(tabela) {

  [...document.getElementsByClassName("dodawanie")]
  .forEach(element => element.style.display = element.id == `dodaj-${tabela}` ? "block" : "none");  

}

function edytowanie(tabela) {

  [...document.getElementsByClassName("edytowanie")]
  .forEach(element => element.style.display = element.id == `zmien-${tabela}` ? "block" : "none");  

}

function dodaj(tabela) {

  const data = {};
  [...document.forms[`dodaj-${tabela}-form`].getElementsByTagName("input")]
  .forEach(input => data[input.name] = input.value);
  fetch(
    SERVER_URL + `dodaj/${tabela}`,
    {method: 'post', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(data)},
  )
  .then(res => res.json().then(json => document.getElementById("database-response").innerHTML = json.message));

}

function usun() {

  const toDelete = {
    id: document.forms['usuwanie-form']['id'].value
  };
  fetch(
    SERVER_URL + `usun/${document.forms['usuwanie-form']['tabela'].value}`,
    {method: 'delete', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(toDelete)},
  )
  .then(res => res.json().then(json => document.getElementById("database-response").innerHTML = json.message));

}

function zmien(tabela) {

  const data = {};
  [...document.forms[`zmien-${tabela}-form`].getElementsByTagName("select")]
  .forEach(select => data[select.name] = select.value);
  [...document.forms[`zmien-${tabela}-form`].getElementsByTagName("input")]
  .filter(input => input.name != 'id')
  .forEach(input => data[input.name] = input.value);

  fetch(
    SERVER_URL + `zmien/${tabela}/${document.forms[`zmien-${tabela}-form`]['id'].value}`,
    {method: 'post', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(data)},
  )
  .then(res => res.json().then(json => document.getElementById("database-response").innerHTML = json.message));

}

function informacje(funkcja) {

  [...document.getElementsByClassName("informacje")]
  .forEach(element => element.style.display = element.id == `info-${funkcja}` ? "block" : "none");   

}

function info(funkcja) {

  const data = {};
  [...document.forms[`info-${funkcja}-form`].getElementsByTagName("input")]
  .forEach(select => data[select.name] = select.value);

  fetch(
    SERVER_URL + `info/${funkcja}`,
    {method: 'post', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(data)},
  )
  .then(res => res.json().then(json => document.getElementById("info-response").innerHTML = res.status == 200 ? JSONToTable(json) : json.message));

}