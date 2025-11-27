# Correcciones hechas por la catedra

### El script arroja un error. Se adjunta resultado.
```txt
Mens. 208, Nivel 16, Estado 1, Línea 4
El nombre de objeto 'LOS_GDDES.BI_HechosPagos' no es válido.

Hora de finalización: 2025-11-26T20:04:17.5908111-03:00
```

### No es correcto tener cada pago en la tabla de hechos de Pagos.
La información para el modelo de BI debe estar agrupada y pre calculada
en función de las dimensiones correspondientes.

### No es correcta la tabla de hechos de Cursada.
- La información debe estar agrupada y pre calculada en función de las dimensiones
correspondientes. La fecha de inicio y de fin no son campos pre
calculados o agrupados. 
- La información de satisfacción corresponde a
las encuestas y puede estar separada en otra tabla de hechos. 
- La información de finales corresponde al hecho de final.