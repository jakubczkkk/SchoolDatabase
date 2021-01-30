const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const pg = require("pg");

const app = express();
app.use(cors());
app.use(bodyParser())
const DATABASE_URL='postgres://hteoajtw:2uSjqGQVjyBFqIFZVX2u_mJndOIN9kpk@dumbo.db.elephantsql.com:5432/hteoajtw'
const PORT = process.env.PORT || 5000;
const client = new pg.Client(DATABASE_URL);
client.connect(err => {
  if (err) return console.error('could not connect to postgres', err);
  app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
});

app.get('/', (req, res) => {
  res.sendFile('index.html');
})

app.get('/raport/:tabela', (req, res) => {

  client.query(`SELECT * FROM ${req.params.tabela}_raport`, (err, result) => {
    if (err) return console.error('error running query', err);
    res.send(JSON.stringify(result.rows));
  });

});

app.post('/dodaj/:tabela', (req, res) => {

  let columnNames = "";
  Object.keys(req.body).forEach(param => columnNames += `${param},` );

  let values = ""
  Object.values(req.body).forEach(param => values += `'${param}',` );

  client.query(`INSERT INTO ${req.params.tabela} (${columnNames.slice(0, -1)})
  VALUES (${values.slice(0, -1)})`, (err, result) => {
    if (err) res.status(404).send({message: err.message});
    else res.send({message: 'Dodano do bazy!'});
  });

});

app.delete('/usun/:tabela', (req, res) => {

  client.query(`DELETE FROM ${req.params.tabela}
  WHERE id_${req.params.tabela}=${req.body.id}`,
  (err, result) => {
      if (err) res.status(404).send({message: err.message});
      else res.send({message: 'Usunięto z bazy!'});
  });

});

app.post('/zmien/:tabela/:id', (req, res) => {

  let columnNames = "";
  Object.keys(req.body).forEach(param => columnNames += `${param},` );

  let values = ""
  Object.values(req.body).forEach(param => values += `'${param}',` );

  client.query(`UPDATE ${req.params.tabela}
  SET (${columnNames.slice(0, -1)}) = (${values.slice(0, -1)})
  WHERE id_${req.params.tabela} = '${req.params.id}'`,
  (err, result) => {
      if (err) res.status(404).send({message: err.message});
      else res.send({message: 'Zmieniono zawartość'});
  });

});

app.post('/info/:funkcja', (req, res) => {

  client.query(`SELECT * FROM ${req.params.funkcja} ('${Object.values(req.body)[0]}')`,
  (err, result) => {
      if (err) res.status(404).send({message: err.message});
      else res.send(JSON.stringify(result.rows));
  });

});