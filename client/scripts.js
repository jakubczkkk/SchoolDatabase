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
