// Referencias a elementos
const contenido = document.getElementById("contenido-principal");
const menuLinks = document.querySelectorAll("nav ul li a:not(.cerrar-sesion)");
const cerrarSesion = document.getElementById("cerrar-sesion");

// Contenido para cada sección
// Colocados los href de cada sección!!!!!
// en el objeto secciones para que al hacer click vaya correctamente al html file
const secciones = {
  inicio: () => location.href = "/frontend/HTML/inicio.html",
  turnos: () => location.href = "/frontend/HTML/turnos.html",
  pacientes: () => location.href = "/frontend/HTML/pacientes.html",
  informes: () => location.href = "/frontend/HTML/informes.html",
  configuracion: () => location.href = "/frontend/HTML/configuracion.html",
};

// Función para cambiar contenido y activar el link
function cambiarContenido(seccion) {
  contenido.innerHTML = secciones[seccion]();
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
  //alert("Sesión cerrada. Volviendo a la página de login.");
  // Redirigir a login (si tienes página de login)
  window.location.href = "/frontend/HTML/login.html";
});
