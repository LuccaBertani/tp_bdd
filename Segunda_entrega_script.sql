--------------------------------------- Create database and tables --------------------------------------------------

-- switch to master to safely delete LOS_GDDES if exists

USE GD2C2025
GO

USE master
GO

-- delete LOS_GDDES if exists
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'LOS_GDDES')
BEGIN
    ALTER DATABASE LOS_GDDES SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LOS_GDDES;
END
GO

-- create and use LOS_GDDES
CREATE DATABASE LOS_GDDES
GO

USE LOS_GDDES
GO

PRINT 'Database LOS_GDDES created successfully'
GO

-----------------------------------------------------
-- TABLAS MAESTRAS (REFERENCE TABLES)
-----------------------------------------------------

CREATE TABLE Provincia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Provincia PRIMARY KEY (id)
);

CREATE TABLE Institucion (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	razon_social VARCHAR(255),
	cuit CHAR(13),
	CONSTRAINT PK_Institucion PRIMARY KEY (id)
);

CREATE TABLE Categoria (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Categoria PRIMARY KEY (id)
);

CREATE TABLE Estado (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Estado PRIMARY KEY (id)
);

CREATE TABLE Turno (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Turno PRIMARY KEY (id)
);

CREATE TABLE Mes(
	id BIGINT,
	CONSTRAINT PK_Mes PRIMARY KEY (id)
);

CREATE TABLE Dia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Dia PRIMARY KEY (id)
);

CREATE TABLE MetodoDePago(
	id BIGINT NOT NULL IDENTITY(1,1),
	descripcion VARCHAR(255),
	CONSTRAINT PK_MetodoDePago PRIMARY KEY (id)
);

CREATE TABLE Pregunta (
	id BIGINT NOT NULL IDENTITY(1,1),
	pregunta VARCHAR(1048),
	CONSTRAINT PK_Pregunta PRIMARY KEY (id)
);

-----------------------------------------------------
-- LOCALIDAD Y SEDE
-----------------------------------------------------

CREATE TABLE Localidad (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	id_provincia BIGINT NOT NULL,
	CONSTRAINT PK_Localidad PRIMARY KEY (id),
	CONSTRAINT FK_Localidad_Provincia FOREIGN KEY (id_provincia) REFERENCES Provincia (id)
);

CREATE TABLE Sede(
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	direccion VARCHAR(255),
	telefono VARCHAR(255),
	mail VARCHAR(255),
	id_localidad BIGINT,
	id_institucion BIGINT,
	CONSTRAINT PK_Sede PRIMARY KEY (id),
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
	fecha_nacimiento DATETIME,
	id_localidad BIGINT,
	domicilio VARCHAR(255),
	telefono VARCHAR(255),
	mail VARCHAR(255),
	CONSTRAINT PK_Persona PRIMARY KEY (id),
	CONSTRAINT FK_Persona_Localidad FOREIGN KEY (id_localidad) REFERENCES Localidad (id)
);

CREATE TABLE Alumno(
	legajo BIGINT NOT NULL,
	id_persona BIGINT,
	CONSTRAINT PK_Alumno PRIMARY KEY (legajo),
	CONSTRAINT FK_Alumno_Persona FOREIGN KEY (id_persona) REFERENCES Persona (id)
);

CREATE TABLE Profesor(
	id BIGINT NOT NULL IDENTITY(1,1),
	id_persona BIGINT
	CONSTRAINT PK_Profesor PRIMARY KEY (id),
	CONSTRAINT FK_Profesor_Persona FOREIGN KEY (id_persona) REFERENCES Persona (id)
)

-----------------------------------------------------
-- CURSOS Y MÓDULOS
-----------------------------------------------------

CREATE TABLE Curso(
	codigo_curso BIGINT NOT NULL,
	nombre VARCHAR(255),
	descripcion VARCHAR(1048),
	fecha_inicio DATETIME,
	fecha_fin DATETIME,
	duracion INT,
	precio_mensual DECIMAL(18,2),
	id_sede BIGINT,
	id_profesor BIGINT,
	id_categoria BIGINT,
	id_turno BIGINT,
	CONSTRAINT PK_Curso PRIMARY KEY (codigo_curso),
	CONSTRAINT FK_Curso_Sede FOREIGN KEY (id_sede) REFERENCES Sede (id),
	CONSTRAINT FK_Curso_Profesor FOREIGN KEY (id_profesor) REFERENCES Persona (id),
	CONSTRAINT FK_Curso_Categoria FOREIGN KEY (id_categoria) REFERENCES Categoria (id),
	CONSTRAINT FK_Curso_Turno FOREIGN KEY (id_turno) REFERENCES Turno (id)
);

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
	CONSTRAINT FK_ModuloCurso_Curso FOREIGN KEY (id_curso) REFERENCES Curso (codigo_curso),
	CONSTRAINT FK_ModuloCurso_Modulo FOREIGN KEY (id_modulo) REFERENCES Modulo (id)
);

CREATE TABLE Dia_Curso (
	id_curso BIGINT,
	id_dia BIGINT,
	CONSTRAINT PK_DiaCurso PRIMARY KEY (id_curso, id_dia),
	CONSTRAINT FK_DiaCurso_Curso FOREIGN KEY (id_curso) REFERENCES Curso (codigo_curso),
	CONSTRAINT FK_DiaCurso_Dia FOREIGN KEY (id_dia) REFERENCES Dia (id)
);

-----------------------------------------------------
-- INSCRIPCIONES
-----------------------------------------------------

CREATE TABLE Inscripcion_Curso (
	numero_inscripcion BIGINT NOT NULL,
	id_alumno BIGINT NOT NULL,
	id_curso BIGINT NOT NULL,
	fecha_inscripcion DATETIME,
	fecha_respuesta DATETIME,
	id_estado BIGINT,
	CONSTRAINT PK_InscripcionCurso PRIMARY KEY (numero_inscripcion),
	CONSTRAINT FK_IC_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo),
	CONSTRAINT FK_IC_Curso FOREIGN KEY (id_curso) REFERENCES Curso (codigo_curso),
	CONSTRAINT FK_IC_Estado FOREIGN KEY (id_estado) REFERENCES Estado (id)
);

-----------------------------------------------------
-- EVALUACIONES Y TPs
-----------------------------------------------------

CREATE TABLE Evaluacion (
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha DATETIME2(6),
	id_modulo_curso BIGINT,
	CONSTRAINT PK_Evaluacion PRIMARY KEY (id),
	CONSTRAINT FK_Evaluacion_ModuloCurso FOREIGN KEY (id_modulo_curso) REFERENCES Modulo_Curso (id)
);

CREATE TABLE Evaluacion_Alumno (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_alumno BIGINT,
	id_evaluacion BIGINT,
	nota DECIMAL(5,2),
	presente BIT,
	instancia INT,
	CONSTRAINT PK_EvaluacionAlumno PRIMARY KEY (id),
	CONSTRAINT FK_EA_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo),
	CONSTRAINT FK_EA_Evaluacion FOREIGN KEY (id_evaluacion) REFERENCES Evaluacion (id)
);

CREATE TABLE TP (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_alumno BIGINT,
	fecha_evaluacion DATETIME2(6),
	nota DECIMAL(5,2),
	CONSTRAINT PK_TP PRIMARY KEY (id),
	CONSTRAINT FK_TP_Curso FOREIGN KEY (id_curso) REFERENCES Curso (codigo_curso),
	CONSTRAINT FK_TP_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo)
);

-----------------------------------------------------
-- EXÁMENES Y FINALES
-----------------------------------------------------

CREATE TABLE Final(
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha DATETIME2(6),
	hora VARCHAR(50),
	descripcion VARCHAR(1048),
	id_curso BIGINT,
	CONSTRAINT PK_Final PRIMARY KEY (id),
	CONSTRAINT FK_Final_Curso FOREIGN KEY (id_curso) REFERENCES Curso (codigo_curso)
);

CREATE TABLE Inscripcion_final(
	numero_inscripcion BIGINT NOT NULL,
	fecha_inscripcion DATETIME2(6),
	id_alumno BIGINT,
	id_final BIGINT,
	CONSTRAINT PK_InscripcionFinal PRIMARY KEY (numero_inscripcion),
	CONSTRAINT FK_InscripcionFinal_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo),
	CONSTRAINT FK_InscripcionFinal_Final FOREIGN KEY (id_final) REFERENCES Final (id)
);

CREATE TABLE Evaluacion_Final (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_final BIGINT,
	id_profesor BIGINT,
	id_alumno BIGINT,
	presente BIT,
	nota BIGINT,
	CONSTRAINT PK_EvaluacionFinal PRIMARY KEY (id),
	CONSTRAINT FK_EF_Final FOREIGN KEY (id_final) REFERENCES Final (id),
	CONSTRAINT FK_EF_Profesor FOREIGN KEY (id_profesor) REFERENCES Persona (id),
	CONSTRAINT FK_EF_Alumno FOREIGN KEY (id_alumno) REFERENCES Alumno (legajo)
);

-----------------------------------------------------
-- ENCUESTAS
-----------------------------------------------------

CREATE TABLE Encuesta (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	fecha_registro DATETIME,
	observaciones VARCHAR(1048),
	CONSTRAINT PK_Encuesta PRIMARY KEY (id),
	CONSTRAINT FK_Encuesta_Curso FOREIGN KEY (id_curso) REFERENCES Curso (codigo_curso)
);

CREATE TABLE Detalle_x_Pregunta (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_encuesta BIGINT,
	id_pregunta BIGINT,
	respuesta BIGINT,
	CONSTRAINT PK_DetalleXPregunta PRIMARY KEY (id),
	CONSTRAINT FK_DxP_Encuesta FOREIGN KEY (id_encuesta) REFERENCES Encuesta (id),
	CONSTRAINT FK_DxP_Pregunta FOREIGN KEY (id_pregunta) REFERENCES Pregunta (id)
);

-----------------------------------------------------
-- FACTURACIÓN Y PAGOS
-----------------------------------------------------

CREATE TABLE Periodo(
	id BIGINT NOT NULL IDENTITY(1,1),
	anio BIGINT,
	id_mes BIGINT,
	CONSTRAINT PK_Periodo PRIMARY KEY (id),
	CONSTRAINT FK_Periodo_Mes FOREIGN KEY (id_mes) REFERENCES Mes (id)
);

CREATE TABLE Factura (
	numero_factura BIGINT,
	fecha_emision DATETIME2(6),
	fecha_vencimiento DATETIME2(6),
	monto_total DECIMAL(18,2),
	legajo_alumno BIGINT,
	CONSTRAINT PK_Factura PRIMARY KEY (numero_factura),
	CONSTRAINT FK_Factura_Legajo FOREIGN KEY (legajo_alumno) REFERENCES Alumno (legajo)
);

CREATE TABLE Detalle_Factura (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_factura BIGINT,
	id_periodo BIGINT,
	monto DECIMAL(18,2),
	CONSTRAINT PK_DetalleFactura PRIMARY KEY (id),
	CONSTRAINT FK_DetalleFactura_Curso FOREIGN KEY (id_curso) REFERENCES Curso (codigo_curso),
	CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY (id_factura) REFERENCES Factura (numero_factura),
	CONSTRAINT FK_DetalleFactura_Periodo FOREIGN KEY (id_periodo) REFERENCES Periodo (id)
);

CREATE TABLE Pago(
	id_pago BIGINT NOT NULL IDENTITY(1,1),
	nro_factura BIGINT,
	fecha_pago DATETIME2(6),
	importe DECIMAL(18,2),
	id_metodoDePago BIGINT,
	CONSTRAINT PK_Pago PRIMARY KEY (id_pago),
	CONSTRAINT FK_Pago_Factura FOREIGN KEY (nro_factura) REFERENCES Factura (numero_factura),
	CONSTRAINT FK_Pago_MetodoDePago FOREIGN KEY (id_metodoDePago) REFERENCES MetodoDePago (id)
);

GO


--------------------------------------------- STORE PROCEDURES -------------------------------------------------

PRINT 'Iniciando migracion...'
GO

-- PROVINCIA
CREATE OR ALTER PROCEDURE MIGRATE_PROVINCIA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Provincia (nombre)
    SELECT DISTINCT provincia FROM (
        SELECT Sede_Localidad AS provincia FROM GD2C2025.gd_esquema.Maestra WHERE Sede_Localidad IS NOT NULL
        UNION
        SELECT Profesor_Provincia FROM GD2C2025.gd_esquema.Maestra WHERE Profesor_Provincia IS NOT NULL
        UNION
        SELECT Alumno_Provincia FROM GD2C2025.gd_esquema.Maestra WHERE Alumno_Provincia IS NOT NULL
    ) p
    WHERE NOT EXISTS (SELECT 1 FROM Provincia pr WHERE pr.nombre = p.provincia);
    PRINT 'Provincia: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- LOCALIDAD
CREATE OR ALTER PROCEDURE MIGRATE_LOCALIDAD
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Localidad (nombre, id_provincia)
    SELECT DISTINCT m.localidad, p.id
    FROM (
        SELECT Sede_Provincia AS localidad, Sede_Localidad AS provincia FROM GD2C2025.gd_esquema.Maestra WHERE Sede_Localidad IS NOT NULL AND Sede_Provincia IS NOT NULL
        UNION
        SELECT Profesor_Localidad as localidad, Profesor_Provincia as provincia FROM GD2C2025.gd_esquema.Maestra WHERE Profesor_Localidad IS NOT NULL
        UNION
        SELECT Alumno_Localidad as localidad, Alumno_Provincia as provincia FROM GD2C2025.gd_esquema.Maestra WHERE Alumno_Localidad IS NOT NULL
    ) m
    INNER JOIN Provincia p ON p.nombre = m.provincia
    WHERE
        NOT EXISTS (SELECT 1 FROM Localidad l WHERE l.nombre = m.localidad AND l.id_provincia = p.id);
    PRINT 'Localidad: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- INSTITUCION
CREATE OR ALTER PROCEDURE MIGRATE_INSTITUCION
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Institucion (nombre, razon_social, cuit)
    SELECT DISTINCT Institucion_Nombre, Institucion_RazonSocial, Institucion_Cuit 
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Institucion_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Institucion i WHERE i.nombre = Institucion_Nombre);
    PRINT 'Institucion: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- CATEGORIA
CREATE OR ALTER PROCEDURE MIGRATE_CATEGORIA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Categoria (nombre)
    SELECT DISTINCT Curso_Categoria
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Curso_Categoria IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Categoria c WHERE c.nombre = Curso_Categoria);
    PRINT 'Categoria: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- TURNO
CREATE OR ALTER PROCEDURE MIGRATE_TURNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Turno (nombre)
    SELECT DISTINCT Curso_Turno
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Curso_Turno IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Turno t WHERE t.nombre = Curso_Turno);
    PRINT 'Turno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- ESTADO
CREATE OR ALTER PROCEDURE MIGRATE_ESTADO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Estado (nombre)
    SELECT DISTINCT Inscripcion_Estado
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Inscripcion_Estado IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Estado e WHERE e.nombre = Inscripcion_Estado);
    PRINT 'Estado: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- METODO DE PAGO
CREATE OR ALTER PROCEDURE MIGRATE_METODO_PAGO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO MetodoDePago (descripcion)
    SELECT DISTINCT Pago_MedioPago
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Pago_MedioPago IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM MetodoDePago mp WHERE mp.descripcion = Pago_MedioPago);
    PRINT 'MetodoDePago: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- MES
CREATE OR ALTER PROCEDURE MIGRATE_MES
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Mes (id)
    SELECT Distinct Periodo_Mes From GD2C2025.gd_esquema.Maestra
    Where Periodo_Mes IS NOT NULL
    PRINT 'Mes: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DIA
CREATE OR ALTER PROCEDURE MIGRATE_DIA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Dia (nombre)
    SELECT DISTINCT TRIM(Curso_Dia)
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Curso_Dia IS NOT NULL AND TRIM(Curso_Dia) <> ''
    AND NOT EXISTS (SELECT 1 FROM Dia d WHERE d.nombre = TRIM(Curso_Dia));
    PRINT 'Dia: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- MODULO
CREATE OR ALTER PROCEDURE MIGRATE_MODULO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Modulo (nombre, descripcion)
    SELECT DISTINCT Modulo_Nombre, Modulo_Descripcion
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Modulo_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Modulo mo WHERE mo.nombre = Modulo_Nombre);
    PRINT 'Modulo: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PREGUNTA
CREATE OR ALTER PROCEDURE MIGRATE_PREGUNTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Pregunta (pregunta)
    SELECT DISTINCT pregunta_text FROM (
        SELECT 
            Encuesta_Pregunta1 AS pregunta_text
        FROM GD2C2025.gd_esquema.Maestra 
        WHERE Encuesta_Pregunta1 IS NOT NULL
        UNION SELECT Encuesta_Pregunta2 FROM GD2C2025.gd_esquema.Maestra WHERE Encuesta_Pregunta2 IS NOT NULL
        UNION SELECT Encuesta_Pregunta3 FROM GD2C2025.gd_esquema.Maestra WHERE Encuesta_Pregunta3 IS NOT NULL
        UNION SELECT Encuesta_Pregunta4 FROM GD2C2025.gd_esquema.Maestra WHERE Encuesta_Pregunta4 IS NOT NULL
    ) AS Preguntas
    WHERE NOT EXISTS (SELECT 1 FROM Pregunta p WHERE p.pregunta = pregunta_text);
    PRINT 'Pregunta: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PERIODO
CREATE OR ALTER PROCEDURE MIGRATE_PERIODO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Periodo (anio, id_mes)
    SELECT DISTINCT m.Periodo_Anio, mes.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Mes mes ON mes.id = m.Periodo_Mes
    WHERE m.Periodo_Anio IS NOT NULL AND m.Periodo_Mes IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Periodo p WHERE p.anio = m.Periodo_Anio AND p.id_mes = mes.id);
    PRINT 'Periodo: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- SEDE
CREATE OR ALTER PROCEDURE MIGRATE_SEDE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Sede (nombre, direccion, telefono, mail, id_localidad, id_institucion)
    SELECT DISTINCT 
        m.Sede_Nombre, m.Sede_Direccion, m.Sede_Telefono, m.Sede_Mail,
        l.id, i.id
    FROM GD2C2025.gd_esquema.Maestra m
    LEFT JOIN Provincia p ON p.nombre = m.Sede_Localidad
    LEFT JOIN Localidad l ON l.nombre = m.Sede_Provincia AND l.id_provincia = p.id
    LEFT JOIN Institucion i ON i.nombre = m.Institucion_Nombre
    WHERE m.Sede_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Sede s WHERE s.nombre = m.Sede_Nombre AND s.id_institucion = i.id);
    PRINT 'Sede: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PERSONA PROFESOR
CREATE OR ALTER PROCEDURE MIGRATE_PERSONA_PROFESOR
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Persona (dni, nombre, apellido,  fecha_nacimiento, id_localidad, domicilio, telefono, mail)
    SELECT DISTINCT 
        TRY_CAST(m.Profesor_Dni AS BIGINT), m.Profesor_Apellido, m.Profesor_nombre,
        m.Profesor_FechaNacimiento, l.id, m.Profesor_Direccion, m.Profesor_Telefono, m.Profesor_Mail
    FROM GD2C2025.gd_esquema.Maestra m
    LEFT JOIN Provincia p ON p.nombre = m.Profesor_Provincia
    LEFT JOIN Localidad l ON l.nombre = m.Profesor_Localidad AND l.id_provincia = p.id
    WHERE m.Profesor_Dni IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Persona per WHERE per.dni = TRY_CAST(m.Profesor_Dni AS BIGINT));
    PRINT 'Persona Profesor: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PERSONA ALUMNO
CREATE OR ALTER PROCEDURE MIGRATE_PERSONA_ALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Persona (dni, nombre, apellido, fecha_nacimiento, id_localidad, domicilio, telefono, mail)
    SELECT DISTINCT 
        m.Alumno_Dni, m.Alumno_Nombre, m.Alumno_Apellido,
        m.Alumno_FechaNacimiento, l.id, m.Alumno_Direccion, m.Alumno_Telefono, m.Alumno_Mail
    FROM GD2C2025.gd_esquema.Maestra m
    LEFT JOIN Provincia p ON p.nombre = m.Alumno_Provincia
    LEFT JOIN Localidad l ON l.nombre = m.Alumno_Localidad AND l.id_provincia = p.id
    WHERE m.Alumno_Dni IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Persona per WHERE per.dni = m.Alumno_Dni);
    PRINT 'Persona Alumno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- ALUMNO
CREATE OR ALTER PROCEDURE MIGRATE_ALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Alumno (id_persona, legajo)
    SELECT DISTINCT p.id, m.Alumno_Legajo
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido))
    WHERE NOT EXISTS (SELECT 1 FROM Alumno a WHERE a.id_persona = p.id);
    PRINT 'Alumno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PROFESOR
CREATE OR ALTER PROCEDURE MIGRATE_PROFESOR
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Profesor (id_persona)
    SELECT DISTINCT p.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Profesor_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Profesor_Apellido),', ',Trim(m.Profesor_nombre))
    WHERE NOT EXISTS (SELECT 1 FROM Profesor prof WHERE prof.id_persona = p.id);
    PRINT 'Profesor: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- CURSO
CREATE OR ALTER PROCEDURE MIGRATE_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Curso (codigo_curso, nombre, descripcion, fecha_inicio, fecha_fin, duracion, precio_mensual, id_sede, id_profesor, id_categoria, id_turno)
    SELECT DISTINCT 
        m.Curso_Codigo, m.Curso_Nombre, m.Curso_Descripcion, m.Curso_FechaInicio, m.Curso_FechaFin,
        m.Curso_DuracionMeses, m.Curso_PrecioMensual, s.id, p.id, cat.id, t.id
    FROM GD2C2025.gd_esquema.Maestra m
    Inner JOIN Sede s ON s.nombre = m.Sede_Nombre
    Inner JOIN Persona p ON p.dni = TRY_CAST(m.Profesor_Dni AS BIGINT) AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Profesor_Apellido),', ',Trim(m.Profesor_nombre))
    Inner JOIN Categoria cat ON cat.nombre = m.Curso_Categoria
    Inner JOIN Turno t ON t.nombre = m.Curso_Turno
    WHERE m.Curso_Codigo IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Curso c WHERE c.codigo_curso = m.Curso_Codigo);
    PRINT 'Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- MODULO_CURSO
CREATE OR ALTER PROCEDURE MIGRATE_MODULO_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Modulo_Curso (id_curso, id_modulo)
    SELECT DISTINCT c.codigo_curso, mo.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Modulo mo ON mo.nombre = m.Modulo_Nombre
    WHERE m.Modulo_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Modulo_Curso mc WHERE mc.id_curso = c.codigo_curso AND mc.id_modulo = mo.id);
    PRINT 'Modulo_Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DIA_CURSO
CREATE OR ALTER PROCEDURE MIGRATE_DIA_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Dia_Curso (id_curso, id_dia)
    SELECT DISTINCT c.codigo_curso, d.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Dia d ON d.nombre = TRIM(m.Curso_Dia)
    WHERE m.Curso_Dia IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Dia_Curso dc WHERE dc.id_curso = c.codigo_curso AND dc.id_dia = d.id);
    PRINT 'Dia_Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- INSCRIPCION_CURSO
CREATE OR ALTER PROCEDURE MIGRATE_INSCRIPCION_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Inscripcion_Curso (numero_inscripcion, id_alumno, id_curso, fecha_inscripcion, fecha_respuesta, id_estado)
    SELECT DISTINCT m.Inscripcion_Numero, a.legajo, c.codigo_curso, m.Inscripcion_Fecha, m.Inscripcion_FechaRespuesta, e.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido))
    INNER JOIN Alumno a ON a.id_persona = p.id
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    LEFT JOIN Estado e ON e.nombre = m.Inscripcion_Estado
    WHERE m.Inscripcion_Numero IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Inscripcion_Curso ic WHERE ic.id_alumno = a.legajo AND ic.id_curso = c.codigo_curso);
    PRINT 'Inscripcion_Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- EVALUACION
CREATE OR ALTER PROCEDURE MIGRATE_EVALUACION
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Evaluacion (fecha, id_modulo_curso)
    SELECT DISTINCT m.Evaluacion_Curso_fechaEvaluacion, mc.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Modulo mo ON mo.nombre = m.Modulo_Nombre
    INNER JOIN Modulo_Curso mc ON mc.id_curso = c.codigo_curso AND mc.id_modulo = mo.id
    WHERE m.Evaluacion_Curso_fechaEvaluacion IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Evaluacion ev WHERE ev.fecha = m.Evaluacion_Curso_fechaEvaluacion AND ev.id_modulo_curso = mc.id);
    PRINT 'Evaluacion: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- EVALUACION_ALUMNO
CREATE OR ALTER PROCEDURE MIGRATE_EVALUACION_ALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Evaluacion_Alumno (id_alumno, id_evaluacion, nota, presente, instancia)
    SELECT DISTINCT a.legajo, ev.id, m.Evaluacion_Curso_Nota, m.Evaluacion_Curso_Presente, m.Evaluacion_Curso_Instancia
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido)) 
    INNER JOIN Alumno a ON a.id_persona = p.id
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Modulo mo ON mo.nombre = m.Modulo_Nombre
    INNER JOIN Modulo_Curso mc ON mc.id_curso = c.codigo_curso AND mc.id_modulo = mo.id
    INNER JOIN Evaluacion ev ON ev.fecha = m.Evaluacion_Curso_fechaEvaluacion AND ev.id_modulo_curso = mc.id
    WHERE m.Evaluacion_Curso_Nota IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Evaluacion_Alumno ea WHERE ea.id_alumno = a.legajo AND ea.id_evaluacion = ev.id);
    PRINT 'Evaluacion_Alumno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- TP
CREATE OR ALTER PROCEDURE MIGRATE_TP
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO TP (id_curso, id_alumno, fecha_evaluacion, nota)
    SELECT DISTINCT c.codigo_curso, a.legajo, m.Trabajo_Practico_FechaEvaluacion, m.Trabajo_Practico_Nota
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido)) 
    INNER JOIN Alumno a ON a.id_persona = p.id
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    WHERE m.Trabajo_Practico_Nota IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM TP tp WHERE tp.id_alumno = a.legajo AND tp.id_curso = c.codigo_curso AND tp.fecha_evaluacion = m.Trabajo_Practico_FechaEvaluacion);
    PRINT 'TP: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- FINAL
CREATE OR ALTER PROCEDURE MIGRATE_FINAL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Final (fecha, hora, descripcion, id_curso)
    SELECT DISTINCT m.Examen_Final_Fecha, m.Examen_Final_Hora, m.Examen_Final_Descripcion, c.codigo_curso
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    WHERE m.Examen_Final_Fecha IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Final f WHERE f.fecha = m.Examen_Final_Fecha AND f.id_curso = c.codigo_curso);
    PRINT 'Final: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- INSCRIPCION_FINAL
CREATE OR ALTER PROCEDURE MIGRATE_INSCRIPCION_FINAL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Inscripcion_final (numero_inscripcion, fecha_inscripcion, id_alumno, id_final)
    SELECT DISTINCT m.Inscripcion_Final_Nro, m.Inscripcion_Final_Fecha, a.legajo, f.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido)) 
    INNER JOIN Alumno a ON a.id_persona = p.id
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Final f ON f.fecha = m.Examen_Final_Fecha AND f.id_curso = c.codigo_curso
    WHERE m.Inscripcion_Final_Nro IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Inscripcion_final if_ WHERE if_.id_alumno = a.legajo AND if_.id_final = f.id);
    PRINT 'Inscripcion_final: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- EVALUACION_FINAL
CREATE OR ALTER PROCEDURE MIGRATE_EVALUACION_FINAL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Evaluacion_Final (id_final, id_profesor, id_alumno, presente, nota)
    SELECT DISTINCT f.id, prof.id, a.legajo, m.Evaluacion_Final_Presente, m.Evaluacion_Final_Nota
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido)) 
    INNER JOIN Alumno a ON a.id_persona = p.id
    INNER JOIN Persona prof ON prof.dni = TRY_CAST(m.Profesor_Dni AS BIGINT)
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Final f ON f.fecha = m.Examen_Final_Fecha AND f.id_curso = c.codigo_curso
    WHERE m.Evaluacion_Final_Nota IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Evaluacion_Final ef WHERE ef.id_final = f.id AND ef.id_alumno = a.legajo);
    PRINT 'Evaluacion_Final: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- ENCUESTA
CREATE OR ALTER PROCEDURE MIGRATE_ENCUESTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Encuesta (id_curso, fecha_registro, observaciones)
    SELECT DISTINCT c.codigo_curso, m.Encuesta_FechaRegistro, m.Encuesta_Observacion
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    WHERE m.Encuesta_FechaRegistro IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Encuesta en WHERE en.id_curso = c.codigo_curso AND en.fecha_registro = m.Encuesta_FechaRegistro);
    PRINT 'Encuesta: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DETALLE_X_PREGUNTA
CREATE OR ALTER PROCEDURE MIGRATE_DETALLE_PREGUNTA
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Pregunta 1
    INSERT INTO Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id, m.Encuesta_Nota1
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Encuesta en ON en.id_curso = c.codigo_curso AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta1
    WHERE m.Encuesta_Pregunta1 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    -- Pregunta 2
    INSERT INTO Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id, m.Encuesta_Nota2
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Encuesta en ON en.id_curso = c.codigo_curso AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta2
    WHERE m.Encuesta_Pregunta2 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    -- Pregunta 3
    INSERT INTO Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id,m.Encuesta_Nota3
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Encuesta en ON en.id_curso = c.codigo_curso AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta3
    WHERE m.Encuesta_Pregunta3 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    -- Pregunta 4
    INSERT INTO Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id,m.Encuesta_Nota4
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Encuesta en ON en.id_curso = c.codigo_curso AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta4
    WHERE m.Encuesta_Pregunta4 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    PRINT 'Detalle_x_Pregunta: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- FACTURA
CREATE OR ALTER PROCEDURE MIGRATE_FACTURA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Factura (numero_factura, fecha_emision, fecha_vencimiento, monto_total, legajo_alumno)
    SELECT DISTINCT m.Factura_Numero, m.Factura_FechaEmision, m.Factura_FechaVencimiento, m.Factura_Total, a.legajo
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido)) 
    INNER JOIN Alumno a on a.id_persona = p.id
    WHERE m.Factura_Numero IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Factura f WHERE f.fecha_emision = m.Factura_FechaEmision AND f.legajo_alumno = a.legajo);
    PRINT 'Factura: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DETALLE_FACTURA
CREATE OR ALTER PROCEDURE MIGRATE_DETALLE_FACTURA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Detalle_Factura (id_curso, id_factura, id_periodo, monto)
    SELECT DISTINCT c.codigo_curso, f.numero_factura, per.id, m.Detalle_Factura_Importe
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido)) 
    INNER JOIN Curso c ON c.codigo_curso = m.Curso_Codigo
    INNER JOIN Alumno a on a.id_persona = p.id
    INNER JOIN Factura f ON f.fecha_emision = m.Factura_FechaEmision AND f.legajo_alumno = a.legajo
    LEFT JOIN Mes mes ON mes.id = m.Periodo_Mes
    LEFT JOIN Periodo per ON per.anio = m.Periodo_Anio AND per.id_mes = mes.id
    WHERE m.Detalle_Factura_Importe IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Detalle_Factura df WHERE df.id_factura = f.numero_factura AND df.id_curso = c.codigo_curso AND df.id_periodo = per.id);
    PRINT 'Detalle_Factura: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PAGO
CREATE OR ALTER PROCEDURE MIGRATE_PAGO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Pago (nro_factura, fecha_pago, importe, id_metodoDePago)
    SELECT DISTINCT f.numero_factura, m.Pago_Fecha, m.Pago_Importe, mp.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN Persona p ON p.dni = m.Alumno_Dni AND concat(p.nombre,', ',p.apellido) = concat(Trim(m.Alumno_Nombre),', ',Trim(m.Alumno_Apellido)) 
    INNER JOIN Alumno a on p.id = a.id_persona
    INNER JOIN Factura f ON f.fecha_emision = m.Factura_FechaEmision AND f.legajo_alumno = a.legajo
    LEFT JOIN MetodoDePago mp ON mp.descripcion = m.Pago_MedioPago
    WHERE m.Pago_Fecha IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Pago pg WHERE pg.nro_factura = f.numero_factura AND pg.fecha_pago = m.Pago_Fecha);
    PRINT 'Pago: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

------------------------------------------ EXEC STORE PROCEDURES -------------------------------------------------------

SET NOCOUNT ON;
SET XACT_ABORT ON; -- Rollback on any error

DECLARE @rowcount INT;

PRINT 'Starting migration from Maestra table to'
PRINT 'LOS_GDDES database'

BEGIN TRY
    BEGIN TRANSACTION MigrationTransaction;
    
    
    PRINT 'Migrating Table: Provincia'
    EXEC MIGRATE_PROVINCIA;
    PRINT 'Migrating Table: Localidad'
    EXEC MIGRATE_LOCALIDAD;
    PRINT 'Migrating Table: Institucion'
    EXEC MIGRATE_INSTITUCION;
    PRINT 'Migrating Table: Categoria'
    EXEC MIGRATE_CATEGORIA;
    PRINT 'Migrating Table: Turno'
    EXEC MIGRATE_TURNO;
    PRINT 'Migrating Table: Estado'
    EXEC MIGRATE_ESTADO;
    PRINT 'Migrating Table: MetodoDePago'
    EXEC MIGRATE_METODO_PAGO;
    PRINT 'Migrating Table: Mes'
    EXEC MIGRATE_MES;
    PRINT 'Migrating Table: Periodo'
    EXEC MIGRATE_PERIODO;
    PRINT 'Migrating Table: Dia'
    EXEC MIGRATE_DIA;
    PRINT 'Migrating Table: Modulo'
    EXEC MIGRATE_MODULO;
    PRINT 'Migrating Table: Pregunta'
    EXEC MIGRATE_PREGUNTA;
    
    PRINT 'Migrating Table: Sede'
    EXEC MIGRATE_SEDE;
    PRINT 'Migrating Table: Persona (Profesor)'
    EXEC MIGRATE_PERSONA_PROFESOR;
    PRINT 'Migrating Table: Persona (Alumno)'
    EXEC MIGRATE_PERSONA_ALUMNO;
    PRINT 'Migrating Table: Alumno'
    EXEC MIGRATE_ALUMNO;
    PRINT 'Migrating Table: Profesor'
    EXEC MIGRATE_PROFESOR
    PRINT 'Migrating Table: Curso'
    EXEC MIGRATE_CURSO;
    PRINT 'Migrating Table: Modulo_Curso'
    EXEC MIGRATE_MODULO_CURSO;
    PRINT 'Migrating Table: Dia_Curso'
    EXEC MIGRATE_DIA_CURSO;
    
    PRINT 'Migrating Table: Inscripcion_Curso'
    EXEC MIGRATE_INSCRIPCION_CURSO;
    PRINT 'Migrating Table: Evaluacion'
    EXEC MIGRATE_EVALUACION;
    PRINT 'Migrating Table: Evaluacion_Alumno'
    EXEC MIGRATE_EVALUACION_ALUMNO;
    PRINT 'Migrating Table: TP'
    EXEC MIGRATE_TP;
    PRINT 'Migrating Table: Final'
    EXEC MIGRATE_FINAL;
    PRINT 'Migrating Table: Inscripcion_Final'
    EXEC MIGRATE_INSCRIPCION_FINAL;
    PRINT 'Migrating Table: Evaluacion_Final'
    EXEC MIGRATE_EVALUACION_FINAL;
    PRINT 'Migrating Table: Encuesta'
    EXEC MIGRATE_ENCUESTA;
    PRINT 'Migrating Table: Detalle_x_Pregunta'
    EXEC MIGRATE_DETALLE_PREGUNTA;
    PRINT 'Migrating Table: Factura'
    EXEC MIGRATE_FACTURA;
    PRINT 'Migrating Table: Detalle_Factura'
    EXEC MIGRATE_DETALLE_FACTURA;
    PRINT 'Migrating Table: Pago'
    EXEC MIGRATE_PAGO;
    
    COMMIT TRANSACTION MigrationTransaction;
    
    PRINT 'Migration completed successfully'
    PRINT ''
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION MigrationTransaction;
    
    PRINT ''
    PRINT 'ERROR: Migracion fallida'
    PRINT 'Rolled backing...'
END CATCH
GO