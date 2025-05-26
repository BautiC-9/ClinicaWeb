// db/conexion.js
const mysql = require("mysql2");

const conexion = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "2023",
  database: "clinica",
});

conexion.connect((err) => {
  if (err) throw err;
  console.log("🟢 Conectado a la base de datos");
});

module.exports = conexion;
