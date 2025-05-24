DROP DATABASE IF EXISTS clinica;

CREATE DATABASE clinica;
USE clinica;

-- Tabla entidad
CREATE TABLE entidad (
    id_entidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);
INSERT INTO entidad (nombre, descripcion) VALUES
('Persona', 'Estados aplicables a registros de la tabla Persona'),
('Paciente', 'Estados aplicables a registros de la tabla Paciente'),
('Profesional', 'Estados aplicables a registros de la tabla Profesional'),
('Horario Disponible', 'Estados aplicables a los horarios disponibles'),
('Turno', 'Estados aplicables a la tabla Turno'),
('Usuario', 'Estados aplicables a los usuarios del sistema'),
('Especialidad', 'Estados aplicables a las especialidades médicas'),
('Monto', 'Estados aplicables a pagos y facturaciones'),
('Consulta Web', 'Estados aplicables a consultas web'),
('Asistencia Turno', 'Estados aplicables al registro de asistencia');

-- Tabla estado
CREATE TABLE estado (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    id_entidad INT NOT NULL,
    FOREIGN KEY (id_entidad) REFERENCES entidad(id_entidad)
);
INSERT INTO estado (nombre, descripcion, id_entidad) VALUES
('Activo', 'Estado activo de la entidad', 1), -- Persona
('Inactivo', 'Entidad actualmente deshabilitada', 1),
('Activo', 'Paciente habilitado para sacar turnos', 2),
('Inactivo', 'Paciente con su acceso deshabilitado', 2),
('Disponible', 'Profesional activo con agenda abierta', 3),
('No Disponible', 'Profesional sin agenda activa', 3),
('Disponible', 'Horario disponible para asignar turnos', 4),
('No Disponible', 'Horario bloqueado o fuera de servicio', 4),
('Programado', 'Turno asignado y pendiente de atención', 5),
('Cancelado', 'Turno que fue cancelado por el paciente o profesional', 5),
('Reprogramado', 'Turno que fue re-agendado para otra fecha', 5),
('Confirmado', 'Turno confirmado por el paciente', 5),
('Pendiente', 'Usuario pendiente de validación', 6),
('Activo', 'Usuario con acceso completo al sistema', 6),
('Inactivo', 'Usuario sin acceso al sistema', 6),
('Disponible', 'Especialidad que se encuentra habilitada', 7),
('Suspendida', 'Especialidad que no se ofrece temporalmente', 7),
('Registrado', 'Monto registrado correctamente en el sistema', 8),
('Anulado', 'Monto cancelado o revertido por error', 8),
('Abierto', 'Consulta web pendiente de ser respondida', 9),
('Cerrado', 'Consulta web ya fue respondida y cerrada', 9),
('Asistió', 'Paciente se presentó al turno', 10),
('No Asistió', 'Paciente no se presentó al turno', 10);

-- Tabla rol
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(200),
    CONSTRAINT chk_rol_nombre CHECK (nombre IN ('administrador', 'secretaria', 'especialista', 'paciente'))
);
INSERT INTO rol (nombre, descripcion) VALUES
('administrador', 'Acceso completo al sistema'),
('secretaria', 'Gestión de turnos y pacientes'),
('especialista', 'Consulta y atención de turnos'),
('paciente', 'Acceso a turnos desde la web');

-- Tabla especialidad
CREATE TABLE especialidad (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    id_estado INT,
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO especialidad (nombre, descripcion, id_estado) VALUES
('Clínica General', 'Atención médica general para adultos.', 1),
('Pediatría', 'Atención médica para niños y adolescentes.', 1),
('Cardiología', 'Diagnóstico y tratamiento de enfermedades del corazón.', 1),
('Ginecología', 'Atención de salud femenina y control ginecológico.', 1);

-- Tabla persona
CREATE TABLE persona (
    id_persona INT AUTO_INCREMENT PRIMARY KEY, 
    dni VARCHAR(20) NOT NULL UNIQUE, 
    nombre VARCHAR(50) NOT NULL, 
    apellido VARCHAR(50) NOT NULL, 
    fecha_nacimiento DATE,
    email VARCHAR(100) NOT NULL UNIQUE, 
    telefono VARCHAR(20), 
    direccion VARCHAR(255), 
    id_rol INT,
    id_especialidad INT,    
    id_estado INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,    
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol),    
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);

INSERT INTO persona (dni, nombre, apellido, fecha_nacimiento, email, telefono, direccion, id_rol, id_especialidad, id_estado)
VALUES
('30123456', 'Lucía', 'Gómez', '1990-04-15', 'lucia.gomez@mail.com', '3624123456', 'Av. 9 de Julio 123', 4, NULL, 1),
('28999111', 'Carlos', 'Pérez', '1985-11-30', 'carlos.perez@mail.com', '3624001122', 'Calle Falsa 456', 4, NULL, 1),
('31455678', 'Valeria', 'López', '1988-06-20', 'valeria.lopez@mail.com', '3624113344', 'Mitre 789', 2, NULL, 1),
('27654321', 'Miguel', 'Fernández', '1979-08-10', 'miguel.fernandez@mail.com', '3624332211', 'Belgrano 150', 3, 1, 1),
('30887766', 'Paula', 'Martínez', '1981-01-25', 'paula.martinez@mail.com', '3624556677', 'Urquiza 1020', 3, 2, 1),
('29550123', 'Diego', 'Ramírez', '1975-03-05', 'diego.ramirez@mail.com', '3624998877', 'España 99', 3, 4, 1);
-- Tabla paciente
CREATE TABLE paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL UNIQUE,
    obra_social VARCHAR(100),
    id_estado INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO paciente (id_persona, obra_social, id_estado)
VALUES
(1, 'Osde', 1),
(2, 'Swiss Medical', 1);

-- Tabla profesional
CREATE TABLE profesional (
    id_profesional INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL UNIQUE,
    matricula_profesional VARCHAR(50),
    id_estado INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO profesional (id_persona, matricula_profesional, id_estado)
VALUES
(3, 'M12345', 1),
(4, 'M67890', 1);

-- Tabla usuario
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(100) NOT NULL,
    id_persona INT,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO usuario (nombre_usuario, contrasena, id_persona, id_estado)
VALUES
('admin', 'admin123', 1, 1), 
('secretaria1', 'secretaria123', 2, 1),
('especialista1', 'especialista123', 3, 1),
('paciente1', 'paciente123', 5, 1);

-- Tabla horario_disponible
CREATE TABLE horario_disponible (    
    id_horario INT AUTO_INCREMENT PRIMARY KEY,    
    id_profesional INT,    
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') NOT NULL,    
    hora_inicio TIME NOT NULL,   
    hora_fin TIME NOT NULL,    
    id_estado INT NOT NULL,
    FOREIGN KEY (id_profesional) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO horario_disponible (id_profesional, dia_semana, hora_inicio, hora_fin, id_estado)
VALUES
(3, 'Lunes', '09:00:00', '12:00:00', 1), 
(3, 'Martes', '09:00:00', '12:00:00', 1),
(3, 'Miercoles', '09:00:00', '12:00:00', 1),
(3, 'Jueves', '14:00:00', '18:00:00', 1),
(3, 'Viernes', '09:00:00', '12:00:00', 1),
(4, 'Lunes', '09:00:00', '12:00:00', 1);

-- Tabla turno
CREATE TABLE turno (    
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    comprobante VARCHAR(50) NOT NULL,
    id_paciente INT,
    id_profesional INT,
    fecha_hora DATETIME NOT NULL,
    duracion INT NOT NULL,
    id_estado INT NOT NULL,
    observaciones TEXT DEFAULT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES persona(id_persona),
    FOREIGN KEY (id_profesional) REFERENCES persona(id_persona),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO turno (comprobante, id_paciente, id_profesional, fecha_hora, duracion, id_estado, observaciones)
VALUES
('ST-20250506-000001', 1, 3, '2025-05-10 09:00:00', 30, 1, 'Consulta general de salud'), 
('ST-20250506-000002', 2, 3, '2025-05-11 10:00:00', 30, 1, 'Chequeo pediátrico'), 
('ST-20250506-000003', 3, 4, '2025-05-12 14:00:00', 45, 2, 'Consulta cardiológica'), 
('ST-20250506-000004', 4, 3, '2025-05-13 11:00:00', 30, 1, 'Consulta general'), 
('ST-20250506-000005', 5, 4, '2025-05-14 16:00:00', 45, 3, 'Consulta ginecológica'), 
('ST-20250506-000006', 6, 3, '2025-05-15 10:00:00', 30, 2, 'Chequeo general');

-- Tabla historial_estado_turno
CREATE TABLE historial_estado_turno (    
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_anterior INT NOT NULL,
    estado_nuevo INT NOT NULL,
    observacion TEXT DEFAULT NULL,
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno),
    FOREIGN KEY (estado_anterior) REFERENCES estado(id_estado),
    FOREIGN KEY (estado_nuevo) REFERENCES estado(id_estado)
);

-- Tabla monto
CREATE TABLE monto (
    id_monto INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT,
    fecha_pago DATE,
    monto DECIMAL(10,2) NOT NULL,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO monto (id_turno, fecha_pago, monto, id_estado)
VALUES
(1, '2025-05-10', 500.00, 1), 
(2, '2025-05-11', 400.00, 1), 
(3, '2025-05-12', 700.00, 2), 
(4, '2025-05-13', 500.00, 1), 
(5, '2025-05-14', 600.00, 3), 
(6, '2025-05-15', 500.00, 1);

-- Tabla consulta_web
CREATE TABLE consulta_web (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO consulta_web (nombre, correo, mensaje, id_estado)
VALUES
('Juan Pérez', 'juan.perez@gmail.com', 'Quisiera saber los horarios de atención del médico general.', 1), 
('Ana García', 'ana.garcia@gmail.com', '¿Cómo puedo agendar un turno para pediatría?', 2), 
('Luis Martínez', 'luis.martinez@gmail.com', 'Tengo dudas sobre los servicios de cardiología.', 3), 
('Marta López', 'marta.lopez@gmail.com', '¿Cuáles son los requisitos para un turno con ginecología?', 1), 
('Carlos Rodríguez', 'carlos.rodriguez@gmail.com', 'Necesito cancelar un turno con el doctor.', 2), 
('Elena Sánchez', 'elena.sanchez@gmail.com', '¿Hay disponibilidad para turno en la próxima semana?', 3);

-- Tabla asistencia_turno
CREATE TABLE asistencia_turno (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT NOT NULL,
    asistio INT NOT NULL, -- 1: asistió, 0: no asistió
    observaciones TEXT,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno),
    FOREIGN KEY (id_estado) REFERENCES estado(id_estado)
);
INSERT INTO asistencia_turno (id_turno, asistio, observaciones, id_estado)
VALUES
(1, 1, 'El paciente asistió a su turno a la hora acordada.', 1), 
(2, 0, 'El paciente no se presentó al turno programado.', 2), 
(3, 1, 'El paciente llegó 10 minutos antes de la hora programada y fue atendido sin inconvenientes.', 1), 
(4, 0, 'El paciente canceló el turno con 24 horas de anticipación.', 2), 
(5, 1, 'El paciente asistió puntualmente y completó la consulta médica.', 3), 
(6, 0, 'El paciente no se presentó sin previo aviso y no contactó a la clínica.', 2);

-- CREACIÓN DE ROLES
CREATE ROLE 'rol_secretaria';
CREATE ROLE 'rol_especialista';
CREATE ROLE 'rol_administrador';
CREATE ROLE 'rol_paciente';

-- ASIGNACIÓN DE PRIVILEGIOS A CADA ROL

-- Secretaria: puede ver, insertar, modificar y eliminar datos generales
GRANT SELECT, INSERT, UPDATE, DELETE
ON clinica.* 
TO 'rol_secretaria';

-- Especialista: solo puede consultar turnos y horarios asignados
GRANT SELECT 
ON clinica.turno TO 'rol_especialista';
GRANT SELECT 
ON clinica.horario_disponible TO 'rol_especialista';

-- Administrador: acceso completo
GRANT ALL PRIVILEGES 
ON clinica.* 
TO 'rol_administrador';

-- Paciente: puede ver e insertar consultas web (como desde una web pública) y ver sus turnos
GRANT SELECT, INSERT 
ON clinica.consulta_web TO 'rol_paciente';
GRANT SELECT 
ON clinica.turno TO 'rol_paciente';

-- CREACIÓN DE USUARIOS

CREATE USER 'secretaria'@'localhost' IDENTIFIED BY 'clave_segura_secretaria';
CREATE USER 'especialista'@'localhost' IDENTIFIED BY 'clave_segura_especialista';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'clave_segura_admin';
CREATE USER 'paciente_web'@'localhost' IDENTIFIED BY 'clave_segura_paciente';

-- ASIGNACIÓN DE ROLES A USUARIOS

GRANT 'rol_secretaria' TO 'secretaria'@'localhost';
SET DEFAULT ROLE 'rol_secretaria' TO 'secretaria'@'localhost';

GRANT 'rol_especialista' TO 'especialista'@'localhost';
SET DEFAULT ROLE 'rol_especialista' TO 'especialista'@'localhost';

GRANT 'rol_administrador' TO 'admin'@'localhost';
SET DEFAULT ROLE 'rol_administrador' TO 'admin'@'localhost';

GRANT 'rol_paciente' TO 'paciente_web'@'localhost';
SET DEFAULT ROLE 'rol_paciente' TO 'paciente_web'@'localhost';


/* 
DROP ROLE IF EXISTS 'rol_secretaria'@'%';
DROP ROLE IF EXISTS 'rol_especialista'@'%';
DROP ROLE IF EXISTS 'rol_administrador'@'%';
DROP ROLE IF EXISTS 'rol_paciente'@'%';
DROP USER IF EXISTS 'secretaria'@'localhost';
DROP USER IF EXISTS 'especialista'@'localhost';
DROP USER IF EXISTS 'admin'@'localhost';
DROP USER IF EXISTS 'paciente_web'@'localhost';

*/