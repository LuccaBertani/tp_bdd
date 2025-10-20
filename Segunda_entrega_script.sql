--------------------------------------- Create schema and tables --------------------------------------------------

USE GD2C2025
GO

-- Drop schema if exists (clean slate)
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'LOS_GDDES')
BEGIN
    PRINT 'Dropping existing LOS_GDDES schema and all objects...'
    
    -- Drop all stored procedures in schema
    DECLARE @sql_proc NVARCHAR(MAX) = '';
    SELECT @sql_proc = @sql_proc + 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
    FROM sys.procedures
    WHERE SCHEMA_NAME(schema_id) = 'LOS_GDDES';
    IF @sql_proc != '' EXEC sp_executesql @sql_proc;
    
    -- Drop all foreign key constraints
    DECLARE @sql_fk NVARCHAR(MAX) = '';
    SELECT @sql_fk = @sql_fk + 'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(fk.schema_id)) + '.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id)) + 
                     ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';'
    FROM sys.foreign_keys fk
    WHERE SCHEMA_NAME(fk.schema_id) = 'LOS_GDDES';
    IF @sql_fk != '' EXEC sp_executesql @sql_fk;
    
    -- Drop all tables
    DECLARE @sql_tables NVARCHAR(MAX) = '';
    SELECT @sql_tables = @sql_tables + 'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
    FROM sys.tables
    WHERE SCHEMA_NAME(schema_id) = 'LOS_GDDES';
    IF @sql_tables != '' EXEC sp_executesql @sql_tables;
    
    -- Drop schema
    DROP SCHEMA LOS_GDDES;
    PRINT '✓ Existing schema and all objects dropped successfully'
END

-- Create fresh schema
GO
CREATE SCHEMA LOS_GDDES
GO

PRINT '✓ Schema LOS_GDDES created successfully (clean slate)'
GO

-----------------------------------------------------
-- TABLAS MAESTRAS (REFERENCE TABLES)
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Provincia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Provincia PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Institucion (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	razon_social VARCHAR(255),
	cuit BIGINT,
	CONSTRAINT PK_Institucion PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Categoria (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	descripcion VARCHAR(500),
	CONSTRAINT PK_Categoria PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Tipo_Examen (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_TipoExamen PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Progreso (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Progreso PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Estado (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Estado PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Modalidad (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Modalidad PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Materia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	anio BIGINT,
	CONSTRAINT PK_Materia PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Turno (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	hora_inicio TIME,
	hora_fin TIME,
	CONSTRAINT PK_Turno PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Mes(
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Mes PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Dia (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	CONSTRAINT PK_Dia PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.MetodoDePago(
	id BIGINT NOT NULL IDENTITY(1,1),
	descripcion VARCHAR(255),
	CONSTRAINT PK_MetodoDePago PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Pregunta (
	id BIGINT NOT NULL IDENTITY(1,1),
	pregunta VARCHAR(1048),
	CONSTRAINT PK_Pregunta PRIMARY KEY (id)
);

-----------------------------------------------------
-- LOCALIDAD Y SEDE
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Localidad (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	id_provincia BIGINT NOT NULL,
	CONSTRAINT PK_Localidad PRIMARY KEY (id),
	CONSTRAINT FK_Localidad_Provincia FOREIGN KEY (id_provincia) REFERENCES LOS_GDDES.Provincia (id)
);

CREATE TABLE LOS_GDDES.Sede(
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	direccion VARCHAR(255),
	telefono VARCHAR(255),
	mail VARCHAR(255),
	id_provincia BIGINT,
	id_localidad BIGINT,
	id_institucion BIGINT,
	CONSTRAINT PK_Sede PRIMARY KEY (id),
	CONSTRAINT FK_Sede_Provincia FOREIGN KEY (id_provincia) REFERENCES LOS_GDDES.Provincia (id),
	CONSTRAINT FK_Sede_Localidad FOREIGN KEY (id_localidad) REFERENCES LOS_GDDES.Localidad (id),
	CONSTRAINT FK_Sede_Institucion FOREIGN KEY (id_institucion) REFERENCES LOS_GDDES.Institucion (id)
);

-----------------------------------------------------
-- PERSONA Y DERIVADOS
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Persona (
	id BIGINT NOT NULL IDENTITY(1,1),
	dni BIGINT,
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	quien_es VARCHAR(255),
	fecha_nacimiento DATE,
	id_provincia BIGINT,
	id_localidad BIGINT,
	domicilio VARCHAR(255),
	telefono VARCHAR(255),
	mail VARCHAR(255),
	usuario VARCHAR(255),
	contraseña VARCHAR(255),
	CONSTRAINT PK_Persona PRIMARY KEY (id),
	CONSTRAINT FK_Persona_Provincia FOREIGN KEY (id_provincia) REFERENCES LOS_GDDES.Provincia (id),
	CONSTRAINT FK_Persona_Localidad FOREIGN KEY (id_localidad) REFERENCES LOS_GDDES.Localidad (id)
);

CREATE TABLE LOS_GDDES.Alumno(
	legajo BIGINT NOT NULL IDENTITY(1,1),
	id_persona BIGINT,
	CONSTRAINT PK_Alumno PRIMARY KEY (legajo),
	CONSTRAINT FK_Alumno_Persona FOREIGN KEY (id_persona) REFERENCES LOS_GDDES.Persona (id)
);

-----------------------------------------------------
-- CURSOS Y MÓDULOS
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Curso(
	id BIGINT NOT NULL IDENTITY(1,1),
	codigo BIGINT,
	nombre VARCHAR(255),
	descripcion VARCHAR(1048),
	fecha_inicio DATE,
	fecha_fin DATE,
	duracion INT,
	precio_mensual DECIMAL(18,2),
	id_sede BIGINT,
	id_profesor BIGINT,
	id_categoria BIGINT,
	id_turno BIGINT,
	CONSTRAINT PK_Curso PRIMARY KEY (id),
	CONSTRAINT FK_Curso_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.Sede (id),
	CONSTRAINT FK_Curso_Profesor FOREIGN KEY (id_profesor) REFERENCES LOS_GDDES.Persona (id),
	CONSTRAINT FK_Curso_Categoria FOREIGN KEY (id_categoria) REFERENCES LOS_GDDES.Categoria (id),
	CONSTRAINT FK_Curso_Turno FOREIGN KEY (id_turno) REFERENCES LOS_GDDES.Turno (id)
);

CREATE TABLE LOS_GDDES.Modulo (
	id BIGINT NOT NULL IDENTITY(1,1),
	nombre VARCHAR(255),
	descripcion VARCHAR(255),
	CONSTRAINT PK_Modulo PRIMARY KEY (id)
);

CREATE TABLE LOS_GDDES.Modulo_Curso (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_modulo BIGINT,
	CONSTRAINT PK_ModuloCurso PRIMARY KEY (id),
	CONSTRAINT FK_ModuloCurso_Curso FOREIGN KEY (id_curso) REFERENCES LOS_GDDES.Curso (id),
	CONSTRAINT FK_ModuloCurso_Modulo FOREIGN KEY (id_modulo) REFERENCES LOS_GDDES.Modulo (id)
);

CREATE TABLE LOS_GDDES.Dia_Curso (
	id_curso BIGINT,
	id_dia BIGINT,
	CONSTRAINT PK_DiaCurso PRIMARY KEY (id_curso, id_dia),
	CONSTRAINT FK_DiaCurso_Curso FOREIGN KEY (id_curso) REFERENCES LOS_GDDES.Curso (id),
	CONSTRAINT FK_DiaCurso_Dia FOREIGN KEY (id_dia) REFERENCES LOS_GDDES.Dia (id)
);

-----------------------------------------------------
-- INSCRIPCIONES
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Inscripcion_Curso (
	numero_inscripcion BIGINT NOT NULL IDENTITY(1,1),
	id_persona BIGINT NOT NULL,
	id_curso BIGINT NOT NULL,
	fecha_inscripcion DATE,
	fecha_respuesta DATE,
	id_estado BIGINT,
	id_progreso BIGINT,
	CONSTRAINT PK_InscripcionCurso PRIMARY KEY (numero_inscripcion),
	CONSTRAINT FK_IC_Persona FOREIGN KEY (id_persona) REFERENCES LOS_GDDES.Persona (id),
	CONSTRAINT FK_IC_Curso FOREIGN KEY (id_curso) REFERENCES LOS_GDDES.Curso (id),
	CONSTRAINT FK_IC_Estado FOREIGN KEY (id_estado) REFERENCES LOS_GDDES.Estado (id),
	CONSTRAINT FK_IC_Progreso FOREIGN KEY (id_progreso) REFERENCES LOS_GDDES.Progreso (id)
);

-----------------------------------------------------
-- EVALUACIONES Y TPs
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Evaluacion (
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha DATETIME,
	id_modulo_curso BIGINT,
	CONSTRAINT PK_Evaluacion PRIMARY KEY (id),
	CONSTRAINT FK_Evaluacion_ModuloCurso FOREIGN KEY (id_modulo_curso) REFERENCES LOS_GDDES.Modulo_Curso (id)
);

CREATE TABLE LOS_GDDES.Evaluacion_Alumno (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_alumno BIGINT,
	id_evaluacion BIGINT,
	nota DECIMAL(5,2),
	presente BIT,
	instancia VARCHAR(255),
	CONSTRAINT PK_EvaluacionAlumno PRIMARY KEY (id),
	CONSTRAINT FK_EA_Alumno FOREIGN KEY (id_alumno) REFERENCES LOS_GDDES.Alumno (legajo),
	CONSTRAINT FK_EA_Evaluacion FOREIGN KEY (id_evaluacion) REFERENCES LOS_GDDES.Evaluacion (id)
);

CREATE TABLE LOS_GDDES.TP (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_alumno BIGINT,
	fecha_evaluacion DATETIME,
	nota DECIMAL(5,2),
	CONSTRAINT PK_TP PRIMARY KEY (id),
	CONSTRAINT FK_TP_Curso FOREIGN KEY (id_curso) REFERENCES LOS_GDDES.Curso (id),
	CONSTRAINT FK_TP_Alumno FOREIGN KEY (id_alumno) REFERENCES LOS_GDDES.Alumno (legajo)
);

-----------------------------------------------------
-- EXÁMENES Y FINALES
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Final(
	id BIGINT NOT NULL IDENTITY(1,1),
	fecha DATETIME,
	hora VARCHAR(50),
	descripcion VARCHAR(1048),
	id_curso BIGINT,
	CONSTRAINT PK_Final PRIMARY KEY (id),
	CONSTRAINT FK_Final_Curso FOREIGN KEY (id_curso) REFERENCES LOS_GDDES.Curso (id)
);

CREATE TABLE LOS_GDDES.Inscripcion_final(
	numero_inscripcion BIGINT NOT NULL IDENTITY(1,1),
	fecha_inscripcion DATETIME,
	id_alumno BIGINT,
	id_final BIGINT,
	CONSTRAINT PK_InscripcionFinal PRIMARY KEY (numero_inscripcion),
	CONSTRAINT FK_InscripcionFinal_Alumno FOREIGN KEY (id_alumno) REFERENCES LOS_GDDES.Alumno (legajo),
	CONSTRAINT FK_InscripcionFinal_Final FOREIGN KEY (id_final) REFERENCES LOS_GDDES.Final (id)
);

CREATE TABLE LOS_GDDES.Evaluacion_Final (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_final BIGINT,
	id_profesor BIGINT,
	id_alumno BIGINT,
	presente BIT,
	nota DECIMAL(5,2),
	CONSTRAINT PK_EvaluacionFinal PRIMARY KEY (id),
	CONSTRAINT FK_EF_Final FOREIGN KEY (id_final) REFERENCES LOS_GDDES.Final (id),
	CONSTRAINT FK_EF_Profesor FOREIGN KEY (id_profesor) REFERENCES LOS_GDDES.Persona (id),
	CONSTRAINT FK_EF_Alumno FOREIGN KEY (id_alumno) REFERENCES LOS_GDDES.Alumno (legajo)
);

-----------------------------------------------------
-- ENCUESTAS
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Encuesta (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	fecha_registro DATETIME,
	observaciones VARCHAR(1048),
	CONSTRAINT PK_Encuesta PRIMARY KEY (id),
	CONSTRAINT FK_Encuesta_Curso FOREIGN KEY (id_curso) REFERENCES LOS_GDDES.Curso (id)
);

CREATE TABLE LOS_GDDES.Detalle_x_Pregunta (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_encuesta BIGINT,
	id_pregunta BIGINT,
	respuesta VARCHAR(1048),
	CONSTRAINT PK_DetalleXPregunta PRIMARY KEY (id),
	CONSTRAINT FK_DxP_Encuesta FOREIGN KEY (id_encuesta) REFERENCES LOS_GDDES.Encuesta (id),
	CONSTRAINT FK_DxP_Pregunta FOREIGN KEY (id_pregunta) REFERENCES LOS_GDDES.Pregunta (id)
);

-----------------------------------------------------
-- FACTURACIÓN Y PAGOS
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Periodo(
	id BIGINT NOT NULL IDENTITY(1,1),
	anio BIGINT,
	id_mes BIGINT,
	CONSTRAINT PK_Periodo PRIMARY KEY (id),
	CONSTRAINT FK_Periodo_Mes FOREIGN KEY (id_mes) REFERENCES LOS_GDDES.Mes (id)
);

CREATE TABLE LOS_GDDES.Factura (
	numero_factura BIGINT IDENTITY(1,1),
	fecha_emision DATE,
	fecha_vencimiento DATE,
	monto_total DECIMAL(18,2),
	id_persona BIGINT,
	CONSTRAINT PK_Factura PRIMARY KEY (numero_factura),
	CONSTRAINT FK_Factura_Persona FOREIGN KEY (id_persona) REFERENCES LOS_GDDES.Persona (id)
);

CREATE TABLE LOS_GDDES.Detalle_Factura (
	id BIGINT NOT NULL IDENTITY(1,1),
	id_curso BIGINT,
	id_factura BIGINT,
	id_periodo BIGINT,
	monto DECIMAL(18,2),
	CONSTRAINT PK_DetalleFactura PRIMARY KEY (id),
	CONSTRAINT FK_DetalleFactura_Curso FOREIGN KEY (id_curso) REFERENCES LOS_GDDES.Curso (id),
	CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY (id_factura) REFERENCES LOS_GDDES.Factura (numero_factura),
	CONSTRAINT FK_DetalleFactura_Periodo FOREIGN KEY (id_periodo) REFERENCES LOS_GDDES.Periodo (id)
);

CREATE TABLE LOS_GDDES.Pago(
	id_pago BIGINT NOT NULL IDENTITY(1,1),
	nro_factura BIGINT,
	fecha_pago DATETIME,
	importe DECIMAL(18,2),
	id_metodoDePago BIGINT,
	CONSTRAINT PK_Pago PRIMARY KEY (id_pago),
	CONSTRAINT FK_Pago_Factura FOREIGN KEY (nro_factura) REFERENCES LOS_GDDES.Factura (numero_factura),
	CONSTRAINT FK_Pago_MetodoDePago FOREIGN KEY (id_metodoDePago) REFERENCES LOS_GDDES.MetodoDePago (id)
);

-----------------------------------------------------
-- MODALIDADES Y DOCENTES (OPTIONAL - NOT IN MAESTRA)
-----------------------------------------------------

CREATE TABLE LOS_GDDES.Modalidad_Materia (
	id_modalidad BIGINT NOT NULL,
	id_materia BIGINT NOT NULL,
	CONSTRAINT PK_ModalidadMateria PRIMARY KEY (id_modalidad, id_materia),
	CONSTRAINT FK_MM_Modalidad FOREIGN KEY (id_modalidad) REFERENCES LOS_GDDES.Modalidad (id),
	CONSTRAINT FK_MM_Materia FOREIGN KEY (id_materia) REFERENCES LOS_GDDES.Materia (id)
);

CREATE TABLE LOS_GDDES.Docente_Materia (
	id_docente BIGINT NOT NULL,
	id_materia BIGINT NOT NULL,
	CONSTRAINT PK_DocenteMateria PRIMARY KEY (id_docente, id_materia),
	CONSTRAINT FK_DM_Docente FOREIGN KEY (id_docente) REFERENCES LOS_GDDES.Persona (id),
	CONSTRAINT FK_DM_Materia FOREIGN KEY (id_materia) REFERENCES LOS_GDDES.Materia (id)
);

GO

PRINT '============================================='
PRINT 'Schema and all 36 tables created successfully'
PRINT '============================================='

--------------------------------------------- CREATE STORE PROCEDURES -------------------------------------------------

PRINT '====================================='
PRINT 'Starting Table Migration'
PRINT '====================================='
GO

-- PROVINCIA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_PROVINCIA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Provincia (nombre)
    SELECT DISTINCT provincia FROM (
        SELECT Sede_Provincia AS provincia FROM GD2C2025.gd_esquema.Maestra WHERE Sede_Provincia IS NOT NULL
        UNION
        SELECT Profesor_Provincia FROM GD2C2025.gd_esquema.Maestra WHERE Profesor_Provincia IS NOT NULL
        UNION
        SELECT Alumno_Provincia FROM GD2C2025.gd_esquema.Maestra WHERE Alumno_Provincia IS NOT NULL
    ) p
    WHERE NOT EXISTS (SELECT 1 FROM LOS_GDDES.Provincia pr WHERE pr.nombre = p.provincia);
    PRINT 'Provincia: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- LOCALIDAD
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_LOCALIDAD
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Localidad (nombre, id_provincia)
    SELECT DISTINCT m.localidad, p.id
    FROM (
        SELECT Sede_Localidad AS localidad, Sede_Provincia AS provincia FROM GD2C2025.gd_esquema.Maestra WHERE Sede_Localidad IS NOT NULL
        UNION
        SELECT Profesor_Localidad, Profesor_Provincia FROM GD2C2025.gd_esquema.Maestra WHERE Profesor_Localidad IS NOT NULL
        UNION
        SELECT Alumno_Localidad, Alumno_Provincia FROM GD2C2025.gd_esquema.Maestra WHERE Alumno_Localidad IS NOT NULL
    ) m
    INNER JOIN LOS_GDDES.Provincia p ON p.nombre = m.provincia
    WHERE NOT EXISTS (SELECT 1 FROM LOS_GDDES.Localidad l WHERE l.nombre = m.localidad AND l.id_provincia = p.id);
    PRINT 'Localidad: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- INSTITUCION
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_INSTITUCION
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Institucion (nombre, razon_social, cuit)
    SELECT DISTINCT Institucion_Nombre, Institucion_RazonSocial, TRY_CAST(Institucion_Cuit AS BIGINT)
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Institucion_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Institucion i WHERE i.nombre = Institucion_Nombre);
    PRINT 'Institucion: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- CATEGORIA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_CATEGORIA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Categoria (nombre)
    SELECT DISTINCT Curso_Categoria
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Curso_Categoria IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Categoria c WHERE c.nombre = Curso_Categoria);
    PRINT 'Categoria: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- TURNO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_TURNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Turno (nombre)
    SELECT DISTINCT Curso_Turno
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Curso_Turno IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Turno t WHERE t.nombre = Curso_Turno);
    PRINT 'Turno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- ESTADO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_ESTADO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Estado (nombre)
    SELECT DISTINCT Inscripcion_Estado
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Inscripcion_Estado IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Estado e WHERE e.nombre = Inscripcion_Estado);
    PRINT 'Estado: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- METODO DE PAGO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_METODO_PAGO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.MetodoDePago (descripcion)
    SELECT DISTINCT Pago_MedioPago
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Pago_MedioPago IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.MetodoDePago mp WHERE mp.descripcion = Pago_MedioPago);
    PRINT 'MetodoDePago: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- MES
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_MES
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Mes (nombre)
    SELECT nombre FROM (VALUES
        ('Enero'),('Febrero'),('Marzo'),('Abril'),('Mayo'),('Junio'),
        ('Julio'),('Agosto'),('Septiembre'),('Octubre'),('Noviembre'),('Diciembre')
    ) AS Meses(nombre)
    WHERE NOT EXISTS (SELECT 1 FROM LOS_GDDES.Mes m WHERE m.nombre = Meses.nombre);
    PRINT 'Mes: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DIA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_DIA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Dia (nombre)
    SELECT DISTINCT TRIM(value)
    FROM GD2C2025.gd_esquema.Maestra
    CROSS APPLY STRING_SPLIT(Curso_Dia, ',')
    WHERE Curso_Dia IS NOT NULL AND TRIM(value) <> ''
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Dia d WHERE d.nombre = TRIM(value));
    PRINT 'Dia: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- MODULO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_MODULO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Modulo (nombre, descripcion)
    SELECT DISTINCT Modulo_Nombre, Modulo_Descripcion
    FROM GD2C2025.gd_esquema.Maestra
    WHERE Modulo_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Modulo mo WHERE mo.nombre = Modulo_Nombre);
    PRINT 'Modulo: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PREGUNTA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_PREGUNTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Pregunta (pregunta)
    SELECT DISTINCT pregunta_text FROM (
        SELECT Encuesta_Pregunta1 AS pregunta_text FROM GD2C2025.gd_esquema.Maestra WHERE Encuesta_Pregunta1 IS NOT NULL
        UNION SELECT Encuesta_Pregunta2 FROM GD2C2025.gd_esquema.Maestra WHERE Encuesta_Pregunta2 IS NOT NULL
        UNION SELECT Encuesta_Pregunta3 FROM GD2C2025.gd_esquema.Maestra WHERE Encuesta_Pregunta3 IS NOT NULL
        UNION SELECT Encuesta_Pregunta4 FROM GD2C2025.gd_esquema.Maestra WHERE Encuesta_Pregunta4 IS NOT NULL
    ) AS Preguntas
    WHERE NOT EXISTS (SELECT 1 FROM LOS_GDDES.Pregunta p WHERE p.pregunta = pregunta_text);
    PRINT 'Pregunta: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PERIODO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_PERIODO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Periodo (anio, id_mes)
    SELECT DISTINCT m.Periodo_Anio, mes.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Mes mes ON mes.id = m.Periodo_Mes
    WHERE m.Periodo_Anio IS NOT NULL AND m.Periodo_Mes IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Periodo p WHERE p.anio = m.Periodo_Anio AND p.id_mes = mes.id);
    PRINT 'Periodo: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- SEDE
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_SEDE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Sede (nombre, direccion, telefono, mail, id_provincia, id_localidad, id_institucion)
    SELECT DISTINCT 
        m.Sede_Nombre, m.Sede_Direccion, m.Sede_Telefono, m.Sede_Mail,
        p.id, l.id, i.id
    FROM GD2C2025.gd_esquema.Maestra m
    LEFT JOIN LOS_GDDES.Provincia p ON p.nombre = m.Sede_Provincia
    LEFT JOIN LOS_GDDES.Localidad l ON l.nombre = m.Sede_Localidad AND l.id_provincia = p.id
    LEFT JOIN LOS_GDDES.Institucion i ON i.nombre = m.Institucion_Nombre
    WHERE m.Sede_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Sede s WHERE s.nombre = m.Sede_Nombre AND s.id_institucion = i.id);
    PRINT 'Sede: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PERSONA PROFESOR
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_PERSONA_PROFESOR
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Persona (dni, nombre, apellido, quien_es, fecha_nacimiento, id_provincia, id_localidad, domicilio, telefono, mail)
    SELECT DISTINCT 
        TRY_CAST(m.Profesor_Dni AS BIGINT), m.Profesor_nombre, m.Profesor_Apellido, 'Profesor',
        m.Profesor_FechaNacimiento, p.id, l.id, m.Profesor_Direccion, m.Profesor_Telefono, m.Profesor_Mail
    FROM GD2C2025.gd_esquema.Maestra m
    LEFT JOIN LOS_GDDES.Provincia p ON p.nombre = m.Profesor_Provincia
    LEFT JOIN LOS_GDDES.Localidad l ON l.nombre = m.Profesor_Localidad AND l.id_provincia = p.id
    WHERE m.Profesor_Dni IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Persona per WHERE per.dni = TRY_CAST(m.Profesor_Dni AS BIGINT) AND per.quien_es = 'Profesor');
    PRINT 'Persona Profesor: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PERSONA ALUMNO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_PERSONA_ALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Persona (dni, nombre, apellido, quien_es, fecha_nacimiento, id_provincia, id_localidad, domicilio, telefono, mail)
    SELECT DISTINCT 
        m.Alumno_Dni, m.Alumno_Nombre, m.Alumno_Apellido, 'Alumno',
        m.Alumno_FechaNacimiento, p.id, l.id, m.Alumno_Direccion, m.Alumno_Telefono, m.Alumno_Mail
    FROM GD2C2025.gd_esquema.Maestra m
    LEFT JOIN LOS_GDDES.Provincia p ON p.nombre = m.Alumno_Provincia
    LEFT JOIN LOS_GDDES.Localidad l ON l.nombre = m.Alumno_Localidad AND l.id_provincia = p.id
    WHERE m.Alumno_Dni IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Persona per WHERE per.dni = m.Alumno_Dni AND per.quien_es = 'Alumno');
    PRINT 'Persona Alumno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- ALUMNO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_ALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Alumno (id_persona)
    SELECT DISTINCT p.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    WHERE NOT EXISTS (SELECT 1 FROM LOS_GDDES.Alumno a WHERE a.id_persona = p.id);
    PRINT 'Alumno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- CURSO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Curso (codigo, nombre, descripcion, fecha_inicio, fecha_fin, duracion, precio_mensual, id_sede, id_profesor, id_categoria, id_turno)
    SELECT DISTINCT 
        m.Curso_Codigo, m.Curso_Nombre, m.Curso_Descripcion, m.Curso_FechaInicio, m.Curso_FechaFin,
        m.Curso_DuracionMeses, m.Curso_PrecioMensual, s.id, prof.id, cat.id, t.id
    FROM GD2C2025.gd_esquema.Maestra m
    LEFT JOIN LOS_GDDES.Sede s ON s.nombre = m.Sede_Nombre
    LEFT JOIN LOS_GDDES.Persona prof ON prof.dni = TRY_CAST(m.Profesor_Dni AS BIGINT) AND prof.quien_es = 'Profesor'
    LEFT JOIN LOS_GDDES.Categoria cat ON cat.nombre = m.Curso_Categoria
    LEFT JOIN LOS_GDDES.Turno t ON t.nombre = m.Curso_Turno
    WHERE m.Curso_Codigo IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Curso c WHERE c.codigo = m.Curso_Codigo);
    PRINT 'Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- MODULO_CURSO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_MODULO_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Modulo_Curso (id_curso, id_modulo)
    SELECT DISTINCT c.id, mo.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Modulo mo ON mo.nombre = m.Modulo_Nombre
    WHERE m.Modulo_Nombre IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Modulo_Curso mc WHERE mc.id_curso = c.id AND mc.id_modulo = mo.id);
    PRINT 'Modulo_Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DIA_CURSO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_DIA_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Dia_Curso (id_curso, id_dia)
    SELECT DISTINCT c.id, d.id
    FROM GD2C2025.gd_esquema.Maestra m
    CROSS APPLY STRING_SPLIT(m.Curso_Dia, ',')
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Dia d ON d.nombre = TRIM(value)
    WHERE m.Curso_Dia IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Dia_Curso dc WHERE dc.id_curso = c.id AND dc.id_dia = d.id);
    PRINT 'Dia_Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- INSCRIPCION_CURSO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_INSCRIPCION_CURSO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Inscripcion_Curso (id_persona, id_curso, fecha_inscripcion, fecha_respuesta, id_estado)
    SELECT DISTINCT p.id, c.id, m.Inscripcion_Fecha, m.Inscripcion_FechaRespuesta, e.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    LEFT JOIN LOS_GDDES.Estado e ON e.nombre = m.Inscripcion_Estado
    WHERE m.Inscripcion_Numero IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Inscripcion_Curso ic WHERE ic.id_persona = p.id AND ic.id_curso = c.id);
    PRINT 'Inscripcion_Curso: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- EVALUACION
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_EVALUACION
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Evaluacion (fecha, id_modulo_curso)
    SELECT DISTINCT m.Evaluacion_Curso_fechaEvaluacion, mc.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Modulo mo ON mo.nombre = m.Modulo_Nombre
    INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id_curso = c.id AND mc.id_modulo = mo.id
    WHERE m.Evaluacion_Curso_fechaEvaluacion IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Evaluacion ev WHERE ev.fecha = m.Evaluacion_Curso_fechaEvaluacion AND ev.id_modulo_curso = mc.id);
    PRINT 'Evaluacion: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- EVALUACION_ALUMNO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_EVALUACION_ALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Evaluacion_Alumno (id_alumno, id_evaluacion, nota, presente, instancia)
    SELECT DISTINCT a.legajo, ev.id, m.Evaluacion_Curso_Nota, m.Evaluacion_Curso_Presente, CAST(m.Evaluacion_Curso_Instancia AS VARCHAR(255))
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    INNER JOIN LOS_GDDES.Alumno a ON a.id_persona = p.id
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Modulo mo ON mo.nombre = m.Modulo_Nombre
    INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id_curso = c.id AND mc.id_modulo = mo.id
    INNER JOIN LOS_GDDES.Evaluacion ev ON ev.fecha = m.Evaluacion_Curso_fechaEvaluacion AND ev.id_modulo_curso = mc.id
    WHERE m.Evaluacion_Curso_Nota IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Evaluacion_Alumno ea WHERE ea.id_alumno = a.legajo AND ea.id_evaluacion = ev.id);
    PRINT 'Evaluacion_Alumno: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- TP (TRABAJO PRACTICO)
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_TP
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.TP (id_curso, id_alumno, fecha_evaluacion, nota)
    SELECT DISTINCT c.id, a.legajo, m.Trabajo_Practico_FechaEvaluacion, m.Trabajo_Practico_Nota
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    INNER JOIN LOS_GDDES.Alumno a ON a.id_persona = p.id
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    WHERE m.Trabajo_Practico_Nota IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.TP tp WHERE tp.id_alumno = a.legajo AND tp.id_curso = c.id AND tp.fecha_evaluacion = m.Trabajo_Practico_FechaEvaluacion);
    PRINT 'TP: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- FINAL
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_FINAL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Final (fecha, hora, descripcion, id_curso)
    SELECT DISTINCT m.Examen_Final_Fecha, m.Examen_Final_Hora, m.Examen_Final_Descripcion, c.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    WHERE m.Examen_Final_Fecha IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Final f WHERE f.fecha = m.Examen_Final_Fecha AND f.id_curso = c.id);
    PRINT 'Final: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- INSCRIPCION_FINAL
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_INSCRIPCION_FINAL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Inscripcion_final (fecha_inscripcion, id_alumno, id_final)
    SELECT DISTINCT m.Inscripcion_Final_Fecha, a.legajo, f.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    INNER JOIN LOS_GDDES.Alumno a ON a.id_persona = p.id
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Final f ON f.fecha = m.Examen_Final_Fecha AND f.id_curso = c.id
    WHERE m.Inscripcion_Final_Nro IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Inscripcion_final if_ WHERE if_.id_alumno = a.legajo AND if_.id_final = f.id);
    PRINT 'Inscripcion_final: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- EVALUACION_FINAL
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_EVALUACION_FINAL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Evaluacion_Final (id_final, id_profesor, id_alumno, presente, nota)
    SELECT DISTINCT f.id, prof.id, a.legajo, m.Evaluacion_Final_Presente, m.Evaluacion_Final_Nota
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    INNER JOIN LOS_GDDES.Alumno a ON a.id_persona = p.id
    INNER JOIN LOS_GDDES.Persona prof ON prof.dni = TRY_CAST(m.Profesor_Dni AS BIGINT) AND prof.quien_es = 'Profesor'
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Final f ON f.fecha = m.Examen_Final_Fecha AND f.id_curso = c.id
    WHERE m.Evaluacion_Final_Nota IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Evaluacion_Final ef WHERE ef.id_final = f.id AND ef.id_alumno = a.legajo);
    PRINT 'Evaluacion_Final: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- ENCUESTA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_ENCUESTA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Encuesta (id_curso, fecha_registro, observaciones)
    SELECT DISTINCT c.id, m.Encuesta_FechaRegistro, m.Encuesta_Observacion
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    WHERE m.Encuesta_FechaRegistro IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Encuesta en WHERE en.id_curso = c.id AND en.fecha_registro = m.Encuesta_FechaRegistro);
    PRINT 'Encuesta: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DETALLE_X_PREGUNTA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_DETALLE_PREGUNTA
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Pregunta 1
    INSERT INTO LOS_GDDES.Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id, CAST(m.Encuesta_Nota1 AS VARCHAR(1048))
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Encuesta en ON en.id_curso = c.id AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN LOS_GDDES.Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta1
    WHERE m.Encuesta_Pregunta1 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    -- Pregunta 2
    INSERT INTO LOS_GDDES.Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id, CAST(m.Encuesta_Nota2 AS VARCHAR(1048))
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Encuesta en ON en.id_curso = c.id AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN LOS_GDDES.Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta2
    WHERE m.Encuesta_Pregunta2 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    -- Pregunta 3
    INSERT INTO LOS_GDDES.Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id, CAST(m.Encuesta_Nota3 AS VARCHAR(1048))
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Encuesta en ON en.id_curso = c.id AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN LOS_GDDES.Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta3
    WHERE m.Encuesta_Pregunta3 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    -- Pregunta 4
    INSERT INTO LOS_GDDES.Detalle_x_Pregunta (id_encuesta, id_pregunta, respuesta)
    SELECT DISTINCT en.id, pr.id, CAST(m.Encuesta_Nota4 AS VARCHAR(1048))
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Encuesta en ON en.id_curso = c.id AND en.fecha_registro = m.Encuesta_FechaRegistro
    INNER JOIN LOS_GDDES.Pregunta pr ON pr.pregunta = m.Encuesta_Pregunta4
    WHERE m.Encuesta_Pregunta4 IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Detalle_x_Pregunta dxp WHERE dxp.id_encuesta = en.id AND dxp.id_pregunta = pr.id);
    
    PRINT 'Detalle_x_Pregunta: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- FACTURA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_FACTURA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Factura (fecha_emision, fecha_vencimiento, monto_total, id_persona)
    SELECT DISTINCT m.Factura_FechaEmision, m.Factura_FechaVencimiento, m.Factura_Total, p.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    WHERE m.Factura_Numero IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Factura f WHERE f.fecha_emision = m.Factura_FechaEmision AND f.id_persona = p.id);
    PRINT 'Factura: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- DETALLE_FACTURA
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_DETALLE_FACTURA
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Detalle_Factura (id_curso, id_factura, id_periodo, monto)
    SELECT DISTINCT c.id, f.numero_factura, per.id, m.Detalle_Factura_Importe
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    INNER JOIN LOS_GDDES.Curso c ON c.codigo = m.Curso_Codigo
    INNER JOIN LOS_GDDES.Factura f ON f.fecha_emision = m.Factura_FechaEmision AND f.id_persona = p.id
    LEFT JOIN LOS_GDDES.Mes mes ON mes.id = m.Periodo_Mes
    LEFT JOIN LOS_GDDES.Periodo per ON per.anio = m.Periodo_Anio AND per.id_mes = mes.id
    WHERE m.Detalle_Factura_Importe IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Detalle_Factura df WHERE df.id_factura = f.numero_factura AND df.id_curso = c.id AND df.id_periodo = per.id);
    PRINT 'Detalle_Factura: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

-- PAGO
CREATE OR ALTER PROCEDURE LOS_GDDES.MIGRATE_PAGO
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.Pago (nro_factura, fecha_pago, importe, id_metodoDePago)
    SELECT DISTINCT f.numero_factura, m.Pago_Fecha, m.Pago_Importe, mp.id
    FROM GD2C2025.gd_esquema.Maestra m
    INNER JOIN LOS_GDDES.Persona p ON p.dni = m.Alumno_Dni AND p.quien_es = 'Alumno'
    INNER JOIN LOS_GDDES.Factura f ON f.fecha_emision = m.Factura_FechaEmision AND f.id_persona = p.id
    LEFT JOIN LOS_GDDES.MetodoDePago mp ON mp.descripcion = m.Pago_MedioPago
    WHERE m.Pago_Fecha IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM LOS_GDDES.Pago pg WHERE pg.nro_factura = f.numero_factura AND pg.fecha_pago = m.Pago_Fecha);
    PRINT 'Pago: ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' rows';
END
GO

------------------------------------------ EXEC STORE PROCEDURES -------------------------------------------------------

SET NOCOUNT ON;
SET XACT_ABORT ON; -- Rollback on any error

DECLARE @rowcount INT;

PRINT '============================================='
PRINT 'STARTING COMPLETE MIGRATION FROM MAESTRA'
PRINT 'Source: GD2C2025.gd_esquema.Maestra'
PRINT 'Target: LOS_GDDES schema'
PRINT 'Start Time: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '============================================='
PRINT ''

BEGIN TRY
    BEGIN TRANSACTION MigrationTransaction;
    
    -- =============================================
    -- PHASE 1: REFERENCE TABLES (NO DEPENDENCIES)
    -- =============================================
    PRINT 'Migrating Table: Provincia'
    EXEC LOS_GDDES.MIGRATE_PROVINCIA;
    PRINT 'Migrating Table: Localidad'
    EXEC LOS_GDDES.MIGRATE_LOCALIDAD;
    PRINT 'Migrating Table: Institucion'
    EXEC LOS_GDDES.MIGRATE_INSTITUCION;
    PRINT 'Migrating Table: Categoria'
    EXEC LOS_GDDES.MIGRATE_CATEGORIA;
    PRINT 'Migrating Table: Turno'
    EXEC LOS_GDDES.MIGRATE_TURNO;
    PRINT 'Migrating Table: Estado'
    EXEC LOS_GDDES.MIGRATE_ESTADO;
    PRINT 'Migrating Table: MetodoDePago'
    EXEC LOS_GDDES.MIGRATE_METODO_PAGO;
    PRINT 'Migrating Table: Mes'
    EXEC LOS_GDDES.MIGRATE_MES;
    PRINT 'Migrating Table: Periodo'
    EXEC LOS_GDDES.MIGRATE_PERIODO;
    PRINT 'Migrating Table: Dia'
    EXEC LOS_GDDES.MIGRATE_DIA;
    PRINT 'Migrating Table: Modulo'
    EXEC LOS_GDDES.MIGRATE_MODULO;
    PRINT 'Migrating Table: Pregunta'
    EXEC LOS_GDDES.MIGRATE_PREGUNTA;
    
    -- =============================================
    -- PHASE 2: ENTITY TABLES (DEPEND ON REFERENCE)
    -- =============================================
    PRINT 'Migrating Table: Sede'
    EXEC LOS_GDDES.MIGRATE_SEDE;
    PRINT 'Migrating Table: Persona (Profesor)'
    EXEC LOS_GDDES.MIGRATE_PERSONA_PROFESOR;
    PRINT 'Migrating Table: Persona (Alumno)'
    EXEC LOS_GDDES.MIGRATE_PERSONA_ALUMNO;
    PRINT 'Migrating Table: Alumno'
    EXEC LOS_GDDES.MIGRATE_ALUMNO;
    PRINT 'Migrating Table: Curso'
    EXEC LOS_GDDES.MIGRATE_CURSO;
    PRINT 'Migrating Table: Modulo_Curso'
    EXEC LOS_GDDES.MIGRATE_MODULO_CURSO;
    PRINT 'Migrating Table: Dia_Curso'
    EXEC LOS_GDDES.MIGRATE_DIA_CURSO;
    
    -- =============================================
    -- PHASE 3: RELATIONSHIP TABLES (DEPEND ON ENTITIES)
    -- =============================================
    PRINT 'Migrating Table: Inscripcion_Curso'
    EXEC LOS_GDDES.MIGRATE_INSCRIPCION_CURSO;
    PRINT 'Migrating Table: Evaluacion'
    EXEC LOS_GDDES.MIGRATE_EVALUACION;
    PRINT 'Migrating Table: Evaluacion_Alumno'
    EXEC LOS_GDDES.MIGRATE_EVALUACION_ALUMNO;
    PRINT 'Migrating Table: TP'
    EXEC LOS_GDDES.MIGRATE_TP;
    PRINT 'Migrating Table: Final'
    EXEC LOS_GDDES.MIGRATE_FINAL;
    PRINT 'Migrating Table: Inscripcion_Final'
    EXEC LOS_GDDES.MIGRATE_INSCRIPCION_FINAL;
    PRINT 'Migrating Table: Evaluacion_Final'
    EXEC LOS_GDDES.MIGRATE_EVALUACION_FINAL;
    PRINT 'Migrating Table: Encuesta'
    EXEC LOS_GDDES.MIGRATE_ENCUESTA;
    PRINT 'Migrating Table: Detalle_x_Pregunta'
    EXEC LOS_GDDES.MIGRATE_DETALLE_PREGUNTA;
    PRINT 'Migrating Table: Factura'
    EXEC LOS_GDDES.MIGRATE_FACTURA;
    PRINT 'Migrating Table: Detalle_Factura'
    EXEC LOS_GDDES.MIGRATE_DETALLE_FACTURA;
    PRINT 'Migrating Table: Pago'
    EXEC LOS_GDDES.MIGRATE_PAGO;
    
    -- =============================================
    -- COMMIT TRANSACTION
    -- =============================================
    COMMIT TRANSACTION MigrationTransaction;
    
    PRINT '============================================='
    PRINT 'MIGRATION COMPLETED SUCCESSFULLY!'
    PRINT 'End Time: ' + CONVERT(VARCHAR, GETDATE(), 120)
    PRINT '============================================='
    PRINT ''
    
    -- =============================================
    -- SUMMARY REPORT
    -- =============================================
    PRINT '============================================='
    PRINT 'MIGRATION SUMMARY REPORT'
    PRINT '============================================='
    PRINT ''
    PRINT 'Reference Tables:'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Provincia; PRINT '  - Provincia: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Localidad; PRINT '  - Localidad: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Institucion; PRINT '  - Institucion: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Categoria; PRINT '  - Categoria: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Turno; PRINT '  - Turno: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Estado; PRINT '  - Estado: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.MetodoDePago; PRINT '  - MetodoDePago: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Mes; PRINT '  - Mes: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Periodo; PRINT '  - Periodo: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Dia; PRINT '  - Dia: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Modulo; PRINT '  - Modulo: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Pregunta; PRINT '  - Pregunta: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    PRINT ''
    PRINT 'Entity Tables:'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Sede; PRINT '  - Sede: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Persona; PRINT '  - Persona: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Alumno; PRINT '  - Alumno: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Curso; PRINT '  - Curso: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Modulo_Curso; PRINT '  - Modulo_Curso: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Dia_Curso; PRINT '  - Dia_Curso: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    PRINT ''
    PRINT 'Relationship Tables:'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Inscripcion_Curso; PRINT '  - Inscripcion_Curso: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Evaluacion; PRINT '  - Evaluacion: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Evaluacion_Alumno; PRINT '  - Evaluacion_Alumno: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.TP; PRINT '  - TP: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Final; PRINT '  - Final: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Inscripcion_final; PRINT '  - Inscripcion_final: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Evaluacion_Final; PRINT '  - Evaluacion_Final: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Encuesta; PRINT '  - Encuesta: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Detalle_x_Pregunta; PRINT '  - Detalle_x_Pregunta: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Factura; PRINT '  - Factura: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Detalle_Factura; PRINT '  - Detalle_Factura: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    SELECT @rowcount = COUNT(*) FROM LOS_GDDES.Pago; PRINT '  - Pago: ' + CAST(@rowcount AS VARCHAR(10)) + ' rows'
    PRINT ''
    PRINT '============================================='
    PRINT 'Total tables migrated: 30 tables'
    PRINT '============================================='
    
END TRY
BEGIN CATCH
    -- =============================================
    -- ERROR HANDLING
    -- =============================================
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION MigrationTransaction;
    
    PRINT ''
    PRINT '============================================='
    PRINT 'ERROR OCCURRED DURING MIGRATION!'
    PRINT '============================================='
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10))
    PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10))
    PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10))
    PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
    PRINT 'Error Message: ' + ERROR_MESSAGE()
    PRINT ''
    PRINT 'TRANSACTION ROLLED BACK - No data was migrated'
    PRINT '============================================='
END CATCH
GO