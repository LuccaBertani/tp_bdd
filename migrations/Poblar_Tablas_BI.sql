USE GD2C2025
GO
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
