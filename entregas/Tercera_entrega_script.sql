USE GD2C2025
GO

/* ======================================================
   DROPEO COMPLETO DEL MODELO BI (Orden: Vistas -> Hechos -> Dimensiones)
   ====================================================== */

-- Vistas
IF OBJECT_ID('LOS_GDDES.VW_Top3_Categorias_Turnos', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Top3_Categorias_Turnos;
IF OBJECT_ID('LOS_GDDES.VW_Tasa_Rechazo', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Tasa_Rechazo;
IF OBJECT_ID('LOS_GDDES.VW_Porcentaje_Aprobacion_Cursada', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Porcentaje_Aprobacion_Cursada;
IF OBJECT_ID('LOS_GDDES.VW_Tiempo_Promedio_Resolucion', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Tiempo_Promedio_Resolucion;
IF OBJECT_ID('LOS_GDDES.VW_Nota_Promedio_Finales', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Nota_Promedio_Finales;
IF OBJECT_ID('LOS_GDDES.VW_Tasa_Ausentismo_Finales', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Tasa_Ausentismo_Finales;
IF OBJECT_ID('LOS_GDDES.VW_Desvio_Pagos', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Desvio_Pagos;
IF OBJECT_ID('LOS_GDDES.VW_Morosidad_Financiera', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Morosidad_Financiera;
IF OBJECT_ID('LOS_GDDES.VW_Top3_Ingresos_Categoria', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Top3_Ingresos_Categoria;
IF OBJECT_ID('LOS_GDDES.VW_Indice_Satisfaccion', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_Indice_Satisfaccion;
IF OBJECT_ID('LOS_GDDES.VW_IndiceSatisfaccion', 'V') IS NOT NULL DROP VIEW LOS_GDDES.VW_IndiceSatisfaccion;

-- Tablas de Hechos (Hijas)
IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesCurso', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_HechosInscripcionesCurso;
IF OBJECT_ID('LOS_GDDES.BI_HechosCursadas', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_HechosCursadas;
IF OBJECT_ID('LOS_GDDES.BI_HechosInscripcionesFinal', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_HechosInscripcionesFinal;
IF OBJECT_ID('LOS_GDDES.BI_HechosFinales', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_HechosFinales;
IF OBJECT_ID('LOS_GDDES.BI_HechosPagos', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_HechosPagos;
IF OBJECT_ID('LOS_GDDES.BI_HechosFacturacion', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_HechosFacturacion;
IF OBJECT_ID('LOS_GDDES.BI_HechosSatisfaccion', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_HechosSatisfaccion;

-- Dimensiones (Padres)
IF OBJECT_ID('LOS_GDDES.BI_DimBloqueSatisfaccion', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimBloqueSatisfaccion;
IF OBJECT_ID('LOS_GDDES.BI_DimMetodoDePago', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimMetodoDePago;
IF OBJECT_ID('LOS_GDDES.BI_DimTurnoCurso', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimTurnoCurso;
IF OBJECT_ID('LOS_GDDES.BI_DimCategoriaCurso', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimCategoriaCurso;
IF OBJECT_ID('LOS_GDDES.BI_DimRangoEtarioProfesor', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimRangoEtarioProfesor;
IF OBJECT_ID('LOS_GDDES.BI_DimRangoEtarioAlumno', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimRangoEtarioAlumno;
IF OBJECT_ID('LOS_GDDES.BI_DimSede', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimSede;
IF OBJECT_ID('LOS_GDDES.BI_DimTiempo', 'U') IS NOT NULL DROP TABLE LOS_GDDES.BI_DimTiempo;

-- Procedures
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_TIEMPO', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_TIEMPO;
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_DIMENSIONES_FIJAS', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_DIMENSIONES_FIJAS;
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESCURSO', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESCURSO;
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_HECHOSCURSADAS', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSCURSADAS;
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_HECHOSFINALES', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSFINALES;
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS;
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION;
IF OBJECT_ID('LOS_GDDES.SP_POBLAR_BI_HECHOSSATISFACCION', 'P') IS NOT NULL DROP PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSSATISFACCION;

PRINT 'Limpieza completada.';
GO

/* ============================================================================================
   CREACION DE DIMENSIONES
   ============================================================================================ */

CREATE TABLE LOS_GDDES.BI_DimTiempo (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE,
    anio INT,
    mes INT,
    cuatrimestre VARCHAR(20),
    semestre VARCHAR(20)
);

CREATE TABLE LOS_GDDES.BI_DimSede (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    detalle VARCHAR(255)
);

CREATE TABLE LOS_GDDES.BI_DimRangoEtarioAlumno (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    detalle VARCHAR(20)
);

CREATE TABLE LOS_GDDES.BI_DimRangoEtarioProfesor (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    detalle VARCHAR(20)
);

CREATE TABLE LOS_GDDES.BI_DimTurnoCurso (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    detalle VARCHAR(255)
);

CREATE TABLE LOS_GDDES.BI_DimCategoriaCurso (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    detalle VARCHAR(255)
);

CREATE TABLE LOS_GDDES.BI_DimMetodoDePago (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    detalle VARCHAR(255)
);

CREATE TABLE LOS_GDDES.BI_DimBloqueSatisfaccion (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    detalle VARCHAR(20)
);
GO

/* ============================================================================================
   CREACION DE TABLAS DE HECHOS (AGRUPADAS)
   ============================================================================================ */

-- 1) HECHOS INSCRIPCIONES CURSO (AGRUPADA)
CREATE TABLE LOS_GDDES.BI_HechosInscripcionesCurso (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo BIGINT NOT NULL,
    id_categoriaCurso BIGINT NOT NULL,
    id_turnoCurso BIGINT NOT NULL,
    id_sede BIGINT NOT NULL,
    id_rangoEtarioAlumno BIGINT NOT NULL,
    cantidad_inscriptos INT DEFAULT 0, -- Total de inscripciones
    cantidad_rechazos INT DEFAULT 0,   -- Total de rechazadas

    FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_DimCategoriaCurso(id),
    FOREIGN KEY (id_turnoCurso) REFERENCES LOS_GDDES.BI_DimTurnoCurso(id),
    FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id),
    FOREIGN KEY (id_rangoEtarioAlumno) REFERENCES LOS_GDDES.BI_DimRangoEtarioAlumno(id)
);

-- 2) HECHOS CURSADAS (AGRUPADA - KPI 3)
CREATE TABLE LOS_GDDES.BI_HechosCursadas (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo BIGINT NOT NULL, 
    id_sede BIGINT NOT NULL,
    cantidad_cursadas_totales INT,
    cantidad_cursadas_aprobadas INT,

    FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id)
);

-- 3) HECHOS INSCRIPCIONES FINAL (AGRUPADA)
CREATE TABLE LOS_GDDES.BI_HechosInscripcionesFinal (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo BIGINT NOT NULL,
    id_sede BIGINT NOT NULL,
    cantidad_inscriptos INT DEFAULT 0,

    FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id)
);

-- 4) HECHOS FINALES (AGRUPADA - KPI 4, 5, 6)
-- Agrupamos por nota para poder calcular promedios, o almacenamos suma_notas y cantidad.
-- Para mantener flexibilidad con el promedio (KPI 5) y rangos, agruparemos por las dims.
CREATE TABLE LOS_GDDES.BI_HechosFinales (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo BIGINT NOT NULL,
    id_categoriaCurso BIGINT NOT NULL,
    id_sede BIGINT NOT NULL,
    id_rangoEtarioAlumno BIGINT NOT NULL,
    cantidad_presentes INT NOT NULL,
    suma_notas DECIMAL(12,2), -- Suma para calcular promedio en vista
    suma_tiempo_resolucion INT, -- Suma dias para promedio
    cantidad_aprobados_con_tiempo INT, -- Divisor para el promedio de tiempo

    FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_DimCategoriaCurso(id),
    FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id),
    FOREIGN KEY (id_rangoEtarioAlumno) REFERENCES LOS_GDDES.BI_DimRangoEtarioAlumno(id)
);

-- 5) HECHOS PAGOS (AGRUPADA - KPI 7)
CREATE TABLE LOS_GDDES.BI_HechosPagos (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo BIGINT NOT NULL,
    id_metodoPago BIGINT NOT NULL,
    id_sede BIGINT NOT NULL,
    cantidad_pagos INT,
    suma_importe_pagado DECIMAL(18,2),
    cantidad_pagos_fuera_termino INT, -- Pre-calculado

    FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    FOREIGN KEY (id_metodoPago) REFERENCES LOS_GDDES.BI_DimMetodoDePago(id),
    FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id)
);

-- 6) HECHOS FACTURACION (AGRUPADA - KPI 8, 9)
CREATE TABLE LOS_GDDES.BI_HechosFacturacion (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo BIGINT NOT NULL, 
    id_categoriaCurso BIGINT NOT NULL,
    id_sede BIGINT NOT NULL,
    suma_monto_facturado DECIMAL(18,2),
    suma_monto_adeudado DECIMAL(18,2),
    cantidad_facturas_emitidas INT,

    FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    FOREIGN KEY (id_categoriaCurso) REFERENCES LOS_GDDES.BI_DimCategoriaCurso(id),
    FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id)
);

-- 7) HECHOS SATISFACCION (AGRUPADA - KPI 10)
CREATE TABLE LOS_GDDES.BI_HechosSatisfaccion (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo BIGINT NOT NULL,
    id_sede BIGINT NOT NULL,
    id_rangoProfesor BIGINT NOT NULL,
    id_bloqueSatisfaccion BIGINT NOT NULL,
    cantidad_respuestas INT NOT NULL,

    FOREIGN KEY (id_tiempo) REFERENCES LOS_GDDES.BI_DimTiempo(id),
    FOREIGN KEY (id_sede) REFERENCES LOS_GDDES.BI_DimSede(id),
    FOREIGN KEY (id_rangoProfesor) REFERENCES LOS_GDDES.BI_DimRangoEtarioProfesor(id),
    FOREIGN KEY (id_bloqueSatisfaccion) REFERENCES LOS_GDDES.BI_DimBloqueSatisfaccion(id)
);
GO

/* ============================================================================================
   PROCEDIMIENTOS DE CARGA (Con Group By)
   ============================================================================================ */

CREATE PROCEDURE LOS_GDDES.SP_POBLAR_BI_TIEMPO AS
BEGIN
    INSERT INTO LOS_GDDES.BI_DimTiempo (fecha, anio, mes, cuatrimestre, semestre)
    SELECT DISTINCT fecha, YEAR(fecha), MONTH(fecha),
        CASE WHEN MONTH(fecha) BETWEEN 1 AND 4 THEN 'Primer'
             WHEN MONTH(fecha) BETWEEN 5 AND 8 THEN 'Segundo'
             ELSE 'Tercer' END, 
        CASE WHEN MONTH(fecha) BETWEEN 1 AND 6 THEN 'Primer' ELSE 'Segundo' END
    FROM (
        SELECT fecha_inscripcion AS fecha FROM LOS_GDDES.Inscripcion_Curso WHERE fecha_inscripcion IS NOT NULL
        UNION SELECT fecha_respuesta FROM LOS_GDDES.Inscripcion_Curso WHERE fecha_respuesta IS NOT NULL
        UNION SELECT fecha FROM LOS_GDDES.Evaluacion WHERE fecha IS NOT NULL
        UNION SELECT fecha FROM LOS_GDDES.Final WHERE fecha IS NOT NULL
        UNION SELECT fecha_inscripcion FROM LOS_GDDES.Inscripcion_final WHERE fecha_inscripcion IS NOT NULL
        UNION SELECT fecha_pago FROM LOS_GDDES.Pago WHERE fecha_pago IS NOT NULL
        UNION SELECT fecha_emision FROM LOS_GDDES.Factura WHERE fecha_emision IS NOT NULL
        UNION SELECT fecha_registro FROM LOS_GDDES.Encuesta WHERE fecha_registro IS NOT NULL
    ) F;
END
GO

CREATE PROCEDURE LOS_GDDES.SP_POBLAR_BI_DIMENSIONES_FIJAS AS
BEGIN
    INSERT INTO LOS_GDDES.BI_DimSede (detalle) SELECT DISTINCT nombre FROM LOS_GDDES.Sede;
    INSERT INTO LOS_GDDES.BI_DimTurnoCurso (detalle) SELECT DISTINCT nombre FROM LOS_GDDES.Turno;
    INSERT INTO LOS_GDDES.BI_DimCategoriaCurso (detalle) SELECT DISTINCT nombre FROM LOS_GDDES.Categoria;
    INSERT INTO LOS_GDDES.BI_DimMetodoDePago (detalle) SELECT DISTINCT descripcion FROM LOS_GDDES.MetodoDePago;
    
    INSERT INTO LOS_GDDES.BI_DimRangoEtarioAlumno (detalle) VALUES ('< 25'), ('25 - 35'), ('35 - 50'), ('> 50');
    INSERT INTO LOS_GDDES.BI_DimRangoEtarioProfesor (detalle) VALUES ('25 - 35'), ('35 - 50'), ('> 50');
    INSERT INTO LOS_GDDES.BI_DimBloqueSatisfaccion (detalle) VALUES ('Satisfechos'), ('Neutrales'), ('Insatisfechos');
END
GO

-- SP 1: INSCRIPCIONES CURSO (AGRUPADO)
CREATE PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESCURSO AS
BEGIN
    INSERT INTO LOS_GDDES.BI_HechosInscripcionesCurso
    (id_tiempo, id_categoriaCurso, id_turnoCurso, id_sede, id_rangoEtarioAlumno, cantidad_inscriptos, cantidad_rechazos)
    SELECT
        dt.id, dc.id, dtur.id, ds.id, dra.id,
        COUNT(*) AS cantidad_inscriptos,
        SUM(CASE WHEN e.nombre = 'Rechazada' THEN 1 ELSE 0 END) AS cantidad_rechazos
    FROM LOS_GDDES.Inscripcion_Curso ic
    JOIN LOS_GDDES.Curso c ON c.codigo_curso = ic.id_curso
    JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    JOIN LOS_GDDES.Turno tur ON tur.id = c.id_turno
    JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    JOIN LOS_GDDES.Estado e ON e.id = ic.id_estado
    JOIN LOS_GDDES.Alumno a ON a.legajo = ic.id_alumno
    JOIN LOS_GDDES.Persona p ON p.id = a.id_persona
    JOIN LOS_GDDES.BI_DimTiempo dt ON dt.fecha = ic.fecha_inscripcion
    JOIN LOS_GDDES.BI_DimCategoriaCurso dc ON dc.detalle = cat.nombre
    JOIN LOS_GDDES.BI_DimTurnoCurso dtur ON dtur.detalle = tur.nombre
    JOIN LOS_GDDES.BI_DimSede ds ON ds.detalle = s.nombre
    JOIN LOS_GDDES.BI_DimRangoEtarioAlumno dra ON dra.detalle = 
        CASE WHEN DATEDIFF(YEAR, p.fecha_nacimiento, ic.fecha_inscripcion) < 25 THEN '< 25'
             WHEN DATEDIFF(YEAR, p.fecha_nacimiento, ic.fecha_inscripcion) BETWEEN 25 AND 35 THEN '25 - 35'
             WHEN DATEDIFF(YEAR, p.fecha_nacimiento, ic.fecha_inscripcion) BETWEEN 36 AND 50 THEN '35 - 50'
             ELSE '> 50' END
    GROUP BY dt.id, dc.id, dtur.id, ds.id, dra.id;
END
GO

-- SP 2: CURSADAS (AGRUPADO)
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSCURSADAS
AS
BEGIN
    SET NOCOUNT ON;
    -- Primero calculamos el estado por alumno (detalle)
    WITH DetalleCursada AS (
        SELECT 
            ic.id_curso,
            ic.id_alumno,
            ic.fecha_inscripcion,
            s.id AS id_sede_origen,
            CASE 
                WHEN 
                    (SELECT COUNT(*) FROM LOS_GDDES.Modulo_Curso mc WHERE mc.id_curso = ic.id_curso)
                    =
                    (
                        SELECT COUNT(DISTINCT mc.id)
                        FROM LOS_GDDES.Evaluacion_alumno ea
                        INNER JOIN LOS_GDDES.Evaluacion e ON e.id = ea.id_evaluacion
                        INNER JOIN LOS_GDDES.Modulo_Curso mc ON mc.id = e.id_modulo_curso
                        WHERE mc.id_curso = ic.id_curso 
                          AND ea.id_alumno = ic.id_alumno
                          AND ea.nota >= 4 
                    )
                    AND 
                    EXISTS (
                        SELECT 1 FROM LOS_GDDES.TP tp
                        WHERE tp.id_curso = ic.id_curso 
                          AND tp.id_alumno = ic.id_alumno 
                          AND tp.nota >= 4
                    )
                THEN 1 ELSE 0 
            END as aprobo
        FROM LOS_GDDES.Inscripcion_Curso ic
        INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = ic.id_curso
        INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
        INNER JOIN LOS_GDDES.Estado est ON est.id = ic.id_estado
        WHERE est.nombre IN ('Aceptada', 'Confirmada')
    )
    -- Ahora agrupamos e insertamos
    INSERT INTO LOS_GDDES.BI_HechosCursadas 
    (id_tiempo, id_sede, cantidad_cursadas_totales, cantidad_cursadas_aprobadas)
    SELECT 
        dt.id, 
        ds.id, 
        COUNT(*) as total,
        SUM(ec.aprobo) as aprobadas
    FROM DetalleCursada ec
    INNER JOIN LOS_GDDES.BI_DimTiempo dt ON dt.fecha = ec.fecha_inscripcion 
    INNER JOIN LOS_GDDES.BI_DimSede ds ON ds.detalle = (SELECT nombre FROM LOS_GDDES.Sede WHERE id = ec.id_sede_origen)
    GROUP BY dt.id, ds.id;
END
GO

-- SP 3: FINALES (AGRUPADO)
CREATE PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSFINALES AS
BEGIN
    -- 1. HechosFinales (Notas y Tiempos)
    INSERT INTO LOS_GDDES.BI_HechosFinales
    (id_tiempo, id_categoriaCurso, id_sede, id_rangoEtarioAlumno, cantidad_presentes, suma_notas, suma_tiempo_resolucion, cantidad_aprobados_con_tiempo)
    SELECT
        dt.id, dc.id, ds.id, dra.id,
        SUM(CASE WHEN ef.presente = 1 THEN 1 ELSE 0 END),
        SUM(ef.nota),
        SUM(CASE WHEN ef.nota >= 4 THEN DATEDIFF(DAY, c.fecha_inicio, f.fecha) ELSE 0 END),
        SUM(CASE WHEN ef.nota >= 4 THEN 1 ELSE 0 END)
    FROM LOS_GDDES.Evaluacion_final ef
    JOIN LOS_GDDES.Final f ON f.id = ef.id_final
    JOIN LOS_GDDES.Curso c ON c.codigo_curso = f.id_curso
    JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    JOIN LOS_GDDES.Alumno a ON a.legajo = ef.id_alumno
    JOIN LOS_GDDES.Persona p ON p.id = a.id_persona
    JOIN LOS_GDDES.BI_DimTiempo dt ON dt.fecha = f.fecha
    JOIN LOS_GDDES.BI_DimCategoriaCurso dc ON dc.detalle = cat.nombre
    JOIN LOS_GDDES.BI_DimSede ds ON ds.detalle = s.nombre
    JOIN LOS_GDDES.BI_DimRangoEtarioAlumno dra ON dra.detalle = 
        CASE WHEN DATEDIFF(YEAR, p.fecha_nacimiento, f.fecha) < 25 THEN '< 25'
             WHEN DATEDIFF(YEAR, p.fecha_nacimiento, f.fecha) BETWEEN 25 AND 35 THEN '25 - 35'
             WHEN DATEDIFF(YEAR, p.fecha_nacimiento, f.fecha) BETWEEN 36 AND 50 THEN '35 - 50'
             ELSE '> 50' END
    GROUP BY dt.id, dc.id, ds.id, dra.id;

    -- 2. Inscripciones a Final
    INSERT INTO LOS_GDDES.BI_HechosInscripcionesFinal (id_tiempo, id_sede, cantidad_inscriptos)
    SELECT dt.id, ds.id, COUNT(*)
    FROM LOS_GDDES.Inscripcion_final ifin
    JOIN LOS_GDDES.Final f ON f.id = ifin.id_final
    JOIN LOS_GDDES.Curso c ON c.codigo_curso = f.id_curso
    JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    JOIN LOS_GDDES.BI_DimTiempo dt ON dt.fecha = ifin.fecha_inscripcion
    JOIN LOS_GDDES.BI_DimSede ds ON ds.detalle = s.nombre
    GROUP BY dt.id, ds.id;
END
GO

-- SP 4: PAGOS (AGRUPADO)
CREATE PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.BI_HechosPagos 
    (id_tiempo, id_metodoPago, id_sede, cantidad_pagos, suma_importe_pagado, cantidad_pagos_fuera_termino)
    SELECT
        dt.id, dmp.id, ds.id, 
        COUNT(*) as cantidad_pagos,
        SUM(p.importe) as total_pagado,
        SUM(CASE WHEN p.fecha_pago > f.fecha_vencimiento THEN 1 ELSE 0 END) as fuera_termino
    FROM LOS_GDDES.Pago p
    INNER JOIN LOS_GDDES.Factura f ON f.numero_factura = p.nro_factura
    INNER JOIN LOS_GDDES.detalle_factura df ON df.id_factura = f.numero_factura
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = df.id_curso
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    INNER JOIN LOS_GDDES.MetodoDePago mp ON mp.id = p.id_metodoDePago
    INNER JOIN LOS_GDDES.BI_DimTiempo dt ON dt.fecha = p.fecha_pago
    INNER JOIN LOS_GDDES.BI_DimMetodoDePago dmp ON dmp.detalle = mp.descripcion
    INNER JOIN LOS_GDDES.BI_DimSede ds ON ds.detalle = s.nombre
    GROUP BY dt.id, dmp.id, ds.id;
END
GO

-- SP 5: FACTURACION (AGRUPADO)
CREATE OR ALTER PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Pre-calcular pagos por factura para evitar subquery en aggregate
    WITH PagosPorFactura AS (
        SELECT 
            p.nro_factura, 
            SUM(p.importe) AS total_pagado_factura
        FROM LOS_GDDES.Pago p
        GROUP BY p.nro_factura
    )
    
    -- 2. Insertar en BI usando la CTE
    INSERT INTO LOS_GDDES.BI_HechosFacturacion 
    (id_tiempo, id_categoriaCurso, id_sede, suma_monto_facturado, suma_monto_adeudado, cantidad_facturas_emitidas)
    SELECT
        dt.id, 
        dc.id, 
        ds.id, 
        
        -- Suma Monto Facturado
        SUM(df.monto),
        
        -- Suma Monto Adeudado
        -- Lógica: Monto Item - (Proporción Pagada)
        -- Proporción Pagada = (Monto Item / Total Factura) * Total Pagado
        SUM(
            df.monto - (
                ISNULL(ppf.total_pagado_factura, 0) 
                * (df.monto / NULLIF(f.monto_total, 0))
            )
        ),

        -- Cantidad de Facturas (Items)
        COUNT(*)

    FROM LOS_GDDES.detalle_factura df
    INNER JOIN LOS_GDDES.Factura f ON f.numero_factura = df.id_factura
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = df.id_curso
    INNER JOIN LOS_GDDES.Categoria cat ON cat.id = c.id_categoria
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    
    -- Join con CTE de Pagos
    LEFT JOIN PagosPorFactura ppf ON ppf.nro_factura = f.numero_factura

    -- Dimensiones
    INNER JOIN LOS_GDDES.BI_DimTiempo dt ON dt.fecha = f.fecha_emision
    INNER JOIN LOS_GDDES.BI_DimCategoriaCurso dc ON dc.detalle = cat.nombre
    INNER JOIN LOS_GDDES.BI_DimSede ds ON ds.detalle = s.nombre
    
    GROUP BY dt.id, dc.id, ds.id;
END
GO

-- SP 6: SATISFACCION (YA ESTABA AGRUPADO, OK)
CREATE PROCEDURE LOS_GDDES.SP_POBLAR_BI_HECHOSSATISFACCION
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LOS_GDDES.BI_HechosSatisfaccion
    (id_tiempo, id_sede, id_rangoProfesor, id_bloqueSatisfaccion, cantidad_respuestas)
    SELECT 
        dt.id, ds.id, drp.id, dbs.id, 
        COUNT(*) AS cantidad_respuestas
    FROM LOS_GDDES.Detalle_x_pregunta dp 
    INNER JOIN LOS_GDDES.Encuesta e ON e.id = dp.id_encuesta
    INNER JOIN LOS_GDDES.Curso c ON c.codigo_curso = e.id_curso
    INNER JOIN LOS_GDDES.Sede s ON s.id = c.id_sede
    INNER JOIN LOS_GDDES.Profesor prof ON prof.id = c.id_profesor
    INNER JOIN LOS_GDDES.Persona pp ON pp.id = prof.id_persona
    INNER JOIN LOS_GDDES.BI_DimTiempo dt ON dt.fecha = e.fecha_registro
    INNER JOIN LOS_GDDES.BI_DimSede ds ON ds.detalle = s.nombre
    INNER JOIN LOS_GDDES.BI_DimRangoEtarioProfesor drp ON drp.detalle = 
        CASE 
             WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, e.fecha_registro) BETWEEN 25 AND 35 THEN '25 - 35'
             WHEN DATEDIFF(YEAR, pp.fecha_nacimiento, e.fecha_registro) BETWEEN 36 AND 50 THEN '35 - 50'
             ELSE '> 50' END
    INNER JOIN LOS_GDDES.BI_DimBloqueSatisfaccion dbs ON dbs.detalle = 
        CASE 
             WHEN dp.respuesta BETWEEN 7 AND 10 THEN 'Satisfechos'
             WHEN dp.respuesta BETWEEN 5 AND 6 THEN 'Neutrales'
             ELSE 'Insatisfechos' END
    GROUP BY dt.id, ds.id, drp.id, dbs.id;
END
GO

/* ============================================================================================
   CREACIÓN DE VISTAS (KPIs ADAPTADOS A TABLAS AGRUPADAS)
   ============================================================================================ */

-- 1. TOP 3 CATEGORÍAS
CREATE VIEW LOS_GDDES.VW_Top3_Categorias_Turnos AS
WITH RankingData AS (
    SELECT 
        t.anio, s.detalle AS sede, c.detalle AS categoria, tu.detalle AS turno,
        SUM(h.cantidad_inscriptos - h.cantidad_rechazos) AS total_inscriptos, -- Usamos la resta de pre-calculados
        ROW_NUMBER() OVER (
            PARTITION BY t.anio, s.detalle 
            ORDER BY SUM(h.cantidad_inscriptos - h.cantidad_rechazos) DESC
        ) AS ranking
    FROM LOS_GDDES.BI_HechosInscripcionesCurso h
    JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
    JOIN LOS_GDDES.BI_DimSede s ON s.id = h.id_sede
    JOIN LOS_GDDES.BI_DimCategoriaCurso c ON c.id = h.id_categoriaCurso
    JOIN LOS_GDDES.BI_DimTurnoCurso tu ON tu.id = h.id_turnoCurso
    GROUP BY t.anio, s.detalle, c.detalle, tu.detalle
)
SELECT * FROM RankingData WHERE ranking <= 3;
GO

-- 2. TASA RECHAZO
CREATE VIEW LOS_GDDES.VW_Tasa_Rechazo AS
SELECT 
    t.anio, t.mes, s.detalle AS sede,
    SUM(h.cantidad_rechazos) * 100.0 / NULLIF(SUM(h.cantidad_inscriptos), 0) AS porcentaje_rechazo
FROM LOS_GDDES.BI_HechosInscripcionesCurso h
JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
JOIN LOS_GDDES.BI_DimSede s ON s.id = h.id_sede
GROUP BY t.anio, t.mes, s.detalle;
GO

-- 3. APROBACION CURSADA
CREATE VIEW LOS_GDDES.VW_Porcentaje_Aprobacion_Cursada AS
SELECT 
    t.anio, s.detalle AS sede,
    SUM(h.cantidad_cursadas_aprobadas) * 100.0 / NULLIF(SUM(h.cantidad_cursadas_totales), 0) AS porcentaje_aprobacion
FROM LOS_GDDES.BI_HechosCursadas h
JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
JOIN LOS_GDDES.BI_DimSede s ON s.id = h.id_sede
GROUP BY t.anio, s.detalle;
GO

-- 4. TIEMPO PROMEDIO
CREATE VIEW LOS_GDDES.VW_Tiempo_Promedio_Resolucion AS
SELECT 
    t.anio, c.detalle AS categoria,
    SUM(h.suma_tiempo_resolucion) * 1.0 / NULLIF(SUM(h.cantidad_aprobados_con_tiempo), 0) AS promedio_dias_resolucion
FROM LOS_GDDES.BI_HechosFinales h
JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
JOIN LOS_GDDES.BI_DimCategoriaCurso c ON c.id = h.id_categoriaCurso
GROUP BY t.anio, c.detalle;
GO

-- 5. NOTA PROMEDIO
CREATE VIEW LOS_GDDES.VW_Nota_Promedio_Finales AS
SELECT 
    t.anio, t.semestre, r.detalle AS rango_etario_alumno, c.detalle AS categoria,
    SUM(h.suma_notas) / NULLIF(SUM(h.cantidad_presentes), 0) AS nota_promedio
FROM LOS_GDDES.BI_HechosFinales h
JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
JOIN LOS_GDDES.BI_DimRangoEtarioAlumno r ON r.id = h.id_rangoEtarioAlumno
JOIN LOS_GDDES.BI_DimCategoriaCurso c ON c.id = h.id_categoriaCurso
GROUP BY t.anio, t.semestre, r.detalle, c.detalle;
GO

-- 6. AUSENTISMO
CREATE VIEW LOS_GDDES.VW_Tasa_Ausentismo_Finales AS
WITH Inscriptos AS (
    SELECT t.anio, t.semestre, h.id_sede, SUM(cantidad_inscriptos) as total_inscriptos
    FROM LOS_GDDES.BI_HechosInscripcionesFinal h
    JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
    GROUP BY t.anio, t.semestre, h.id_sede
),
Presentes AS (
    SELECT t.anio, t.semestre, h.id_sede, SUM(cantidad_presentes) as total_presentes
    FROM LOS_GDDES.BI_HechosFinales h
    JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
    GROUP BY t.anio, t.semestre, h.id_sede
)
SELECT 
    i.anio, i.semestre, s.detalle AS sede,
    (ISNULL(i.total_inscriptos, 0) - ISNULL(p.total_presentes, 0)) * 100.0 / NULLIF(i.total_inscriptos, 0) AS porcentaje_ausentismo
FROM Inscriptos i
LEFT JOIN Presentes p ON p.anio = i.anio AND p.semestre = i.semestre AND p.id_sede = i.id_sede
JOIN LOS_GDDES.BI_DimSede s ON s.id = i.id_sede;
GO

-- 7. DESVIO PAGOS
CREATE VIEW LOS_GDDES.VW_Desvio_Pagos AS
SELECT 
    t.anio, t.semestre,
    SUM(h.cantidad_pagos_fuera_termino) * 100.0 / NULLIF(SUM(h.cantidad_pagos), 0) AS porcentaje_pagos_fuera_termino
FROM LOS_GDDES.BI_HechosPagos h
JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
GROUP BY t.anio, t.semestre;
GO

-- 8. MOROSIDAD
CREATE VIEW LOS_GDDES.VW_Morosidad_Financiera AS
SELECT 
    t.anio, t.mes,
    SUM(h.suma_monto_adeudado) * 100.0 / NULLIF(SUM(h.suma_monto_facturado), 0) AS porcentaje_morosidad
FROM LOS_GDDES.BI_HechosFacturacion h
JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
GROUP BY t.anio, t.mes;
GO

-- 9. INGRESOS
CREATE VIEW LOS_GDDES.VW_Top3_Ingresos_Categoria AS
WITH RankingIngresos AS (
    SELECT 
        t.anio, s.detalle AS sede, c.detalle AS categoria,
        SUM(h.suma_monto_facturado - h.suma_monto_adeudado) AS ingresos_totales,
        ROW_NUMBER() OVER (
            PARTITION BY t.anio, s.detalle 
            ORDER BY SUM(h.suma_monto_facturado - h.suma_monto_adeudado) DESC
        ) AS ranking
    FROM LOS_GDDES.BI_HechosFacturacion h
    JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
    JOIN LOS_GDDES.BI_DimSede s ON s.id = h.id_sede
    JOIN LOS_GDDES.BI_DimCategoriaCurso c ON c.id = h.id_categoriaCurso
    GROUP BY t.anio, s.detalle, c.detalle
)
SELECT * FROM RankingIngresos WHERE ranking <= 3;
GO

-- 10. SATISFACCION
CREATE VIEW LOS_GDDES.VW_Indice_Satisfaccion AS
SELECT
    t.anio, s.detalle AS sede, rp.detalle AS rango_profesor,
    (
        (
            SUM(CASE WHEN b.detalle = 'Satisfechos' THEN h.cantidad_respuestas ELSE 0 END) * 100.0 
            / NULLIF(SUM(h.cantidad_respuestas), 0)
        ) - (
            SUM(CASE WHEN b.detalle = 'Insatisfechos' THEN h.cantidad_respuestas ELSE 0 END) * 100.0 
            / NULLIF(SUM(h.cantidad_respuestas), 0)
        ) + 100
    ) / 2.0 AS indice_satisfaccion
FROM LOS_GDDES.BI_HechosSatisfaccion h
JOIN LOS_GDDES.BI_DimTiempo t ON t.id = h.id_tiempo
JOIN LOS_GDDES.BI_DimSede s ON s.id = h.id_sede
JOIN LOS_GDDES.BI_DimRangoEtarioProfesor rp ON rp.id = h.id_rangoProfesor
JOIN LOS_GDDES.BI_DimBloqueSatisfaccion b ON b.id = h.id_bloqueSatisfaccion
GROUP BY t.anio, s.detalle, rp.detalle;
GO

/* ============================================================================================
   EJECUCIÓN DE MIGRACIÓN
   ============================================================================================ */

BEGIN TRANSACTION;
BEGIN TRY
    EXEC LOS_GDDES.SP_POBLAR_BI_TIEMPO;
    EXEC LOS_GDDES.SP_POBLAR_BI_DIMENSIONES_FIJAS;
    
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSINSCRIPCIONESCURSO;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSCURSADAS;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSFINALES;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSPAGOS;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSFACTURACION;
    EXEC LOS_GDDES.SP_POBLAR_BI_HECHOSSATISFACCION;

    COMMIT TRANSACTION;
    PRINT 'Migración BI Exitosa';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error en Migración: ' + ERROR_MESSAGE();
END CATCH
GO