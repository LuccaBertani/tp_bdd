--------------------------------------- Create BI views in LOS_GDDES schema --------------------------------------------------

-- Use GD2C2025 database
USE GD2C2025
GO

-- Drop existing BI views if they exist
IF OBJECT_ID('LOS_GDDES.BI_HechosFacturacion', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_HechosFacturacion;
IF OBJECT_ID('LOS_GDDES.BI_HechosPagos', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_HechosPagos;
IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesFinal', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_HechosInscripcionesFinal;
IF OBJECT_ID('LOS_GDDES.BI_HechosCursadas', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_HechosCursadas;
IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesCurso', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_HechosInscripcionesCurso;

IF OBJECT_ID('LOS_GDDES.BI_BloqueSatisfaccion', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_BloqueSatisfaccion;
IF OBJECT_ID('LOS_GDDES.BI_MetodoDePago', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_MetodoDePago;
IF OBJECT_ID('LOS_GDDES.BI_CategoriaCurso', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_CategoriaCurso;
IF OBJECT_ID('LOS_GDDES.BI_TurnoCurso', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_TurnoCurso;
IF OBJECT_ID('LOS_GDDES.BI_RangoEtarioProfesor', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_RangoEtarioProfesor;
IF OBJECT_ID('LOS_GDDES.BI_RangoEtarioAlumno', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_RangoEtarioAlumno;
IF OBJECT_ID('LOS_GDDES.BI_Sede', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_Sede;
IF OBJECT_ID('LOS_GDDES.BI_Tiempo', 'V') IS NOT NULL DROP VIEW LOS_GDDES.BI_Tiempo;
GO

--------------------------------------- Dimension Views --------------------------------------------------

-- Vista BI_Tiempo: Dimensión temporal con períodos únicos
CREATE VIEW LOS_GDDES.BI_Tiempo
AS
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY YEAR(fecha), MONTH(fecha)) AS id,
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
WHERE fecha IS NOT NULL;
GO

-- Vista BI_Sede: Dimensión de sedes
CREATE VIEW LOS_GDDES.BI_Sede
AS
SELECT 
    id,
    nombre AS detalle
FROM LOS_GDDES.Sede;
GO

-- Vista BI_RangoEtarioAlumno: Rangos de edad para alumnos
CREATE VIEW LOS_GDDES.BI_RangoEtarioAlumno
AS
SELECT 1 AS id, '< 25' AS detalle
UNION ALL SELECT 2, '25 - 35'
UNION ALL SELECT 3, '35 - 50'
UNION ALL SELECT 4, '> 50';
GO

-- Vista BI_RangoEtarioProfesor: Rangos de edad para profesores
CREATE VIEW LOS_GDDES.BI_RangoEtarioProfesor
AS
SELECT 1 AS id, '25 - 35' AS detalle
UNION ALL SELECT 2, '35 - 50'
UNION ALL SELECT 3, '> 50';
GO

-- Vista BI_TurnoCurso: Dimensión de turnos
CREATE VIEW LOS_GDDES.BI_TurnoCurso
AS
SELECT 
    id,
    nombre AS detalle
FROM LOS_GDDES.Turno;
GO

-- Vista BI_CategoriaCurso: Dimensión de categorías
CREATE VIEW LOS_GDDES.BI_CategoriaCurso
AS
SELECT 
    id,
    nombre AS detalle
FROM LOS_GDDES.Categoria;
GO

-- Vista BI_MetodoDePago: Dimensión de métodos de pago
CREATE VIEW LOS_GDDES.BI_MetodoDePago
AS
SELECT 
    id,
    descripcion AS detalle
FROM LOS_GDDES.MetodoDePago;
GO

-- Vista BI_BloqueSatisfaccion: Bloques de satisfacción
CREATE VIEW LOS_GDDES.BI_BloqueSatisfaccion
AS
SELECT 1 AS id, 'Satisfechos' AS detalle
UNION ALL SELECT 2, 'Neutrales'
UNION ALL SELECT 3, 'Insatisfechos';
GO

--------------------------------------- Fact Views --------------------------------------------------

-- Vista BI_HechosInscripcionesCurso: Inscripciones agrupadas por tiempo/categoría/turno/sede
CREATE VIEW LOS_GDDES.BI_HechosInscripcionesCurso
AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY t.id, bc.id, bt.id, bs.id) AS id,
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
INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.id = cat.id
INNER JOIN LOS_GDDES.BI_TurnoCurso bt ON bt.id = tur.id
INNER JOIN LOS_GDDES.BI_Sede bs ON bs.id = s.id
WHERE ic.fecha_inscripcion IS NOT NULL
GROUP BY t.id, bc.id, bt.id, bs.id;
GO

-- Vista BI_HechosCursadas: Cursadas con aprobación y satisfacción
CREATE VIEW LOS_GDDES.BI_HechosCursadas
AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY t.id, bs.id, bc.id, bt.id, bra.id, brp.id) AS id,
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
INNER JOIN LOS_GDDES.Profesor prof ON prof.id_persona = c.id_profesor
INNER JOIN LOS_GDDES.Persona pp ON pp.id = prof.id_persona
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
INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.id = cat.id
INNER JOIN LOS_GDDES.BI_TurnoCurso bt ON bt.id = tur.id
INNER JOIN LOS_GDDES.BI_Sede bs ON bs.id = s.id
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
GO

-- Vista BI_HechosInscripcionesFinal: Inscripciones a finales con ausentismo
CREATE VIEW LOS_GDDES.BI_HechosInscripcionesFinal
AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY t.id, bs.id) AS id,
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
INNER JOIN LOS_GDDES.BI_Sede bs ON bs.id = s.id
WHERE if_.fecha_inscripcion IS NOT NULL
GROUP BY t.id, bs.id;
GO

-- Vista BI_HechosPagos: Pagos con detección de fuera de término
CREATE VIEW LOS_GDDES.BI_HechosPagos
AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY p.nro_factura, p.fecha_pago) AS id,
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
INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.id = cat.id
INNER JOIN LOS_GDDES.BI_Sede bs ON bs.id = s.id
WHERE p.fecha_pago IS NOT NULL;
GO

-- Vista BI_HechosFacturacion: Facturación vs pagos
CREATE VIEW LOS_GDDES.BI_HechosFacturacion
AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY t.id, bs.id, bc.id) AS id,
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
INNER JOIN LOS_GDDES.BI_CategoriaCurso bc ON bc.id = cat.id
INNER JOIN LOS_GDDES.BI_Sede bs ON bs.id = s.id
WHERE f.fecha_emision IS NOT NULL
GROUP BY t.id, bs.id, bc.id;
GO

--------------------------------------- Views Created Successfully --------------------------------------------------

PRINT '========================================='
PRINT 'BI Views created successfully!'
PRINT 'Schema: LOS_GDDES'
PRINT 'Database: GD2C2025'
PRINT '========================================='
PRINT ''
PRINT 'Dimension Views:'
PRINT '  - LOS_GDDES.BI_Tiempo'
PRINT '  - LOS_GDDES.BI_Sede'
PRINT '  - LOS_GDDES.BI_RangoEtarioAlumno'
PRINT '  - LOS_GDDES.BI_RangoEtarioProfesor'
PRINT '  - LOS_GDDES.BI_TurnoCurso'
PRINT '  - LOS_GDDES.BI_CategoriaCurso'
PRINT '  - LOS_GDDES.BI_MetodoDePago'
PRINT '  - LOS_GDDES.BI_BloqueSatisfaccion'
PRINT ''
PRINT 'Fact Views:'
PRINT '  - LOS_GDDES.BI_HechosInscripcionesCurso'
PRINT '  - LOS_GDDES.BI_HechosCursadas'
PRINT '  - LOS_GDDES.BI_HechosInscripcionesFinal'
PRINT '  - LOS_GDDES.BI_HechosPagos'
PRINT '  - LOS_GDDES.BI_HechosFacturacion'
PRINT ''
PRINT 'All views query data directly from LOS_GDDES transactional tables.'
PRINT 'Data is always up-to-date without manual migration.'
PRINT '========================================='
GO

/*
-- Example queries for testing BI views

-- Test Dimension Views
SELECT * FROM LOS_GDDES.BI_Tiempo ORDER BY anio, mes;
SELECT * FROM LOS_GDDES.BI_Sede;
SELECT * FROM LOS_GDDES.BI_CategoriaCurso;
SELECT * FROM LOS_GDDES.BI_RangoEtarioAlumno;
SELECT * FROM LOS_GDDES.BI_RangoEtarioProfesor;

-- Test Fact Views
SELECT TOP 10 * FROM LOS_GDDES.BI_HechosInscripcionesCurso;
SELECT TOP 10 * FROM LOS_GDDES.BI_HechosCursadas WHERE aprobado = 1;
SELECT TOP 10 * FROM LOS_GDDES.BI_HechosInscripcionesFinal;
SELECT TOP 10 * FROM LOS_GDDES.BI_HechosPagos WHERE pago_fuera_termino = 1;
SELECT TOP 10 * FROM LOS_GDDES.BI_HechosFacturacion;
*/
