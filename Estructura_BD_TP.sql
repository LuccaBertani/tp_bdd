USE GD2C2025
GO

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

CREATE TABLE Localidad (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	id_provincia BIGINT,
	
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

	CONSTRAINT FK_Sede_Provincia
		FOREIGN KEY (id_provincia)
		REFERENCES Provincia (id),

	CONSTRAINT FK_Sede_Localidad
		FOREIGN KEY (id_localidad)
		REFERENCES Localidad (id),

	CONSTRAINT FK_Sede_Institucion
		FOREIGN KEY (id_institucion)
		REFERENCES Institucion (id)
);

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
	
	CONSTRAINT FK_Persona_Localidad
		FOREIGN KEY (id_localidad)
		REFERENCES Localidad (id)
);

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

	CONSTRAINT FK_Curso_Sede
		FOREIGN KEY (id_sede)
		REFERENCES Sede (id),

	CONSTRAINT FK_Curso_Profesor
		FOREIGN KEY (id_profesor)
		REFERENCES Persona (id),

	CONSTRAINT FK_Curso_Categoria
		FOREIGN KEY (id_categoria)
		REFERENCES Categoria (id),

	CONSTRAINT FK_Curso_Turno
		FOREIGN KEY (id_turno)
		REFERENCES Turno (id)
);

CREATE TABLE Examen (
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha DATE,
	nota DECIMAL(3, 1),
	id_tipo_examen BIGINT,
	
	CONSTRAINT PK_Examen PRIMARY KEY (id),
	
	CONSTRAINT FK_Examen_TipoExamen
		FOREIGN KEY (id_tipo_examen)
		REFERENCES Tipo_Examen (id)
);

CREATE TABLE Modalidad_Materia (
	id_modalidad BIGINT NOT NULL,
	id_materia BIGINT NOT NULL,
	
	CONSTRAINT PK_ModalidadMateria PRIMARY KEY (id_modalidad, id_materia),
	
	CONSTRAINT FK_MM_Modalidad
		FOREIGN KEY (id_modalidad)
		REFERENCES Modalidad (id),
		
	CONSTRAINT FK_MM_Materia
		FOREIGN KEY (id_materia)
		REFERENCES Materia (id)
);

CREATE TABLE Docente_Materia (
	id_docente BIGINT NOT NULL,
	id_materia BIGINT NOT NULL,
	
	CONSTRAINT PK_DocenteMateria PRIMARY KEY (id_docente, id_materia),
	
	CONSTRAINT FK_DM_Docente
		FOREIGN KEY (id_docente)
		REFERENCES Persona (id),
		
	CONSTRAINT FK_DM_Materia
		FOREIGN KEY (id_materia)
		REFERENCES Materia (id)
);

CREATE TABLE Inscripcion_Curso (
	id_persona BIGINT NOT NULL,
	id_curso BIGINT NOT NULL,
	fecha_inscripcion DATE,
	id_estado BIGINT,
	id_progreso BIGINT,
	
	CONSTRAINT PK_InscripcionCurso PRIMARY KEY (id_persona, id_curso),
	
	CONSTRAINT FK_IC_Persona
		FOREIGN KEY (id_persona)
		REFERENCES Persona (id),
		
	CONSTRAINT FK_IC_Curso
		FOREIGN KEY (id_curso)
		REFERENCES Curso (id),
		
	CONSTRAINT FK_IC_Estado
		FOREIGN KEY (id_estado)
		REFERENCES Estado (id),
		
	CONSTRAINT FK_IC_Progreso
		FOREIGN KEY (id_progreso)
		REFERENCES Progreso (id)
);

CREATE TABLE Factura (
	id BIGINT NOT NULL IDENTITY(1,1),
	nro_factura BIGINT,
	fecha_emision DATE,
	monto_total FLOAT,
	id_persona BIGINT,
	
	CONSTRAINT PK_Factura PRIMARY KEY (id),
	
	CONSTRAINT FK_Factura_Persona
		FOREIGN KEY (id_persona)
		REFERENCES Persona (id)
);

CREATE TABLE Detalle_Factura (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_factura BIGINT,
	concepto VARCHAR(255),
	monto FLOAT,
	
	CONSTRAINT PK_DetalleFactura PRIMARY KEY (id),
	
	CONSTRAINT FK_DetalleFactura_Factura
		FOREIGN KEY (id_factura)
		REFERENCES Factura (id)
);