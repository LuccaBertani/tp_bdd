USE GD2C2025
GO

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

CONSTRAINT PK_Id PRIMARY KEY (id),

CONSTRAINT FK_Curso_Sede
	FOREIGN KEY (id_sede)
	REFERENCES Sede (id),

CONSTRAINT FK_Curso_Profesor
	FOREIGN KEY (id_profesor)
	REFERENCES Profesor (id),

CONSTRAINT FK_Curso_Categoria
	FOREIGN KEY (id_categoria)
	REFERENCES Categoria (id),

CONSTRAINT FK_Curso_Turno
	FOREIGN KEY (id_turno)
	REFERENCES Turno (id)

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

	CONSTRAINT PK_Id PRIMARY KEY (id),

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