

CREATE TABLE BI_Tiempo(
id BIGINT IDENTITY(1,1),
anio INTEGER,
mes INTEGER,
cuatrimestre VARCHAR(255),
semestre VARCHAR(255),

CONSTRAINT PK_BI_Tiempo PRIMARY KEY (id),
)

CREATE TABLE BI_Sede(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_Sede PRIMARY KEY (id)
)

CREATE TABLE BI_RangoEtarioAlumno (
id BIGINT IDENTITY(1,1),
detalle VARCHAR(20),

CONSTRAINT PK_BI_RangoEtarioAlumno PRIMARY KEY (id)
)

CREATE TABLE BI_RangoEtarioProfesor (
id BIGINT IDENTITY(1,1),
detalle VARCHAR(20),

CONSTRAINT PK_BI_RangoEtarioProfesor PRIMARY KEY (id)
)

CREATE TABLE BI_TurnoCurso(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_TurnoCurso PRIMARY KEY (id)
)

CREATE TABLE BI_CategoriaCurso(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_CategoriaCurso PRIMARY KEY (id)
)

CREATE TABLE BI_MetodoDePago(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_MetodoDePago PRIMARY KEY (id)
)

CREATE TABLE BI_BloqueSatisfaccion(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_BloqueSatisfaccion PRIMARY KEY (id)
)

CREATE TABLE BI_HechosInscripcionesCurso (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_categoriaCurso BIGINT,
    id_turnoCurso BIGINT,
    id_sede BIGINT,
    inscriptos BIGINT,
    rechazados BIGINT,

    CONSTRAINT PK_BI_HechosInscripciones PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosInscripciones_Tiempo FOREIGN KEY (id_tiempo) REFERENCES BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosInscripciones_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES BI_CategoriaCurso(id),
    CONSTRAINT FK_BI_HechosInscripciones_Turno FOREIGN KEY (id_turnoCurso) REFERENCES BI_TurnoCurso(id),
    CONSTRAINT FK_BI_HechosInscripciones_Sede FOREIGN KEY (id_sede) REFERENCES BI_Sede(id),
)

CREATE TABLE BI_HechosCursadas (
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
    CONSTRAINT FK_BI_HechosCursadas_Tiempo FOREIGN KEY (id_tiempo) REFERENCES BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosCursadas_Sede FOREIGN KEY (id_sede) REFERENCES BI_Sede(id),
    CONSTRAINT FK_BI_HechosCursadas_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES BI_CategoriaCurso(id),
    CONSTRAINT FK_BI_HechosCursadas_Turno FOREIGN KEY (id_turnoCurso) REFERENCES BI_TurnoCurso(id),
    CONSTRAINT FK_BI_HechosCursadas_RangoEtarioAlumno FOREIGN KEY (id_rangoAlumno) REFERENCES BI_RangoEtarioAlumno(id),
    CONSTRAINT FK_BI_HechosCursadas_RangoEtarioProfesor FOREIGN KEY (id_rangoProfesor) REFERENCES BI_RangoEtarioProfesor(id),
    CONSTRAINT FK_BI_HechosCursadas_BloqueSatisfaccion FOREIGN KEY (id_satisfaccion) REFERENCES BI_BloqueSatisfaccion (id)
)

CREATE TABLE BI_HechosInscripcionesFinal (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,               
    inscriptos INT,
    ausentes INT,

    CONSTRAINT PK_BI_HechosInscripcionesFinal PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosInscripcionesFinal_Tiempo FOREIGN KEY (id_tiempo) REFERENCES BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosInscripcionesFinal_Sede FOREIGN KEY (id_sede) REFERENCES BI_Sede(id),
)

CREATE TABLE BI_HechosPagos (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    id_categoriaCurso BIGINT,
    fecha_pago smalldatetime,
    fecha_vencimiento smalldatetime,
    monto_pago DECIMAL(12,2),
    pago_fuera_termino BIT,

    CONSTRAINT PK_BI_HechosPagos PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosPagos_Tiempo FOREIGN KEY (id_tiempo) REFERENCES BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosPagos_Sede FOREIGN KEY (id_sede) REFERENCES BI_Sede(id),
    CONSTRAINT FK_BI_HechosPagos_CategoriaCurso FOREIGN KEY (id_categoriaCurso) REFERENCES BI_CategoriaCurso(id)
)

CREATE TABLE BI_HechosFacturacion (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    id_categoriaCurso BIGINT,
    monto_facturado DECIMAL(12,2),
    monto_pagado DECIMAL(12,2),

    CONSTRAINT PK_BI_HechosFacturacion PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosFacturacion_Tiempo FOREIGN KEY (id_tiempo) REFERENCES BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosFacturacion_Sede FOREIGN KEY (id_sede) REFERENCES BI_Sede(id),
    CONSTRAINT FK_BI_HechosFacturacion_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES BI_CategoriaCurso(id)
)
