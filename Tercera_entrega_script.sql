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
    fecha_pago smalldatetime,
    fecha_vencimiento smalldatetime,
    monto_pago DECIMAL(12,2),
    pago_fuera_termino BIT,

    CONSTRAINT PK_BI_HechosPagos PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosPagos_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_Tiempo(id),
    CONSTRAINT FK_BI_HechosPagos_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_Sede(id),
    CONSTRAINT FK_BI_HechosPagos_CategoriaCurso FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_CategoriaCurso(id)
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


------------------------------------------ Migracion Tablas ---------------------------------------------------

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_TIEMPO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_Tiempo (anio, mes, cuatrimestre, semestre)
    SELECT DISTINCT 
        YEAR(fecha) AS anio,
        MONTH(fecha) AS mes,
        CASE 
            WHEN MONTH(fecha) IN (1,2,3,4) THEN 'Primer Cuatrimestre'
            WHEN MONTH(fecha) IN (5,6,7,8) THEN 'Segundo Cuatrimestre'
            ELSE 'Tercer Cuatrimestre'
        END AS cuatrimestre,
        CASE 
            WHEN MONTH(fecha) IN (1,2,3,4,5,6) THEN 'Primer Semestre'
            ELSE 'Segundo Semestre'
        END AS semestre
    FROM (
        SELECT fecha_inscripcion AS fecha FROM LOS_GDDES.Inscripcion_Curso WHERE fecha_inscripcion IS NOT NULL
        UNION SELECT fecha_respuesta FROM LOS_GDDES.Inscripcion_Curso WHERE fecha_respuesta IS NOT NULL
        UNION SELECT fecha FROM LOS_GDDES.Evaluacion WHERE fecha IS NOT NULL
        UNION SELECT fecha FROM LOS_GDDES.Final WHERE fecha IS NOT NULL
        UNION SELECT fecha_inscripcion FROM LOS_GDDES.Inscripcion_final WHERE fecha_inscripcion IS NOT NULL
        UNION SELECT fecha_pago FROM LOS_GDDES.Pago WHERE fecha_pago IS NOT NULL
        UNION SELECT fecha_emision FROM LOS_GDDES.Factura WHERE fecha_emision IS NOT NULL
        UNION SELECT fecha_vencimiento FROM LOS_GDDES.Factura WHERE fecha_vencimiento IS NOT NULL
        UNION SELECT fecha_inicio FROM LOS_GDDES.Curso WHERE fecha_inicio IS NOT NULL
        UNION SELECT fecha_fin FROM LOS_GDDES.Curso WHERE fecha_fin IS NOT NULL
    ) AS Fechas
    WHERE fecha IS NOT NULL
    ORDER BY YEAR(fecha), MONTH(fecha);
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_SEDE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_Sede (detalle)
    SELECT DISTINCT nombre
    FROM LOS_GDDES.Sede
    ORDER BY nombre;
END
GO

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_RANGOETARIOALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_RangoEtarioAlumno (detalle)
    VALUES ('< 25'), ('25 - 35'), ('35 - 50'), ('> 50');
END
GO

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_RANGOETARIOPROFESOR
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_RangoEtarioProfesor (detalle)
    VALUES ('25 - 35'), ('35 - 50'), ('> 50');
END
GO

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_TURNOCURSO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_TurnoCurso (detalle)
    SELECT DISTINCT nombre
    FROM LOS_GDDES.Turno
    ORDER BY nombre;
    
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_CATEGORIACURSO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_CategoriaCurso (detalle)
    SELECT DISTINCT nombre
    FROM LOS_GDDES.Categoria
    ORDER BY nombre;
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_METODODEPAGO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_MetodoDePago (detalle)
    SELECT DISTINCT descripcion
    FROM LOS_GDDES.MetodoDePago
    ORDER BY descripcion;
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_BLOQUESATISFACCION
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_BloqueSatisfaccion (detalle)
    VALUES ('Satisfechos'), ('Neutrales'), ('Insatisfechos');
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESCURSO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosInscripcionesCurso (id_tiempo, id_categoriaCurso, id_turnoCurso, id_sede, inscriptos, rechazados)
    SELECT 
        t.id AS id_tiempo,
        bc.id AS id_categoriaCurso,
        bt.id AS id_turnoCurso,
        bs.id AS id_sede,
        COUNT(*) AS inscriptos,
        SUM(CASE WHEN e.nombre = 'Rechazado' THEN 1 ELSE 0 END) AS rechazados
    FROM LOS_GDDES.Inscripcion_Curso ic
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = ic.id_curso
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    INNER JOIN LOS_GDDES.Turno tur ON tur.id = c.id_turno
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    LEFT JOIN LOS_GDDES.Estado e ON e.id = ic.id_estado
    INNER JOIN LOS_GDDES.BI_Tiempo t ON t.anio = YEAR(ic.fecha_inscripcion) AND t.mes = MONTH(ic.fecha_inscripcion)
    INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_TurnoCurso bt ON bt.detalle = tur.nombre
    INNER JOIN LOS_GDDES.BI_Sede bs ON bs.detalle = s.nombre
    WHERE ic.fecha_inscripcion IS NOT NULL
    GROUP BY t.id, bc.id, bt.id, bs.id;
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSCURSADAS
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosCursadas (
        id_tiempo, id_sede, id_categoriaCurso, id_turnoCurso, 
        id_rangoAlumno, id_rangoProfesor, id_satisfaccion,
        fecha_inicio, fecha_finalizacion, aprobado, nota_final
    )
    SELECT 
        t.id AS id_tiempo,
        bs.id AS id_sede,
        bc.id AS id_categoriaCurso,
        bt.id AS id_turnoCurso,
        bra.id AS id_rangoAlumno,
        brp.id AS id_rangoProfesor,
        bsat.id AS id_satisfaccion,
        c.fecha_inicio,
        f.fecha AS fecha_finalizacion,
        CASE 
            WHEN ef.nota >= 4 
                AND NOT EXISTS (
                    SELECT 1 FROM LOS_GDDES.Evaluacion_Alumno ea
                    INNER JOIN LOS_GDDES.Evaluacion ev ON ev.id = ea.id_evaluacion
                    INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id = ev.id_modulo_curso
                    WHERE mc.id_curso = c.codigo_curso 
                    AND ea.id_alumno = a.legajo
                    AND ea.nota < 4
                )
                AND NOT EXISTS (
                    SELECT 1 FROM LOS_GDDES.TP tp
                    WHERE tp.id_curso = c.codigo_curso 
                    AND tp.id_alumno = a.legajo
                    AND tp.nota < 4
                )
            THEN 1
            ELSE 0
        END AS aprobado,
        ef.nota AS nota_final
    FROM LOS_GDDES.Inscripcion_Curso ic
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = ic.id_curso
    INNER JOIN LOS_GDDES.Alumno a ON a.legajo = ic.id_alumno
    INNER JOIN LOS_GDDES.Persona pa ON pa.id = a.id_persona
    INNER JOIN LOS_GDDES.Persona pp ON pp.id = c.id_profesor
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    INNER JOIN LOS_GDDES.Turno tur ON tur.id = c.id_turno
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    INNER JOIN LOS_GDDES.Final f ON f.id_curso = c.codigo_curso
    INNER JOIN LOS_GDDES.Evaluacion_Final ef ON ef.id_final = f.id AND ef.id_alumno = a.legajo AND ef.presente = 1
    LEFT JOIN (
        SELECT 
            en.id_curso,
            AVG(CAST(dxp.respuesta AS DECIMAL(5,2))) AS promedio_satisfaccion
        FROM LOS_GDDES.Encuesta en
        INNER JOIN LOS_GDDES.Detalle_x_Pregunta dxp ON dxp.id_encuesta = en.id
        GROUP BY en.id_curso
    ) AS sat ON sat.id_curso = c.codigo_curso
    INNER JOIN LOS_GDDES.BI_Tiempo t ON t.anio = YEAR(c.fecha_inicio) AND t.mes = MONTH(c.fecha_inicio)
    INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_TurnoCurso bt ON bt.detalle = tur.nombre
    INNER JOIN LOS_GDDES.BI_Sede bs ON bs.detalle = s.nombre
    INNER JOIN LOS_GDDES.BI_RangoEtarioAlumno bra ON bra.detalle = 
        CASE 
            WHEN DATEDIFF(YEAR, pa.fecha_nacimiento, GETDATE()) < 25 THEN '< 25'
            WHEN DATEDIFF(YEAR, pa.fecha_nacimiento, GETDATE()) BETWEEN 25 AND 35 THEN '25 - 35'
            WHEN DATEDIFF(YEAR, pa.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 50 THEN '35 - 50'
            ELSE '> 50'
        END
    INNER JOIN LOS_GDDES.BI_RangoEtarioProfesor brp ON brp.detalle = 
        CASE 
            WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 25 AND 35 THEN '25 - 35'
            WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 50 THEN '35 - 50'
            ELSE '> 50'
        END
    LEFT JOIN LOS_GDDES.BI_BloqueSatisfaccion bsat ON bsat.detalle = 
        CASE 
            WHEN sat.promedio_satisfaccion >= 7 THEN 'Satisfechos'
            WHEN sat.promedio_satisfaccion >= 5 THEN 'Neutrales'
            WHEN sat.promedio_satisfaccion >= 1 THEN 'Insatisfechos'
            ELSE 'Neutrales'
        END
    WHERE ic.fecha_inscripcion IS NOT NULL;
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESFINAL
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosInscripcionesFinal (id_tiempo, id_sede, inscriptos, ausentes)
    SELECT 
        t.id AS id_tiempo,
        bs.id AS id_sede,
        COUNT(*) AS inscriptos,
        SUM(CASE WHEN ef.presente = 0 THEN 1 ELSE 0 END) AS ausentes
    FROM LOS_GDDES.Inscripcion_final if_
    INNER JOIN LOS_GDDES.Final f ON f.id = if_.id_final
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = f.id_curso
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    LEFT JOIN LOS_GDDES.Evaluacion_Final ef ON ef.id_final = f.id AND ef.id_alumno = if_.id_alumno
    INNER JOIN LOS_GDDES.BI_Tiempo t ON t.anio = YEAR(if_.fecha_inscripcion) AND t.mes = MONTH(if_.fecha_inscripcion)
    INNER JOIN LOS_GDDES.BI_Sede bs ON bs.detalle = s.nombre
    WHERE if_.fecha_inscripcion IS NOT NULL
    GROUP BY t.id, bs.id;
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosPagos (id_tiempo, id_sede, id_categoriaCurso, fecha_pago, fecha_vencimiento, monto_pago, pago_fuera_termino)
    SELECT 
        t.id AS id_tiempo,
        bs.id AS id_sede,
        bc.id AS id_categoriaCurso,
        p.fecha_pago,
        f.fecha_vencimiento,
        p.importe AS monto_pago,
        CASE WHEN p.fecha_pago > f.fecha_vencimiento THEN 1 ELSE 0 END AS pago_fuera_termino
    FROM LOS_GDDES.Pago p
    INNER JOIN LOS_GDDES.Factura f ON f.numero_factura = p.nro_factura
    INNER JOIN LOS_GDDES.Alumno a ON a.legajo = f.legajo_alumno
    INNER JOIN LOS_GDDES.Detalle_Factura df ON df.id_factura = f.numero_factura
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = df.id_curso
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    INNER JOIN LOS_GDDES.BI_Tiempo t ON t.anio = YEAR(p.fecha_pago) AND t.mes = MONTH(p.fecha_pago)
    INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_Sede bs ON bs.detalle = s.nombre
    WHERE p.fecha_pago IS NOT NULL;
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosFacturacion (id_tiempo, id_sede, id_categoriaCurso, monto_facturado, monto_pagado)
    SELECT 
        t.id AS id_tiempo,
        bs.id AS id_sede,
        bc.id AS id_categoriaCurso,
        SUM(df.monto) AS monto_facturado,
        SUM(ISNULL(p.importe, 0)) AS monto_pagado
    FROM LOS_GDDES.Factura f
    INNER JOIN LOS_GDDES.Detalle_Factura df ON df.id_factura = f.numero_factura
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = df.id_curso
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    LEFT JOIN LOS_GDDES.Pago p ON p.nro_factura = f.numero_factura
    INNER JOIN LOS_GDDES.BI_Tiempo t ON t.anio = YEAR(f.fecha_emision) AND t.mes = MONTH(f.fecha_emision)
    INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_Sede bs ON bs.detalle = s.nombre
    WHERE f.fecha_emision IS NOT NULL
    GROUP BY t.id, bs.id, bc.id;
END
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION PoblarBI;
    
    EXEC LOS_GDDES.SP_POBLAR_BI_TIEMPO;
    EXEC LOS_GDDES.SP_POBLAR_BI_SEDE;
    EXEC LOS_GDDES.SP_POBLAR_BI_RANGOETARIOALUMNO;
    EXEC LOS_GDDES.SP_POBLAR_BI_RANGOETARIOPROFESOR;
    EXEC LOS_GDDES.SP_POBLAR_BI_TURNOCURSO;
    EXEC LOS_GDDES.SP_POBLAR_BI_CATEGORIACURSO;
    EXEC LOS_GDDES.SP_POBLAR_BI_METODODEPAGO;
    EXEC LOS_GDDES.SP_POBLAR_BI_BLOQUESATISFACCION;
    
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESCURSO;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSCURSADAS;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESFINAL;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION;
    
    COMMIT TRANSACTION PoblarBI;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION PoblarBI;
    
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' en línea ' + CAST(ERROR_LINE() AS VARCHAR(10)) + ': ' + ERROR_MESSAGE();
    THROW;
END CATCH
GO


------------------------------------------ Creacion Vistas ---------------------------------------------------

-- Drop existing BI views if they exist
IF OBJECT_ID('LOS_GDDES.BI_HechosFacturacion', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_CategoriasTurnosMasSolicitados;
IF
OBJECT_ID('LOS_GDDES.BI_HechosPagos', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_TasaRechazoInscripciones;
IF
OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesFinal', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_DesempenoCursadaPorSede;
IF
OBJECT_ID('LOS_GDDES.BI_HechosCursadas', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_DesempenoCursadaPorSede;
IF
OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesCurso', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_TiempoPromedioFinalizacion;

IF
OBJECT_ID('LOS_GDDES.BI_BloqueSatisfaccion', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_NotaPromedioFinales;
IF
OBJECT_ID('LOS_GDDES.BI_MetodoDePago', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_TasaAusentismoFinales;
IF
OBJECT_ID('LOS_GDDES.BI_CategoriaCurso', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_DesvioPagos;
IF
OBJECT_ID('LOS_GDDES.BI_TurnoCurso', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_TasaMorosidadMensual;
IF
OBJECT_ID('LOS_GDDES.BI_RangoEtarioProfesor', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_IngresosPorCategoria;
IF
OBJECT_ID('LOS_GDDES.BI_RangoEtarioAlumno', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.VW_IndiceSatisfaccion;
IF
OBJECT_ID('LOS_GDDES.BI_Sede', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.BI_Sede;
IF
OBJECT_ID('LOS_GDDES.BI_Tiempo', 'V') IS NOT NULL
DROP VIEW LOS_GDDES.BI_Tiempo;
GO

--------------------------------------- Dimension Views --------------------------------------------------


/*
Categorías y turnos más solicitados.
Las 3 categorías de cursos y turnos con mayor cantidad de inscriptos por año por sede.
*/
CREATE VIEW LOS_GDDES.VW_CategoriasTurnosMasSolicitados AS
SELECT TOP 3
    t.anio, s.detalle AS sede,
       c.detalle         AS categoria,
       tr.detalle        AS turno,
       SUM(h.inscriptos) AS total_inscriptos
FROM LOS_GDDES.BI_HechosInscripcionesCurso h
         JOIN LOS_GDDES.BI_Tiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_Sede s ON h.id_sede = s.id
         JOIN LOS_GDDES.BI_CategoriaCurso c ON h.id_categoriaCurso = c.id
         JOIN LOS_GDDES.BI_TurnoCurso tr ON h.id_turnoCurso = tr.id
GROUP BY t.anio, s.detalle, c.detalle, tr.detalle
ORDER BY SUM(h.inscriptos) DESC
GO

/*
Tasa de rechazo de inscripciones:
Porcentaje de inscripciones rechazadas por mes por sede (sobre el total de inscripciones).
*/
CREATE VIEW LOS_GDDES.VW_TasaRechazoInscripciones AS
SELECT t.mes,
       s.detalle                                                    AS sede,
       SUM(h.rechazados) * 1.0 / NULLIF(SUM(h.inscriptos), 0) * 100 AS tasa_rechazo
FROM LOS_GDDES.BI_HechosInscripcionesCurso h
         JOIN LOS_GDDES.BI_Tiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_Sede s ON h.id_sede = s.id
GROUP BY t.mes, s.detalle
GO

/*
Comparación de desempeño de cursada por sede:
Porcentaje de aprobación de cursada por sede, por año.
Se considera aprobada la cursada de un alumno cuando tiene nota mayor o igual a 4 en todos los módulos y el TP. TODO: Agregar esta validacion en la migracion de los datos
*/
CREATE VIEW LOS_GDDES.VW_DesempenioCursadaPorSede AS
SELECT t.anio,
       s.detalle                                                              AS sede,
       COUNT(*)                                                               AS total_cursadas,
       SUM(CASE WHEN h.aprobado = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS porcentaje_aprobacion
FROM LOS_GDDES.BI_HechosCursadas h
         JOIN LOS_GDDES.BI_Tiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_Sede s ON h.id_sede = s.id
GROUP BY t.anio, s.detalle
GO

/*
Tiempo promedio de finalización de curso:
Tiempo promedio entre el inicio del curso y la aprobación del final según la categoría de los cursos,
por año. (Tener en cuenta el año de inicio del curso) TODO: Agregar carga del campo fecha_inicio y fecha_finalizacion en la migracion de los datos
*/
CREATE VIEW LOS_GDDES.VW_TiempoPromedioFinalizacion AS
SELECT c.detalle                                                AS categoria,
       AVG(DATEDIFF(day, h.fecha_inicio, h.fecha_finalizacion)) AS dias_promedio
FROM LOS_GDDES.BI_HechosCursadas h
         JOIN LOS_GDDES.BI_CategoriaCurso c ON h.id_categoriaCurso = c.id
GROUP BY c.detalle
GO

/*
Nota promedio de finales.
Promedio de nota de finales según el rango etario del alumno y la categoría del curso por semestre. TODO: Agregar distincion de rango etario del alumno en la migracion de los datos
*/
CREATE VIEW LOS_GDDES.VW_NotaPromedioFinales AS
SELECT t.semestre,
       c.detalle         AS categoria,
       r.detalle         AS rango_etario,
       AVG(h.nota_final) AS nota_promedio
FROM LOS_GDDES.BI_HechosCursadas h
         JOIN LOS_GDDES.BI_Tiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_CategoriaCurso c ON h.id_categoriaCurso = c.id
         JOIN LOS_GDDES.BI_RangoEtarioAlumno r ON h.id_rangoAlumno = r.id
WHERE h.nota_final IS NOT NULL
GROUP BY t.semestre, c.detalle, r.detalle
GO

/*
Tasa de ausentismo finales:
Porcentaje de ausentes a finales (sobre la cantidad de inscriptos) por semestre por sede.
*/
CREATE VIEW LOS_GDDES.VW_TasaAusentismoFinales AS
SELECT t.semestre,
       s.detalle                                                  AS sede,
       SUM(h.ausentes) * 1.0 / NULLIF(SUM(h.inscriptos), 0) * 100 AS tasa_ausentismo
FROM LOS_GDDES.BI_HechosInscripcionesFinal h
         JOIN LOS_GDDES.BI_Tiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_Sede s ON h.id_sede = s.id
GROUP BY t.semestre, s.detalle
GO

/*
Desvío de pagos: Porcentaje de pagos realizados fuera de término por semestre. TODO: Cargar el booleano de pago fuera de termino en la migracion de los datos.
*/
CREATE VIEW LOS_GDDES.VW_DesvioPagos AS
SELECT t.semestre,
       s.detalle            AS sede,
       SUM(CASE WHEN h.pago_fuera_termino = 1 THEN 1 ELSE 0 END) * 1.0
           / COUNT(*) * 100 AS porcentaje_fuera_termino
FROM LOS_GDDES.BI_HechosPagos h
         JOIN LOS_GDDES.BI_Tiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_Sede s ON h.id_sede = s.id
GROUP BY t.semestre, s.detalle
GO

/*
Tasa de Morosidad Financiera mensual.
Se calcula teniendo en cuenta el total de importes adeudados sobre facturación esperada en el mes.
El monto adeudado se obtiene a partir de las facturas que no tengan pago registrado en dicho mes.
*/
CREATE VIEW LOS_GDDES.VW_TasaMorosidadMensual AS
SELECT t.mes,
       (SUM(f.monto_facturado - f.monto_pagado) * 1.0 / NULLIF(SUM(f.monto_facturado), 0)) * 100 AS tasa_morosidad
FROM LOS_GDDES.BI_HechosFacturacion f
         JOIN LOS_GDDES.BI_Tiempo t ON f.id_tiempo = t.id
GROUP BY t.mes
GO

/*
Ingresos por categoría de cursos: Las 3 categorías de cursos que generan mayores ingresos por sede, por año.
*/
CREATE VIEW LOS_GDDES.VW_IngresosPorCategoria AS
SELECT TOP 3
        t.anio,
        s.detalle           AS sede,
        c.detalle           AS categoria,
        SUM(f.monto_pagado) AS ingresos
FROM LOS_GDDES.BI_HechosFacturacion f
         JOIN LOS_GDDES.BI_Tiempo t ON f.id_tiempo = t.id
         JOIN LOS_GDDES.BI_Sede s ON f.id_sede = s.id
         JOIN LOS_GDDES.BI_CategoriaCurso c ON f.id_categoriaCurso = c.id
GROUP BY t.anio, s.detalle, c.detalle
ORDER BY SUM(f.monto_pagado) DESC
GO

/*
Índice de satisfacción. Índice de satisfacción anual, según rango etario de los profesores y sede.
El índice de satisfacción es igual a ((%satisfechos - %insatisfechos) +100)/2.
Teniendo en cuenta que

Satisfechos: Notas entre 7 y 10     TODO: En la migracion hacer esta validacion

Neutrales: Notas entre 5 y 6

Insatisfechos: Notas entre 1 y 4
*/
CREATE VIEW LOS_GDDES.VW_IndiceSatisfaccion AS
SELECT
    t.anio,
    s.detalle    AS sede,
    r.detalle    AS rango_profesor,

    (
        (SUM(CASE WHEN b.detalle = 'Satisfecho' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100)
            -
        (SUM(CASE WHEN b.detalle = 'Insatisfecho' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100)
            + 100
    ) / 2       AS indice_satisfaccion

FROM LOS_GDDES.BI_HechosCursadas h
         JOIN LOS_GDDES.BI_Tiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_Sede s ON h.id_sede = s.id
         JOIN LOS_GDDES.BI_RangoEtarioProfesor r ON h.id_rangoProfesor = r.id
         JOIN LOS_GDDES.BI_BloqueSatisfaccion b ON h.id_satisfaccion = b.id
GROUP BY t.anio, s.detalle, r.detalle
GO

--------------------------------------- Views Created Successfully --------------------------------------------------

