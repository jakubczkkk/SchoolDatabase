const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const pg = require("pg");

const app = express();
app.use(cors());

const PORT = 5000;
const CONNETION_STRING = "postgres://hteoajtw:2uSjqGQVjyBFqIFZVX2u_mJndOIN9kpk@dumbo.db.elephantsql.com:5432/hteoajtw";
const client = new pg.Client(CONNETION_STRING);
client.connect(err => {
  if (err) return console.error('could not connect to postgres', err);
  app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
});

app.get('/raport/:tabela', (req, res) => {

  client.query(`SELECT * FROM ${req.params.tabela}_raport`, function(err, result) {
    if (err) return console.error('error running query', err);
    res.send(JSON.stringify(result.rows));
  });

});

