const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");
const cors = require("cors");
const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

// Conexión a la base de datos
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "clinica",
});

db.connect((err) => {
  if (err) throw err;
  console.log("Conectado a MySQL");
});

// Ruta de login
app.post("/login", (req, res) => {
  const { username, password } = req.body;
  const sql = "SELECT * FROM usuarios WHERE username = ? AND password = ?";
  db.query(sql, [username, password], (err, results) => {
    if (err) return res.status(500).send("Error en el servidor");
    if (results.length > 0) {
      res.json({
        success: true,
        nombre: results[0].nombre,
        rol: results[0].rol,
      });
    } else {
      res.json({ success: false, message: "Usuario o contraseña incorrectos" });
    }
  });
});

app.listen(PORT, () =>
  console.log(`Servidor corriendo en http://localhost:${PORT}`)
);
