/ routes/auth.js
const express = require("express");
const router = express.Router();
const conexion = require("../db/conexion");

// Login de usuarios
router.post("/login", (req, res) => {
const { usuario, password } = req.body;

// Consulta que une usuario con persona y verifica usuario activo
const sql = `  SELECT u.*, p.nombre, p.apellido, p.id_rol
  FROM usuario u
  JOIN persona p ON u.id_persona = p.id_persona
  WHERE u.nombre_usuario = ?
  LIMIT 1`;

conexion.query(sql, [usuario], (err, results) => {
console.log(results); // 👉 para ver si hay algo
});
conexion.query(sql, [usuario, usuario, usuario], (err, results) => {
if (err) {
console.error("Error en la consulta:", err);
return res.status(500).send("Error en el servidor");
}

    if (results.length === 0) {
      return res.status(401).send("Usuario no encontrado o inactivo");
    }

    const user = results[0];

    // Comparar contraseña en texto plano (temporal)
    // RECOMENDACIÓN: Usar bcrypt.compare() cuando tengas contraseñas encriptadas
    if (password === user.contrasena) {
      res.send(
        `Bienvenido ${user.nombre} ${user.apellido} (Rol ID: ${user.id_rol})`
      );
    } else {
      res.status(401).send("Contraseña incorrecta");
    }

});
});

module.exports = router;
