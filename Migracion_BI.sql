--------------------------------------- Create BI views in LOS_GDDES schema --------------------------------------------------

--TODO migracion

-- Use GD2C2025 database
USE
GD2C2025
GO

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
CREATE VIEW VW_CategoriasTurnosMasSolicitados AS
SELECT TOP 3
    t.anio, s.detalle AS sede,
       c.detalle         AS categoria,
       tr.detalle        AS turno,
       SUM(h.inscriptos) AS total_inscriptos
FROM BI_HechosInscripcionesCurso h
         JOIN BI_Tiempo t ON h.id_tiempo = t.id
         JOIN BI_Sede s ON h.id_sede = s.id
         JOIN BI_CategoriaCurso c ON h.id_categoriaCurso = c.id
         JOIN BI_TurnoCurso tr ON h.id_turnoCurso = tr.id
GROUP BY t.anio, s.detalle, c.detalle, tr.detalle
ORDER BY SUM(h.inscriptos) DESC
GO

/*
Tasa de rechazo de inscripciones:
Porcentaje de inscripciones rechazadas por mes por sede (sobre el total de inscripciones).
*/
CREATE VIEW VW_TasaRechazoInscripciones AS
SELECT t.mes,
       s.detalle                                                    AS sede,
       SUM(h.rechazados) * 1.0 / NULLIF(SUM(h.inscriptos), 0) * 100 AS tasa_rechazo
FROM BI_HechosInscripcionesCurso h
         JOIN BI_Tiempo t ON h.id_tiempo = t.id
         JOIN BI_Sede s ON h.id_sede = s.id
GROUP BY t.mes, s.detalle
GO

/*
Comparación de desempeño de cursada por sede:
Porcentaje de aprobación de cursada por sede, por año.
Se considera aprobada la cursada de un alumno cuando tiene nota mayor o igual a 4 en todos los módulos y el TP. TODO: Agregar esta validacion en la migracion de los datos
*/
CREATE VIEW VW_DesempenioCursadaPorSede AS
SELECT t.anio,
       s.detalle                                                              AS sede,
       COUNT(*)                                                               AS total_cursadas,
       SUM(CASE WHEN h.aprobado = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS porcentaje_aprobacion
FROM BI_HechosCursadas h
         JOIN BI_Tiempo t ON h.id_tiempo = t.id
         JOIN BI_Sede s ON h.id_sede = s.id
GROUP BY t.anio, s.detalle
GO

/*
Tiempo promedio de finalización de curso:
Tiempo promedio entre el inicio del curso y la aprobación del final según la categoría de los cursos,
por año. (Tener en cuenta el año de inicio del curso) TODO: Agregar carga del campo fecha_inicio y fecha_finalizacion en la migracion de los datos
*/
CREATE VIEW VW_TiempoPromedioFinalizacion AS
SELECT c.detalle                                                AS categoria,
       AVG(DATEDIFF(day, h.fecha_inicio, h.fecha_finalizacion)) AS dias_promedio
FROM BI_HechosCursadas h
         JOIN BI_CategoriaCurso c ON h.id_categoriaCurso = c.id
GROUP BY c.detalle
GO

/*
Nota promedio de finales.
Promedio de nota de finales según el rango etario del alumno y la categoría del curso por semestre. TODO: Agregar distincion de rango etario del alumno en la migracion de los datos
*/
CREATE VIEW VW_NotaPromedioFinales AS
SELECT t.semestre,
       c.detalle         AS categoria,
       r.detalle         AS rango_etario,
       AVG(h.nota_final) AS nota_promedio
FROM BI_HechosCursadas h
         JOIN BI_Tiempo t ON h.id_tiempo = t.id
         JOIN BI_CategoriaCurso c ON h.id_categoriaCurso = c.id
         JOIN BI_RangoEtarioAlumno r ON h.id_rangoAlumno = r.id
WHERE h.nota_final IS NOT NULL
GROUP BY t.semestre, c.detalle, r.detalle
GO

/*
Tasa de ausentismo finales:
Porcentaje de ausentes a finales (sobre la cantidad de inscriptos) por semestre por sede.
*/
CREATE VIEW VW_TasaAusentismoFinales AS
SELECT t.semestre,
       s.detalle                                                  AS sede,
       SUM(h.ausentes) * 1.0 / NULLIF(SUM(h.inscriptos), 0) * 100 AS tasa_ausentismo
FROM BI_HechosInscripcionesFinal h
         JOIN BI_Tiempo t ON h.id_tiempo = t.id
         JOIN BI_Sede s ON h.id_sede = s.id
GROUP BY t.semestre, s.detalle
GO

/*
Desvío de pagos: Porcentaje de pagos realizados fuera de término por semestre. TODO: Cargar el booleano de pago fuera de termino en la migracion de los datos.
*/
CREATE VIEW VW_DesvioPagos AS
SELECT t.semestre,
       s.detalle            AS sede,
       SUM(CASE WHEN h.pago_fuera_termino = 1 THEN 1 ELSE 0 END) * 1.0
           / COUNT(*) * 100 AS porcentaje_fuera_termino
FROM BI_HechosPagos h
         JOIN BI_Tiempo t ON h.id_tiempo = t.id
         JOIN BI_Sede s ON h.id_sede = s.id
GROUP BY t.semestre, s.detalle
GO

/*
Tasa de Morosidad Financiera mensual.
Se calcula teniendo en cuenta el total de importes adeudados sobre facturación esperada en el mes.
El monto adeudado se obtiene a partir de las facturas que no tengan pago registrado en dicho mes.
*/
CREATE VIEW VW_TasaMorosidadMensual AS
SELECT t.mes,
       (SUM(f.monto_facturado - f.monto_pagado) * 1.0 / NULLIF(SUM(f.monto_facturado), 0)) * 100 AS tasa_morosidad
FROM BI_HechosFacturacion f
         JOIN BI_Tiempo t ON f.id_tiempo = t.id
GROUP BY t.mes
GO

/*
Ingresos por categoría de cursos: Las 3 categorías de cursos que generan mayores ingresos por sede, por año.
*/
CREATE VIEW VW_IngresosPorCategoria AS
SELECT TOP 3
        t.anio,
        s.detalle           AS sede,
        c.detalle           AS categoria,
        SUM(f.monto_pagado) AS ingresos
FROM BI_HechosFacturacion f
         JOIN BI_Tiempo t ON f.id_tiempo = t.id
         JOIN BI_Sede s ON f.id_sede = s.id
         JOIN BI_CategoriaCurso c ON f.id_categoriaCurso = c.id
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
CREATE VIEW VW_IndiceSatisfaccion AS
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

FROM BI_HechosCursadas h
         JOIN BI_Tiempo t ON h.id_tiempo = t.id
         JOIN BI_Sede s ON h.id_sede = s.id
         JOIN BI_RangoEtarioProfesor r ON h.id_rangoProfesor = r.id
         JOIN BI_BloqueSatisfaccion b ON h.id_satisfaccion = b.id
GROUP BY t.anio, s.detalle, r.detalle
GO

--------------------------------------- Views Created Successfully --------------------------------------------------

