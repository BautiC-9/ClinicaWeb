// Referencias a elementos
const contenido = document.getElementById("contenido-principal");
const menuLinks = document.querySelectorAll("nav ul li a:not(.cerrar-sesion)");
const cerrarSesion = document.getElementById("cerrar-sesion");

// Contenido para cada sección
const secciones = {
  inicio: `
    <h1>Bienvenido</h1>
    <p>Contenido según el rol del usuario...</p>
  `,
  turnos: `
    <h1>Turnos</h1>
    <p>Aquí puedes gestionar los turnos.</p>
  `,
  pacientes: `
    <h1>Pacientes</h1>
    <p>Listado y gestión de pacientes.</p>
  `,
  informes: `
    <h1>Informes</h1>
    <p>Visualización de informes médicos.</p>
  `,
  configuracion: `
    <h1>Configuración</h1>
    <p>Opciones para configurar el sistema.</p>
  `,
};

// Función para cambiar contenido y activar el link
function cambiarContenido(seccion) {
  contenido.innerHTML = secciones[seccion];
  menuLinks.forEach((link) => link.classList.remove("active"));
  document.getElementById("menu-" + seccion).classList.add("active");
}

// Eventos para cambiar secciones
menuLinks.forEach((link) => {
  link.addEventListener("click", (e) => {
    e.preventDefault();
    const id = e.target.id.replace("menu-", "");
    cambiarContenido(id);
  });
});

// Evento para cerrar sesión
cerrarSesion.addEventListener("click", (e) => {
  e.preventDefault();
  // Aquí puedes poner la lógica real para cerrar sesión, por ejemplo:
  alert("Sesión cerrada. Volviendo a la página de login.");
  // Redirigir a login (si tienes página de login)
  window.location.href = "login.html";
});
