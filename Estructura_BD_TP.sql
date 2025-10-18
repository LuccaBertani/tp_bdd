USE GD2C2025
GO

-----------------------------------------------------
-- TABLAS MAESTRAS
-----------------------------------------------------

CREATE TABLE Provincia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),

	CONSTRAINT PK_Provincia PRIMARY KEY (id)
);

CREATE TABLE Institucion (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	cuit BIGINT,

	CONSTRAINT PK_Institucion PRIMARY KEY (id)
);

CREATE TABLE Categoria (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	descripcion VARCHAR(500),

	CONSTRAINT PK_Categoria PRIMARY KEY (id)
);

CREATE TABLE Tipo_Examen (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),

	CONSTRAINT PK_TipoExamen PRIMARY KEY (id)
);

CREATE TABLE Progreso (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),

	CONSTRAINT PK_Progreso PRIMARY KEY (id)
);

CREATE TABLE Estado (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),

	CONSTRAINT PK_Estado PRIMARY KEY (id)
);

CREATE TABLE Modalidad (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),

	CONSTRAINT PK_Modalidad PRIMARY KEY (id)
);

CREATE TABLE Materia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	anio BIGINT,

	CONSTRAINT PK_Materia PRIMARY KEY (id)
);

CREATE TABLE Turno (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	hora_inicio TIME,
	hora_fin TIME,

	CONSTRAINT PK_Turno PRIMARY KEY (id)
);

-----------------------------------------------------
-- LOCALIDAD Y SEDE
-----------------------------------------------------

CREATE TABLE Localidad (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	id_provincia BIGINT NOT NULL,

	CONSTRAINT PK_Localidad PRIMARY KEY (id),

	CONSTRAINT FK_Localidad_Provincia
		FOREIGN KEY (id_provincia)
		REFERENCES Provincia (id)
);

CREATE TABLE Sede(
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	direccion VARCHAR(255),
	telefono BIGINT,
	mail VARCHAR(255),
	id_provincia BIGINT,
	id_localidad BIGINT,
	id_institucion BIGINT,

	CONSTRAINT PK_Sede PRIMARY KEY (id),

	CONSTRAINT FK_Sede_Provincia FOREIGN KEY (id_provincia) REFERENCES Provincia (id),
	CONSTRAINT FK_Sede_Localidad FOREIGN KEY (id_localidad) REFERENCES Localidad (id),
	CONSTRAINT FK_Sede_Institucion FOREIGN KEY (id_institucion) REFERENCES Institucion (id)
);

-----------------------------------------------------
-- PERSONA Y DERIVADOS
-----------------------------------------------------

CREATE TABLE Persona (
	id BIGINT NOT NULL IDENTITY(1,1),
	dni BIGINT,
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	quien_es VARCHAR(255),
	fecha_nacimiento DATE,
	id_localidad BIGINT,
	domicilio VARCHAR(255),
	telefono BIGINT,
	mail VARCHAR(255),
	usuario VARCHAR(255),
	contraseña VARCHAR(255),

	CONSTRAINT PK_Persona PRIMARY KEY (id),

	CONSTRAINT FK_Persona_Localidad FOREIGN KEY (id_localidad) REFERENCES Localidad (id)
);

CREATE TABLE Alumno(
	legajo BIGINT NOT NULL IDENTITY(1,1),
	id_persona BIGINT,

	CONSTRAINT PK_Alumno PRIMARY KEY (legajo),

	CONSTRAINT FK_Alumno_Persona FOREIGN KEY (id_persona) REFERENCES Persona (id)
);

-----------------------------------------------------
-- CURSOS
-----------------------------------------------------

CREATE TABLE Curso(
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	descripcion VARCHAR(1048),
	fecha_inicio DATE,
	fecha_fin DATE,
	duracion INT,
	precio_mensual FLOAT,
	id_sede BIGINT,
	id_profesor BIGINT,
	id_categoria BIGINT,
	id_turno BIGINT,

	CONSTRAINT PK_Curso PRIMARY KEY (id),

	CONSTRAINT FK_Curso_Sede FOREIGN KEY (id_sede) REFERENCES Sede (id),
	CONSTRAINT FK_Curso_Profesor FOREIGN KEY (id_profesor) REFERENCES Persona (id),
	CONSTRAINT FK_Curso_Categoria FOREIGN KEY (id_categoria) REFERENCES Categoria (id),
	CONSTRAINT FK_Curso_Turno FOREIGN KEY (id_turno) REFERENCES Turno (id)
);

-----------------------------------------------------
-- INSCRIPCIONES
-----------------------------------------------------

CREATE TABLE Inscripcion_Curso (
	id_persona BIGINT NOT NULL,
	id_curso BIGINT NOT NULL,
	fecha_inscripcion DATE,
	id_estado BIGINT,
	id_progreso BIGINT,

	CONSTRAINT PK_InscripcionCurso PRIMARY KEY (id_persona, id_curso),

	CONSTRAINT FK_IC_Persona FOREIGN KEY (id_persona) REFERENCES Persona (id),
	CONSTRAINT FK_IC_Curso FOREIGN KEY (id_curso) REFERENCES Curso (id),
	CONSTRAINT FK_IC_Estado FOREIGN KEY (id_estado) REFERENCES Estado (id),
	CONSTRAINT FK_IC_Progreso FOREIGN KEY (id_progreso) REFERENCES Progreso (id)
);

-----------------------------------------------------
-- FACTURACIÓN Y PAGOS
-----------------------------------------------------

CREATE TABLE Factura (
	id BIGINT IDENTITY(1,1),
	fecha_emision DATE,
	monto_total FLOAT,
	id_persona BIGINT,

	CONSTRAINT PK_Factura PRIMARY KEY (id),

	CONSTRAINT FK_Factura_Persona FOREIGN KEY (id_persona) REFERENCES Persona (id)
);

CREATE TABLE MetodoDePago(
	id BIGINT NOT NULL IDENTITY(1,1),
	descripcion VARCHAR(255),

	CONSTRAINT PK_MetodoDePago PRIMARY KEY (id)
);

CREATE TABLE Pago(
	id_pago BIGINT NOT NULL IDENTITY(1,1),
	nro_factura BIGINT,
	fecha_pago DATETIME,
	importe FLOAT,
	id_metodoDePago BIGINT,

	CONSTRAINT PK_Pago PRIMARY KEY (id_pago),

	CONSTRAINT FK_Pago_Factura FOREIGN KEY (nro_factura) REFERENCES Factura (id),
	CONSTRAINT FK_Pago_MetodoDePago FOREIGN KEY (id_metodoDePago) REFERENCES MetodoDePago (id)
);

CREATE TABLE Mes(
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),

	CONSTRAINT PK_Mes PRIMARY KEY (id)
);

CREATE TABLE Periodo(
	id BIGINT NOT NULL IDENTITY(1,1),
	anio BIGINT,
	id_mes BIGINT,

	CONSTRAINT PK_Periodo PRIMARY KEY (id),

	CONSTRAINT FK_Periodo_Mes FOREIGN KEY (id_mes) REFERENCES Mes (id)
);

CREATE TABLE Detalle_Factura (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_factura BIGINT,
	id_periodo BIGINT,
	monto FLOAT,

	CONSTRAINT PK_DetalleFactura PRIMARY KEY (id),

	CONSTRAINT FK_DetalleFactura_Curso FOREIGN KEY (id_curso) REFERENCES Curso (id),
	CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY (id_factura) REFERENCES Factura (id),
	CONSTRAINT FK_DetalleFactura_Periodo FOREIGN KEY (id_periodo) REFERENCES Periodo (id)
);

-----------------------------------------------------
-- EXÁMENES Y FINALES
-----------------------------------------------------

CREATE TABLE Final(
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha DATETIME,
	hora TIME,
	id_curso BIGINT,

	CONSTRAINT PK_Final PRIMARY KEY (id),

	CONSTRAINT FK_Final_Curso FOREIGN KEY (id_curso) REFERENCES Curso (id)
);

CREATE TABLE Inscripcion_final(
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha_inscripcion DATETIME,
	id_alumno BIGINT,
	id_final BIGINT,

	CONSTRAINT PK_InscripcionFinal PRIMARY KEY (id),

	CONSTRAINT FK_InscripcionFinal_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo),
	CONSTRAINT FK_InscripcionFinal_Final FOREIGN KEY (id_final) REFERENCES Final (id)
);

CREATE TABLE Evaluacion_Final (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_final BIGINT,
	id_profesor BIGINT,
	id_alumno BIGINT,
	presente BIT,
	nota FLOAT,

	CONSTRAINT PK_EvaluacionFinal PRIMARY KEY (id),

	CONSTRAINT FK_EF_Final FOREIGN KEY (id_final) REFERENCES Final (id),
	CONSTRAINT FK_EF_Profesor FOREIGN KEY (id_profesor) REFERENCES Persona (id),
	CONSTRAINT FK_EF_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo)
);

-----------------------------------------------------
-- MODALIDADES, DOCENTES Y MATERIAS
-----------------------------------------------------

CREATE TABLE Modalidad_Materia (
	id_modalidad BIGINT NOT NULL,
	id_materia BIGINT NOT NULL,

	CONSTRAINT PK_ModalidadMateria PRIMARY KEY (id_modalidad, id_materia),

	CONSTRAINT FK_MM_Modalidad FOREIGN KEY (id_modalidad) REFERENCES Modalidad (id),
	CONSTRAINT FK_MM_Materia FOREIGN KEY (id_materia) REFERENCES Materia (id)
);

CREATE TABLE Docente_Materia (
	id_docente BIGINT NOT NULL,
	id_materia BIGINT NOT NULL,

	CONSTRAINT PK_DocenteMateria PRIMARY KEY (id_docente, id_materia),

	CONSTRAINT FK_DM_Docente FOREIGN KEY (id_docente) REFERENCES Persona (id),
	CONSTRAINT FK_DM_Materia FOREIGN KEY (id_materia) REFERENCES Materia (id)
);

-----------------------------------------------------
-- MÓDULOS Y DÍAS DE CURSO
-----------------------------------------------------

CREATE TABLE Modulo (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	descripcion VARCHAR(255),

	CONSTRAINT PK_Modulo PRIMARY KEY (id)
);

CREATE TABLE Modulo_Curso (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_modulo BIGINT,

	CONSTRAINT PK_ModuloCurso PRIMARY KEY (id),

	CONSTRAINT FK_ModuloCurso_Curso FOREIGN KEY (id_curso) REFERENCES Curso (id),
	CONSTRAINT FK_ModuloCurso_Modulo FOREIGN KEY (id_modulo) REFERENCES Modulo (id)
);

CREATE TABLE Dia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),

	CONSTRAINT PK_Dia PRIMARY KEY (id)
);

CREATE TABLE Dia_Curso (
	id_curso BIGINT,
	id_dia BIGINT,

	CONSTRAINT PK_DiaCurso PRIMARY KEY (id_curso, id_dia),

	CONSTRAINT FK_DiaCurso_Curso FOREIGN KEY (id_curso) REFERENCES Curso (id),
	CONSTRAINT FK_DiaCurso_Dia FOREIGN KEY (id_dia) REFERENCES Dia (id)
);

-----------------------------------------------------
-- EVALUACIONES, TP Y ENCUESTAS
-----------------------------------------------------

CREATE TABLE Evaluacion (
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha DATETIME,
	id_modulo_curso BIGINT,

	CONSTRAINT PK_Evaluacion PRIMARY KEY (id),

	CONSTRAINT FK_Evaluacion_ModuloCurso FOREIGN KEY (id_modulo_curso) REFERENCES Modulo_Curso (id)
);

CREATE TABLE Evaluacion_Alumno (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_alumno BIGINT,
	id_evaluacion BIGINT,
	nota FLOAT,
	presente BIT,
	instancia VARCHAR(255),

	CONSTRAINT PK_EvaluacionAlumno PRIMARY KEY (id),

	CONSTRAINT FK_EA_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo),
	CONSTRAINT FK_EA_Evaluacion FOREIGN KEY (id_evaluacion) REFERENCES Evaluacion (id)
);

CREATE TABLE TP (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_alumno BIGINT,
	fecha_evaluacion DATETIME,
	nota FLOAT,

	CONSTRAINT PK_TP PRIMARY KEY (id),

	CONSTRAINT FK_TP_Curso FOREIGN KEY (id_curso) REFERENCES Curso (id),
	CONSTRAINT FK_TP_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo)
);

CREATE TABLE Pregunta (
	id BIGINT NOT NULL IDENTITY(1,1),
	pregunta VARCHAR(1048),

	CONSTRAINT PK_Pregunta PRIMARY KEY (id)
);

CREATE TABLE Encuesta (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	fecha_registro DATETIME,
	observaciones VARCHAR(1048),

	CONSTRAINT PK_Encuesta PRIMARY KEY (id),

	CONSTRAINT FK_Encuesta_Curso FOREIGN KEY (id_curso) REFERENCES Curso (id)
);

CREATE TABLE Detalle_x_Pregunta (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_encuesta BIGINT,
	id_pregunta BIGINT,
	respuesta VARCHAR(1048),

	CONSTRAINT PK_DetalleXPregunta PRIMARY KEY (id),

	CONSTRAINT FK_DxP_Encuesta FOREIGN KEY (id_encuesta) REFERENCES Encuesta (id),
	CONSTRAINT FK_DxP_Pregunta FOREIGN KEY (id_pregunta) REFERENCES Pregunta (id)
);

