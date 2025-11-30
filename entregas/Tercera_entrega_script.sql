USE GD2C2025
GO

-- Drop tablas de hechos (PRIMERO, porque tienen FKs hacia dimensiones)
IF OBJECT_ID('LOS_GDDES.BI_HechosIngresos', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosIngresos;

IF OBJECT_ID('LOS_GDDES.BI_HechosFacturacion', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosFacturacion;

IF OBJECT_ID('LOS_GDDES.BI_HechosPagos', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosPagos;

IF OBJECT_ID('LOS_GDDES.BI_HechosSatisfaccion', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosSatisfaccion;

IF OBJECT_ID('LOS_GDDES.BI_HechosAusentismoFinales', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosAusentismoFinales;

IF OBJECT_ID('LOS_GDDES.BI_HechosDesempenioFinales', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosDesempenioFinales;

IF OBJECT_ID('LOS_GDDES.BI_HechosDuracionCursadas', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosDuracionCursadas;

IF OBJECT_ID('LOS_GDDES.BI_HechosDesempenioCursada', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosDesempenioCursada;

IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesFinal', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosInscripcionesFinal;

IF OBJECT_ID('LOS_GDDES.BI_HechosCursadas', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosCursadas;

IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesCurso', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_HechosInscripcionesCurso;

-- Drops de dimensiones (DESPUÉS de hechos)
IF OBJECT_ID('LOS_GDDES.BI_DimBloqueSatisfaccion', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimBloqueSatisfaccion;

IF OBJECT_ID('LOS_GDDES.BI_DimCategoriaCurso', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimCategoriaCurso;

IF OBJECT_ID('LOS_GDDES.BI_CategoriaCurso', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_CategoriaCurso;

IF OBJECT_ID('LOS_GDDES.BI_DimMetodoDePago', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimMetodoDePago;

IF OBJECT_ID('LOS_GDDES.BI_DimTurnoCurso', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimTurnoCurso;

IF OBJECT_ID('LOS_GDDES.BI_DimRangoEtarioProfesor', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimRangoEtarioProfesor;

IF OBJECT_ID('LOS_GDDES.BI_DimRangoEtarioAlumno', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimRangoEtarioAlumno;

IF OBJECT_ID('LOS_GDDES.BI_DimSede', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimSede;

IF OBJECT_ID('LOS_GDDES.BI_DimTiempo', 'U') IS NOT NULL
    DROP TABLE LOS_GDDES.BI_DimTiempo;

-- Drop vistas si existen
IF OBJECT_ID('LOS_GDDES.VW_CategoriasTurnosMasSolicitados', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_CategoriasTurnosMasSolicitados;

IF OBJECT_ID('LOS_GDDES.VW_TasaRechazoInscripciones', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_TasaRechazoInscripciones;

IF OBJECT_ID('LOS_GDDES.VW_DesempenioCursadaPorSede', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_DesempenioCursadaPorSede;

IF OBJECT_ID('LOS_GDDES.VW_TiempoPromedioFinalizacion', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_TiempoPromedioFinalizacion;

IF OBJECT_ID('LOS_GDDES.VW_NotaPromedioFinales', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_NotaPromedioFinales;

IF OBJECT_ID('LOS_GDDES.VW_TasaAusentismoFinales', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_TasaAusentismoFinales;

IF OBJECT_ID('LOS_GDDES.VW_DesvioPagos', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_DesvioPagos;

IF OBJECT_ID('LOS_GDDES.VW_TasaMorosidadMensual', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_TasaMorosidadMensual;

IF OBJECT_ID('LOS_GDDES.VW_IngresosPorCategoria', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_IngresosPorCategoria;

IF OBJECT_ID('LOS_GDDES.VW_IndiceSatisfaccion', 'V') IS NOT NULL
    DROP VIEW LOS_GDDES.VW_IndiceSatisfaccion;
GO

CREATE TABLE LOS_GDDES.BI_DimTiempo
(
id BIGINT IDENTITY(1,1),
anio INTEGER,
mes INTEGER,
cuatrimestre VARCHAR(255),
semestre VARCHAR(255),

CONSTRAINT PK_DimBI_Tiempo PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_DimSede(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_DimBI_Sede PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_DimRangoEtarioAlumno (
id BIGINT IDENTITY(1,1),
detalle VARCHAR(20),

CONSTRAINT PK_BI_DimRangoEtarioAlumno PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_DimRangoEtarioProfesor (
id BIGINT IDENTITY(1,1),
detalle VARCHAR(20),

CONSTRAINT PK_BI_DimRangoEtarioProfesor PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_DimTurnoCurso(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_DimTurnoCurso PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_DimCategoriaCurso(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_DimCategoriaCurso PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_DimMetodoDePago(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

CONSTRAINT PK_BI_DimMetodoDePago PRIMARY KEY (id)
)
GO

CREATE TABLE LOS_GDDES.BI_DimBloqueSatisfaccion(
id BIGINT IDENTITY(1,1),
detalle VARCHAR(255),

    CONSTRAINT PK_BI_DimBloqueSatisfaccion PRIMARY KEY (id)
)
GO

--GRANULARIDAD: CategoriaCurso X TurnoCurso X Año X Sede
CREATE TABLE LOS_GDDES.BI_HechosInscripcionesCurso (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT, -- REVISAR ESTO SEGUN LA GRANULARIDAD DE LA VISTA ASHEI
    id_categoriaCurso BIGINT,
    id_turnoCurso BIGINT,
    id_sede BIGINT,
    inscriptos BIGINT,
    rechazados BIGINT,

    CONSTRAINT PK_BI_HechosInscripcionesCurso PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosInscripcionesCurso_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    CONSTRAINT FK_BI_HechosInscripcionesCurso_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_DimCategoriaCurso(id),
    CONSTRAINT FK_BI_HechosInscripcionesCurso_Turno FOREIGN KEY (id_turnoCurso) REFERENCES LOS_GDDES.BI_DimTurnoCurso(id),
    CONSTRAINT FK_BI_HechosInscripcionesCurso_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id)
)
GO

-- GRANULARIDAD: SEDE X AÑO
CREATE TABLE LOS_GDDES.BI_HechosDesempenioCursada(
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    porcentaje_aprobacion DECIMAL(12,2),

    CONSTRAINT PK_BI_HechosDesempenioCursada PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosDesempenioCursada_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    CONSTRAINT FK_BI_HechosDesempenioCursada_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id)
)
GO

-- GRANULARIDAD: CATEGORIA X AÑO
CREATE TABLE LOS_GDDES.BI_HechosDuracionCursadas (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_categoriaCurso BIGINT,
    promedio_duracion DECIMAL(12,2),

    CONSTRAINT PK_BI_HechosDuracionCursadas PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosDuracionCursadas_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    CONSTRAINT FK_BI_HechosDuracionCursadas_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_DimCategoriaCurso(id)
)
GO

--GRANULARIDAD: RangoEtarioAlumno X CategoriaCurso X Semestre
CREATE TABLE LOS_GDDES.BI_HechosDesempenioFinales(
    id BIGINT IDENTITY(1,1),
    id_rangoEtarioAlumno BIGINT,
    id_categoriaCurso BIGINT,
    id_tiempo BIGINT,
    promedio_notas DECIMAL(12,2),

    CONSTRAINT PK_BI_HechosDesempenioFinales PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosDesempenioFinales_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    CONSTRAINT FK_BI_HechosDesempenioFinales_RangoAlumno FOREIGN KEY (id_rangoEtarioAlumno) REFERENCES LOS_GDDES.BI_DimRangoEtarioAlumno(id),
    CONSTRAINT FK_BI_HechosDesempenioFinales_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_DimCategoriaCurso(id)
)
GO

-- GRANULARIDAD: SEMESTRE X SEDE
CREATE TABLE LOS_GDDES.BI_HechosAusentismoFinales(
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    porcentaje_ausentismo DECIMAL(12,2),

    CONSTRAINT PK_BI_HechosAusentismoFinales PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosAusentismoFinales_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    CONSTRAINT FK_BI_HechosAusentismoFinales_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id)
)
GO

-- GRANULARIDAD: RangoEtarioProfesor X Sede X AÑO
CREATE TABLE LOS_GDDES.BI_HechosSatisfaccion (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_sede BIGINT,
    id_rangoProfesor BIGINT,
    cantidad_evaluaciones INT,
    promedio_satisfaccion DECIMAL(5,2),

    CONSTRAINT PK_BI_HechosSatisfaccion PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosSatisfaccion_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    CONSTRAINT FK_BI_HechosSatisfaccion_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id),
    CONSTRAINT FK_BI_HechosSatisfaccion_RangoProfesor FOREIGN KEY (id_rangoProfesor) REFERENCES LOS_GDDES.BI_DimRangoEtarioProfesor(id)
)
GO

-- GRANULARIDAD: SEMESTRE X AÑO
CREATE TABLE LOS_GDDES.BI_HechosPagos (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    monto_total_pagado DECIMAL(12,2),
    cantidad_pagos INT,
    cantidad_pagos_fuera_termino INT,

    CONSTRAINT PK_BI_HechosPagos PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosPagos_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id)
)
GO

--GRANULARIDAD: MES X AÑO
CREATE TABLE LOS_GDDES.BI_HechosFacturacion (
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    monto_facturado DECIMAL(12,2),
    monto_pagado DECIMAL(12,2),
    monto_adeudado DECIMAL(12,2), -- monto_facturado - monto_pagado

    CONSTRAINT PK_BI_HechosFacturacion PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosFacturacion_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id)
)
GO

--GRANULARIDAD: CategoriaCurso X SEDE X AÑO
CREATE TABLE LOS_GDDES.BI_HechosIngresos(
    id BIGINT IDENTITY(1,1),
    id_tiempo BIGINT,
    id_categoriaCurso BIGINT,
    id_sede BIGINT,
    ingresos DECIMAL(12,2),

    CONSTRAINT PK_BI_HechosIngresos PRIMARY KEY (id),
    CONSTRAINT FK_BI_HechosIngresos_Tiempo FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    CONSTRAINT FK_BI_HechosIngresos_Sede FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id),
    CONSTRAINT FK_BI_HechosIngresos_Categoria FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_DimCategoriaCurso(id)
)
GO

------------------------------------------ Migracion Tablas ---------------------------------------------------

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_TIEMPO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_DimTiempo (anio, mes, cuatrimestre, semestre)
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
    
    INSERT INTO LOS_GDDES.BI_DimSede (detalle)
    SELECT DISTINCT nombre
    FROM LOS_GDDES.Sede
    ORDER BY nombre;
END
GO

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_RANGOETARIOALUMNO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_DimRangoEtarioAlumno (detalle)
    VALUES ('< 25'), ('25 - 35'), ('35 - 50'), ('> 50');
END
GO

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_RANGOETARIOPROFESOR
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_DimRangoEtarioProfesor (detalle)
    VALUES ('25 - 35'), ('35 - 50'), ('> 50');
END
GO

CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_TURNOCURSO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_DimTurnoCurso (detalle)
    SELECT DISTINCT nombre
    FROM LOS_GDDES.Turno
    ORDER BY nombre;
    
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_CATEGORIACURSO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_DimCategoriaCurso (detalle)
    SELECT DISTINCT nombre
    FROM LOS_GDDES.Categoria
    ORDER BY nombre;
END
GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_METODODEPAGO
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_DimMetodoDePago (detalle)
    SELECT DISTINCT descripcion
    FROM LOS_GDDES.MetodoDePago
    ORDER BY descripcion;
END

GO
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_BLOQUESATISFACCION
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_DimBloqueSatisfaccion (detalle)
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
        SUM(CASE WHEN e.nombre = 'Rechazada' THEN 1 ELSE 0 END) AS rechazados
    FROM LOS_GDDES.Inscripcion_Curso ic
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = ic.id_curso
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    INNER JOIN LOS_GDDES.Turno tur ON tur.id = c.id_turno
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    LEFT JOIN LOS_GDDES.Estado e ON e.id = ic.id_estado
    INNER JOIN LOS_GDDES.BI_DimTiempo t ON t.anio = YEAR(ic.fecha_inscripcion) AND t.mes = MONTH(ic.fecha_inscripcion)
    INNER JOIN LOS_GDDES.BI_DimCategoriaCurso bc ON bc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_DimTurnoCurso bt ON bt.detalle = tur.nombre
    INNER JOIN LOS_GDDES.BI_DimSede bs ON bs.detalle = s.nombre
    WHERE ic.fecha_inscripcion IS NOT NULL
    GROUP BY t.id, bc.id, bt.id, bs.id;
END

GO

-- Poblar BI_HechosDesempenioCursada: GRANULARIDAD Sede X Año
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSDESEMPENIOCURSADA
AS
BEGIN
    SET NOCOUNT ON;
    
    WITH CursadasAprobacion AS (
        SELECT 
            YEAR(ic.fecha_inscripcion) AS anio,
            s.id AS id_sede,
            ic.numero_inscripcion,
            ic.id_alumno,
            c.codigo_curso,
            -- Verificar si tiene evaluaciones de módulo reprobadas
            CASE WHEN EXISTS (
                SELECT 1 
                FROM LOS_GDDES.Evaluacion ev
                INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id = ev.id_modulo_curso
                INNER JOIN LOS_GDDES.Evaluacion_Alumno ea ON ea.id_evaluacion = ev.id
                WHERE mc.id_curso = c.codigo_curso 
                AND ea.id_alumno = ic.id_alumno
                AND (ea.nota < 4 OR ea.presente = 0)
            ) THEN 0 ELSE 1 END AS sin_modulos_reprobados,
            -- Verificar si tiene TP reprobado
            CASE WHEN EXISTS (
                SELECT 1
                FROM LOS_GDDES.TP tp
                WHERE tp.id_curso = c.codigo_curso
                AND tp.id_alumno = ic.id_alumno
                AND tp.nota < 4
            ) THEN 0 ELSE 1 END AS sin_tp_reprobado,
            -- Verificar que tenga al menos una evaluación de módulo
            CASE WHEN EXISTS (
                SELECT 1
                FROM LOS_GDDES.Evaluacion ev
                INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id = ev.id_modulo_curso
                INNER JOIN LOS_GDDES.Evaluacion_Alumno ea ON ea.id_evaluacion = ev.id
                WHERE mc.id_curso = c.codigo_curso 
                AND ea.id_alumno = ic.id_alumno
            ) THEN 1 ELSE 0 END AS tiene_evaluaciones,
            -- Verificar que tenga TP
            CASE WHEN EXISTS (
                SELECT 1
                FROM LOS_GDDES.TP tp
                WHERE tp.id_curso = c.codigo_curso
                AND tp.id_alumno = ic.id_alumno
            ) THEN 1 ELSE 0 END AS tiene_tp
        FROM LOS_GDDES.Inscripcion_Curso ic
        INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = ic.id_curso
        INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
        WHERE ic.fecha_inscripcion IS NOT NULL
    )
    INSERT INTO LOS_GDDES.BI_HechosDesempenioCursada (id_tiempo, id_sede, porcentaje_aprobacion)
    SELECT 
        t.id AS id_tiempo,
        bs.id AS id_sede,
        SUM(CASE 
            WHEN sin_modulos_reprobados = 1 
            AND sin_tp_reprobado = 1 
            AND tiene_evaluaciones = 1 
            AND tiene_tp = 1 
            THEN 1 ELSE 0 
        END) * 1.0 / NULLIF(COUNT(*), 0) * 100 AS porcentaje_aprobacion
    FROM CursadasAprobacion ca
    INNER JOIN (SELECT DISTINCT id, anio FROM LOS_GDDES.BI_DimTiempo WHERE mes = 1) t ON t.anio = ca.anio
    INNER JOIN LOS_GDDES.BI_DimSede bs ON bs.id = ca.id_sede
    GROUP BY t.id, bs.id;
END
GO

-- Poblar BI_HechosDuracionCursadas: GRANULARIDAD Categoría X Año
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSDURACIONCURSADAS
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosDuracionCursadas (id_tiempo, id_categoriaCurso, promedio_duracion)
    SELECT 
        t.id AS id_tiempo,
        bc.id AS id_categoriaCurso,
        AVG(DATEDIFF(day, cur.fecha_inicio, f.fecha)) AS promedio_duracion
    FROM LOS_GDDES.Curso cur
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = cur.id_categoria
    INNER JOIN LOS_GDDES.Final f ON f.id_curso = cur.codigo_curso
    INNER JOIN LOS_GDDES.Evaluacion_Final ef ON ef.id_final = f.id AND ef.presente = 1
    INNER JOIN (SELECT DISTINCT id, anio FROM LOS_GDDES.BI_DimTiempo WHERE mes = 1) t ON t.anio = YEAR(cur.fecha_inicio)
    INNER JOIN LOS_GDDES.BI_DimCategoriaCurso bc ON bc.detalle = cat.nombre
    WHERE cur.fecha_inicio IS NOT NULL AND f.fecha IS NOT NULL
    GROUP BY t.id, bc.id;
END
GO

-- Poblar BI_HechosDesempenioFinales: GRANULARIDAD RangoEtarioAlumno X CategoriaCurso X Semestre
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSDESEMPENIOFINALES
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosDesempenioFinales (id_rangoEtarioAlumno, id_categoriaCurso, id_tiempo, promedio_notas)
    SELECT 
        bra.id AS id_rangoEtarioAlumno,
        bc.id AS id_categoriaCurso,
        t.id AS id_tiempo,
        AVG(CAST(ef.nota AS DECIMAL(5,2))) AS promedio_notas
    FROM LOS_GDDES.Evaluacion_Final ef
    INNER JOIN LOS_GDDES.Final f ON f.id = ef.id_final
    INNER JOIN LOS_GDDES.Curso cur ON cur.codigo_curso = f.id_curso
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = cur.id_categoria
    INNER JOIN LOS_GDDES.Alumno a ON a.legajo = ef.id_alumno
    INNER JOIN LOS_GDDES.Persona pa ON pa.id = a.id_persona
    INNER JOIN (SELECT DISTINCT id, anio, semestre FROM LOS_GDDES.BI_DimTiempo WHERE mes = 1) t 
        ON t.anio = YEAR(f.fecha) 
        AND t.semestre = CASE WHEN MONTH(f.fecha) IN (1,2,3,4,5,6) THEN 'Primer Semestre' ELSE 'Segundo Semestre' END
    INNER JOIN LOS_GDDES.BI_DimCategoriaCurso bc ON bc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_DimRangoEtarioAlumno bra ON bra.detalle = 
        CASE 
            WHEN DATEDIFF(YEAR, pa.fecha_nacimiento, f.fecha) < 25 THEN '< 25'
            WHEN DATEDIFF(YEAR, pa.fecha_nacimiento, f.fecha) BETWEEN 25 AND 35 THEN '25 - 35'
            WHEN DATEDIFF(YEAR, pa.fecha_nacimiento, f.fecha) BETWEEN 36 AND 50 THEN '35 - 50'
            ELSE '> 50'
        END
    WHERE ef.nota IS NOT NULL AND ef.presente = 1 AND f.fecha IS NOT NULL
    GROUP BY bra.id, bc.id, t.id;
END
GO

-- Poblar BI_HechosAusentismoFinales: GRANULARIDAD Semestre X Sede
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSAUSENTISMOFINALES
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosAusentismoFinales (id_tiempo, id_sede, porcentaje_ausentismo)
    SELECT 
        t.id AS id_tiempo,
        bs.id AS id_sede,
        SUM(CASE WHEN ef.presente = 0 OR ef.id IS NULL THEN 1 ELSE 0 END) * 1.0 / NULLIF(COUNT(*), 0) * 100 AS porcentaje_ausentismo
    FROM LOS_GDDES.Inscripcion_final if_
    INNER JOIN LOS_GDDES.Final f ON f.id = if_.id_final
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = f.id_curso
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    LEFT JOIN LOS_GDDES.Evaluacion_Final ef ON ef.id_final = f.id AND ef.id_alumno = if_.id_alumno
    INNER JOIN (SELECT DISTINCT id, anio, semestre FROM LOS_GDDES.BI_DimTiempo WHERE mes = 1) t 
        ON t.anio = YEAR(if_.fecha_inscripcion)
        AND t.semestre = CASE WHEN MONTH(if_.fecha_inscripcion) IN (1,2,3,4,5,6) THEN 'Primer Semestre' ELSE 'Segundo Semestre' END
    INNER JOIN LOS_GDDES.BI_DimSede bs ON bs.detalle = s.nombre
    WHERE if_.fecha_inscripcion IS NOT NULL
    GROUP BY t.id, bs.id;
END
GO
-- Poblar BI_HechosPagos: GRANULARIDAD Semestre
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosPagos (id_tiempo, monto_total_pagado, cantidad_pagos, cantidad_pagos_fuera_termino)
    SELECT 
        t.id AS id_tiempo,
        SUM(p.importe) AS monto_total_pagado,
        COUNT(*) AS cantidad_pagos,
        SUM(CASE WHEN p.fecha_pago > f.fecha_vencimiento THEN 1 ELSE 0 END) AS cantidad_pagos_fuera_termino
    FROM LOS_GDDES.Pago p
    INNER JOIN LOS_GDDES.Factura f ON f.numero_factura = p.nro_factura
    INNER JOIN (SELECT DISTINCT id, anio, semestre FROM LOS_GDDES.BI_DimTiempo WHERE mes = 1) t 
        ON t.anio = YEAR(p.fecha_pago)
        AND t.semestre = CASE WHEN MONTH(p.fecha_pago) IN (1,2,3,4,5,6) THEN 'Primer Semestre' ELSE 'Segundo Semestre' END
    WHERE p.fecha_pago IS NOT NULL
    GROUP BY t.id;
END
GO
-- Poblar BI_HechosFacturacion: GRANULARIDAD Mes X Año
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosFacturacion (id_tiempo, monto_facturado, monto_pagado, monto_adeudado)
    SELECT 
        t.id AS id_tiempo,
        SUM(df.monto) AS monto_facturado,
        SUM(ISNULL(p.importe, 0)) AS monto_pagado,
        SUM(df.monto) - SUM(ISNULL(p.importe, 0)) AS monto_adeudado
    FROM LOS_GDDES.Factura f
    INNER JOIN LOS_GDDES.Detalle_Factura df ON df.id_factura = f.numero_factura
    LEFT JOIN LOS_GDDES.Pago p ON p.nro_factura = f.numero_factura
    INNER JOIN LOS_GDDES.BI_DimTiempo t ON t.anio = YEAR(f.fecha_emision) AND t.mes = MONTH(f.fecha_emision)
    WHERE f.fecha_emision IS NOT NULL
    GROUP BY t.id;
END
GO

-- Poblar BI_HechosSatisfaccion: GRANULARIDAD RangoEtarioProfesor X Sede X Año
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSSATISFACCION
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosSatisfaccion (
        id_tiempo, id_sede, id_rangoProfesor,
        cantidad_evaluaciones, promedio_satisfaccion
    )
    SELECT 
        t.id AS id_tiempo,
        bs.id AS id_sede,
        brp.id AS id_rangoProfesor,
        COUNT(*) AS cantidad_evaluaciones,
        AVG(CAST(ea.nota AS DECIMAL(5,2))) AS promedio_satisfaccion
    FROM LOS_GDDES.Evaluacion_Alumno ea
    INNER JOIN LOS_GDDES.Evaluacion ev ON ev.id = ea.id_evaluacion
    INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id = ev.id_modulo_curso
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = mc.id_curso
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    INNER JOIN LOS_GDDES.Profesor pro ON pro.id = c.id_profesor
    INNER JOIN LOS_GDDES.Persona pp ON pp.id = pro.id_persona
    INNER JOIN (SELECT DISTINCT id, anio FROM LOS_GDDES.BI_DimTiempo WHERE mes = 1) t ON t.anio = YEAR(ev.fecha)
    INNER JOIN LOS_GDDES.BI_DimSede bs ON bs.detalle = s.nombre
    INNER JOIN LOS_GDDES.BI_DimRangoEtarioProfesor brp ON brp.detalle = 
        CASE 
            WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 25 AND 35 THEN '25 - 35'
            WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 50 THEN '35 - 50'
            ELSE '> 50'
        END
    WHERE ev.fecha IS NOT NULL AND ea.nota IS NOT NULL
    GROUP BY t.id, bs.id, brp.id;
END
GO

-- Poblar BI_HechosIngresos: GRANULARIDAD CategoriaCurso X Sede X Año
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSINGRESOS
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO LOS_GDDES.BI_HechosIngresos (id_tiempo, id_categoriaCurso, id_sede, ingresos)
    SELECT 
        t.id AS id_tiempo,
        bc.id AS id_categoriaCurso,
        bs.id AS id_sede,
        SUM(p.importe) AS ingresos
    FROM LOS_GDDES.Pago p
    INNER JOIN LOS_GDDES.Factura f ON f.numero_factura = p.nro_factura
    INNER JOIN LOS_GDDES.Detalle_Factura df ON df.id_factura = f.numero_factura
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = df.id_curso
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    INNER JOIN (SELECT DISTINCT id, anio FROM LOS_GDDES.BI_DimTiempo WHERE mes = 1) t ON t.anio = YEAR(p.fecha_pago)
    INNER JOIN LOS_GDDES.BI_DimCategoriaCurso bc ON bc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_DimSede bs ON bs.detalle = s.nombre
    WHERE p.fecha_pago IS NOT NULL
    GROUP BY t.id, bc.id, bs.id;
END
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION PoblarBI;
    
    -- Poblar dimensiones
    EXEC LOS_GDDES.SP_POBLAR_BI_TIEMPO;
    EXEC LOS_GDDES.SP_POBLAR_BI_SEDE;
    EXEC LOS_GDDES.SP_POBLAR_BI_RANGOETARIOALUMNO;
    EXEC LOS_GDDES.SP_POBLAR_BI_RANGOETARIOPROFESOR;
    EXEC LOS_GDDES.SP_POBLAR_BI_TURNOCURSO;
    EXEC LOS_GDDES.SP_POBLAR_BI_CATEGORIACURSO;
    EXEC LOS_GDDES.SP_POBLAR_BI_METODODEPAGO;
    EXEC LOS_GDDES.SP_POBLAR_BI_BLOQUESATISFACCION;
    
    -- Poblar tablas de hechos
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESCURSO;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSDESEMPENIOCURSADA;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSDURACIONCURSADAS;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSDESEMPENIOFINALES;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSAUSENTISMOFINALES;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSSATISFACCION;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSINGRESOS;
    
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


/*
Categorías y turnos más solicitados.
Las 3 categorías de cursos y turnos con mayor cantidad de inscriptos por año por sede.
*/
CREATE OR ALTER VIEW LOS_GDDES.VW_CategoriasTurnosMasSolicitados AS
SELECT
    sub.anio,
    sub.sede,
    sub.categoria,
    sub.turno,
    sub.total_inscriptos
FROM (
    SELECT
        t.anio,
        s.detalle AS sede,
        c.detalle AS categoria,
        tr.detalle AS turno,
        SUM(h.inscriptos) AS total_inscriptos,
        ROW_NUMBER() OVER (
            PARTITION BY t.anio, s.detalle
            ORDER BY SUM(h.inscriptos) DESC
        ) AS rn
    FROM LOS_GDDES.BI_HechosInscripcionesCurso h
    JOIN LOS_GDDES.BI_DimTiempo t               ON h.id_tiempo       = t.id
    JOIN LOS_GDDES.BI_DimSede s                 ON h.id_sede         = s.id
    JOIN LOS_GDDES.BI_DimCategoriaCurso c       ON h.id_categoriaCurso = c.id
    JOIN LOS_GDDES.BI_DimTurnoCurso tr          ON h.id_turnoCurso   = tr.id
    GROUP BY t.anio, s.detalle, c.detalle, tr.detalle
) sub
WHERE sub.rn <= 3;
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
         JOIN LOS_GDDES.BI_DimTiempo t ON h.id_tiempo = t.id
         JOIN LOS_GDDES.BI_DimSede s ON h.id_sede = s.id
GROUP BY t.mes, s.detalle
GO

/*
Comparación de desempeño de cursada por sede:
Porcentaje de aprobación de cursada por sede, por año.
Se considera aprobada la cursada de un alumno cuando tiene nota mayor o igual a 4 en todos los módulos y el TP.
*/
CREATE VIEW LOS_GDDES.VW_DesempenioCursadaPorSede AS
SELECT 
    t.anio,
    s.detalle AS sede,
    h.porcentaje_aprobacion
FROM LOS_GDDES.BI_HechosDesempenioCursada h
JOIN LOS_GDDES.BI_DimTiempo t ON h.id_tiempo = t.id
JOIN LOS_GDDES.BI_DimSede s ON h.id_sede = s.id
GO

/*
Tiempo promedio de finalización de curso:
Tiempo promedio entre el inicio del curso y la aprobación del final según la categoría de los cursos,
por año.
*/
CREATE VIEW LOS_GDDES.VW_TiempoPromedioFinalizacion AS
SELECT 
    t.anio,
    c.detalle AS categoria,
    h.promedio_duracion AS dias_promedio
FROM LOS_GDDES.BI_HechosDuracionCursadas h
JOIN LOS_GDDES.BI_DimTiempo t ON h.id_tiempo = t.id
JOIN LOS_GDDES.BI_DimCategoriaCurso c ON h.id_categoriaCurso = c.id
GO

/*
Nota promedio de finales.
Promedio de nota de finales según el rango etario del alumno y la categoría del curso por semestre.
*/
CREATE VIEW LOS_GDDES.VW_NotaPromedioFinales AS
SELECT 
    t.semestre,
    c.detalle AS categoria,
    r.detalle AS rango_etario,
    h.promedio_notas AS nota_promedio
FROM LOS_GDDES.BI_HechosDesempenioFinales h
JOIN LOS_GDDES.BI_DimTiempo t ON h.id_tiempo = t.id
JOIN LOS_GDDES.BI_DimCategoriaCurso c ON h.id_categoriaCurso = c.id
JOIN LOS_GDDES.BI_DimRangoEtarioAlumno r ON h.id_rangoEtarioAlumno = r.id
GO

/*
Tasa de ausentismo finales:
Porcentaje de ausentes a finales (sobre la cantidad de inscriptos) por semestre por sede.
*/
CREATE VIEW LOS_GDDES.VW_TasaAusentismoFinales AS
SELECT 
    t.semestre,
    s.detalle AS sede,
    h.porcentaje_ausentismo AS tasa_ausentismo
FROM LOS_GDDES.BI_HechosAusentismoFinales h
JOIN LOS_GDDES.BI_DimTiempo t ON h.id_tiempo = t.id
JOIN LOS_GDDES.BI_DimSede s ON h.id_sede = s.id
GO

/*
Desvío de pagos: Porcentaje de pagos realizados fuera de término por semestre.
*/
CREATE VIEW LOS_GDDES.VW_DesvioPagos AS
SELECT 
    t.semestre,
    h.cantidad_pagos_fuera_termino * 1.0 / NULLIF(h.cantidad_pagos, 0) * 100 AS porcentaje_fuera_termino
FROM LOS_GDDES.BI_HechosPagos h
JOIN LOS_GDDES.BI_DimTiempo t ON h.id_tiempo = t.id
GO

/*
Tasa de Morosidad Financiera mensual.
Se calcula teniendo en cuenta el total de importes adeudados sobre facturación esperada en el mes.
El monto adeudado se obtiene a partir de las facturas que no tengan pago registrado en dicho mes.
*/
CREATE VIEW LOS_GDDES.VW_TasaMorosidadMensual AS
SELECT 
    t.anio,
    t.mes,
    (f.monto_adeudado * 1.0 / NULLIF(f.monto_facturado, 0)) * 100 AS tasa_morosidad
FROM LOS_GDDES.BI_HechosFacturacion f
JOIN LOS_GDDES.BI_DimTiempo t ON f.id_tiempo = t.id
GO

/*
Ingresos por categoría de cursos: Las 3 categorías de cursos que generan mayores ingresos por sede, por año.
*/
CREATE OR ALTER VIEW LOS_GDDES.VW_IngresosPorCategoria AS
SELECT 
    sub.anio,
    sub.sede,
    sub.categoria,
    sub.ingresos
FROM (
    SELECT
        t.anio,
        s.detalle AS sede,
        c.detalle AS categoria,
        h.ingresos,
        ROW_NUMBER() OVER (
            PARTITION BY t.anio, s.detalle
            ORDER BY h.ingresos DESC
        ) AS rn
    FROM LOS_GDDES.BI_HechosIngresos h
    JOIN LOS_GDDES.BI_DimTiempo t ON h.id_tiempo = t.id
    JOIN LOS_GDDES.BI_DimSede s ON h.id_sede = s.id
    JOIN LOS_GDDES.BI_DimCategoriaCurso c ON h.id_categoriaCurso = c.id
) sub
WHERE sub.rn <= 3;
GO

/*
Índice de satisfacción. Índice de satisfacción anual, según rango etario de los profesores y sede.
El índice de satisfacción es igual a ((%satisfechos - %insatisfechos) +100)/2.
Teniendo en cuenta que

Satisfechos: Notas entre 7 y 10

Neutrales: Notas entre 5 y 6

Insatisfechos: Notas entre 1 y 4
*/
CREATE VIEW LOS_GDDES.VW_IndiceSatisfaccion AS
SELECT
    YEAR(ev.fecha) AS anio,
    s.nombre AS sede,
    CASE 
        WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 25 AND 35 THEN '25 - 35'
        WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 50 THEN '35 - 50'
        ELSE '> 50'
    END AS rango_profesor,
    (
        (SUM(CASE WHEN ea.nota >= 7 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100)
            -
        (SUM(CASE WHEN ea.nota BETWEEN 1 AND 4 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100)
            + 100
    ) / 2 AS indice_satisfaccion
FROM LOS_GDDES.Evaluacion_Alumno ea
INNER JOIN LOS_GDDES.Evaluacion ev ON ev.id = ea.id_evaluacion
INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id = ev.id_modulo_curso
INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = mc.id_curso
INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
INNER JOIN LOS_GDDES.Profesor pro ON pro.id = c.id_profesor
INNER JOIN LOS_GDDES.Persona pp ON pp.id = pro.id_persona
WHERE ev.fecha IS NOT NULL AND ea.nota IS NOT NULL
GROUP BY YEAR(ev.fecha), s.nombre,
    CASE 
        WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 25 AND 35 THEN '25 - 35'
        WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 50 THEN '35 - 50'
        ELSE '> 50'
    END
GO