const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const waitOn = require('wait-on');

const app = express();
const port = 3000;

const dbConfig = {
  host: 'db', // Usando o nome de serviço do contêiner MySQL definido no docker-compose.yml
  user: 'admin',
  password: '123',
  database: 'db_fase',
};

// Função para esperar até que o banco de dados esteja disponível
async function waitForDatabase() {
  try {
    await waitOn({ resources: [`tcp:${dbConfig.host}:3306`] });
    console.log('Banco de dados pronto. Iniciando o servidor...');
    startServer();
  } catch (error) {
    console.error('Erro ao aguardar o banco de dados:', error.message);
    process.exit(1); // Encerrar o processo com código de erro caso o banco de dados não esteja disponível
  }
}

// Configuração do banco de dados
let connection;

// Função para conectar ao banco de dados
function connectToDatabase() {
  connection = mysql.createConnection(dbConfig);
}

// Configuração do bodyParser para interpretar dados do formulário
app.use(bodyParser.urlencoded({ extended: true }));

app.post('/salvar', (req, res) => {
  const { nome, email } = req.body;
  const query = 'INSERT INTO usuarios (nome, email) VALUES (?, ?)';
  const values = [nome, email];
  connection.query(query, values, (err, result) => {
    if (err) {
      console.log('Erro ao salvar dados:', err);
      res.status(500).send('Erro ao salvar dados.');
    } else {
      console.log('Dados salvos com sucesso:', result.insertId);
      res.status(200).send('Dados salvos com sucesso.');
    }
  });
});

function startServer() {
  app.listen(port, () => {
    console.log(`Servidor rodando em http://localhost:${port}`);
  });
}

// Chamar a função para aguardar o banco de dados antes de iniciar o servidor
waitForDatabase();
connectToDatabase();

