USE GD2C2025
GO

IF OBJECT_ID('LOS_GDDES.BI_HechosFacturacion', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosFacturacion;

IF OBJECT_ID('LOS_GDDES.BI_HechosPagos', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosPagos;

IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesFinal', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosInscripcionesFinal;

IF OBJECT_ID('LOS_GDDES.BI_HechosCursadas', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosCursadas;

IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesCurso', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosInscripcionesCurso;

IF OBJECT_ID('LOS_GDDES.BI_BloqueSatisfaccion', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_BloqueSatisfaccion;

IF OBJECT_ID('LOS_GDDES.BI_MetodoDePago', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_MetodoDePago;

IF OBJECT_ID('LOS_GDDES.BI_CategoriaCurso', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_CategoriaCurso;

IF OBJECT_ID('LOS_GDDES.BI_TurnoCurso', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_TurnoCurso;

IF OBJECT_ID('LOS_GDDES.BI_RangoEtarioProfesor', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_RangoEtarioProfesor;

IF OBJECT_ID('LOS_GDDES.BI_RangoEtarioAlumno', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_RangoEtarioAlumno;

IF OBJECT_ID('LOS_GDDES.BI_Sede', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_Sede;

IF OBJECT_ID('LOS_GDDES.BI_Tiempo', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_Tiempo;
GO

CREATE TABLE LOS_GDDES.BI_Tiempo(
id BIGINT IDENTITY(1,1),
anio INTEGER,
mes INTEGER,
cuatrimestre VARCHAR(255),
semestre VARCHAR(255),

CONSTRAINT PK_BI_Tiempo PRIMARY KEY (id),
)

CREATE TABLE LOS_GDDES.BI_Sede(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_Sede PRIMARY KEY (id)
)

CREATE TABLE LOS_GDDES.BI_RangoEtarioAlumno (
id BIGINT IDENTITY(1,1),
detalle VARCHAR(20),

CONSTRAINT PK_BI_RangoEtarioAlumno PRIMARY KEY (id)
)

CREATE TABLE LOS_GDDES.BI_RangoEtarioProfesor (
id BIGINT IDENTITY(1,1),
detalle VARCHAR(20),

CONSTRAINT PK_BI_RangoEtarioProfesor PRIMARY KEY (id)
)

CREATE TABLE LOS_GDDES.BI_TurnoCurso(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_TurnoCurso PRIMARY KEY (id)
)

CREATE TABLE LOS_GDDES.BI_CategoriaCurso(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_CategoriaCurso PRIMARY KEY (id)
)

CREATE TABLE LOS_GDDES.BI_MetodoDePago(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_MetodoDePago PRIMARY KEY (id)
)

CREATE TABLE LOS_GDDES.BI_BloqueSatisfaccion(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

    CONSTRAINT PK_BI_BloqueSatisfaccion PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_HechosInscripcionesCurso (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_categoriaCurso BIGINT,
    id_turnoCurso BIGINT,
    id_sede BIGINT,
    inscriptos BIGINT,
    rechazados BIGINT,

    CONSTRAINT PK_BI_HechosInscripciones PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosInscripciones_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosInscripciones_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_CategoriaCurso(id),
    CONSTRAINT FK_BI_HechosInscripciones_Turno FOREIGN KEY (id_turnoCurso) REFERENCES LOS_GDDES.BI_TurnoCurso(id),
    CONSTRAINT FK_BI_HechosInscripciones_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_Sede(id),
)

CREATE TABLE LOS_GDDES.BI_HechosCursadas (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    id_categoriaCurso BIGINT,
    id_turnoCurso BIGINT,
    id_rangoAlumno BIGINT,
    id_rangoProfesor BIGINT,
    id_satisfaccion BIGINT,
    fecha_inicio smalldatetime,
    fecha_finalizacion smalldatetime,
    aprobado BIT,               
    nota_final DECIMAL(5,2),   

    CONSTRAINT PK_BI_HechosCursadas PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosCursadas_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosCursadas_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_Sede(id),
    CONSTRAINT FK_BI_HechosCursadas_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_CategoriaCurso(id),
    CONSTRAINT FK_BI_HechosCursadas_Turno FOREIGN KEY (id_turnoCurso) REFERENCES LOS_GDDES.BI_TurnoCurso(id),
    CONSTRAINT FK_BI_HechosCursadas_RangoEtarioAlumno FOREIGN KEY (id_rangoAlumno) REFERENCES LOS_GDDES.BI_RangoEtarioAlumno(id),
    CONSTRAINT FK_BI_HechosCursadas_RangoEtarioProfesor FOREIGN KEY (id_rangoProfesor) REFERENCES LOS_GDDES.BI_RangoEtarioProfesor(id),
    CONSTRAINT FK_BI_HechosCursadas_BloqueSatisfaccion FOREIGN KEY (id_satisfaccion) REFERENCES LOS_GDDES.BI_BloqueSatisfaccion (id)
)

CREATE TABLE LOS_GDDES.BI_HechosInscripcionesFinal (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,               
    inscriptos INT,
    ausentes INT,

    CONSTRAINT PK_BI_HechosInscripcionesFinal PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosInscripcionesFinal_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosInscripcionesFinal_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_Sede(id),
)

CREATE TABLE LOS_GDDES.BI_HechosPagos (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    id_categoriaCurso BIGINT,
    id_metodoPago BIGINT,
    fecha_pago smalldatetime,
    fecha_vencimiento smalldatetime,
    monto_pago DECIMAL(12,2),
    pago_fuera_termino BIT,

    CONSTRAINT PK_BI_HechosPagos PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosPagos_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosPagos_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_Sede(id),
    CONSTRAINT FK_BI_HechosPagos_CategoriaCurso FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_CategoriaCurso(id),
    CONSTRAINT FK_BI_HechosPagos_MetodoPago FOREIGN KEY (id_metodoPago) REFERENCES LOS_GDDES.BI_MetodoDePago(id)
)

CREATE TABLE LOS_GDDES.BI_HechosFacturacion (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    id_categoriaCurso BIGINT,
    monto_facturado DECIMAL(12,2),
    monto_pagado DECIMAL(12,2),

    CONSTRAINT PK_BI_HechosFacturacion PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosFacturacion_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosFacturacion_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_Sede(id),
    CONSTRAINT FK_BI_HechosFacturacion_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_CategoriaCurso(id)
)
GO