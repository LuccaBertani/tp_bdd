---
trigger: always_on
---

This is a SQL 2022 project. The purpouse is to migrate an unnormalized table called 'Maestra' to my own schema normalized. 
Maestra table has this columns information:

[
  {
    "TableName": "Maestra",
    "ColumnName": "Institucion_Nombre",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Institucion_RazonSocial",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Institucion_Cuit",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Sede_Provincia",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Sede_Localidad",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Sede_Nombre",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Sede_Direccion",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Sede_Telefono",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Sede_Mail",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_Codigo",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_Nombre",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_Descripcion",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_Dia",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_FechaInicio",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_FechaFin",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_DuracionMeses",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_PrecioMensual",
    "DataType": "decimal"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_Provincia",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_Localidad",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_Dni",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_nombre",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_Apellido",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_FechaNacimiento",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_Mail",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_Direccion",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Profesor_Telefono",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Provincia",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Localidad",
    "DataType": "nvarchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Legajo",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Dni",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Nombre",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Apellido",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_FechaNacimiento",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Mail",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Direccion",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Alumno_Telefono",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_Categoria",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Curso_Turno",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Inscripcion_Numero",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Inscripcion_Fecha",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Inscripcion_Estado",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Inscripcion_FechaRespuesta",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Evaluacion_Curso_Nota",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Evaluacion_Curso_fechaEvaluacion",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Evaluacion_Curso_Instancia",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Evaluacion_Curso_Presente",
    "DataType": "bit"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Modulo_Nombre",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Modulo_Descripcion",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Trabajo_Practico_Nota",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Trabajo_Practico_FechaEvaluacion",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_FechaRegistro",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Observacion",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Pregunta1",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Nota1",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Pregunta2",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Nota2",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Pregunta3",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Nota3",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Pregunta4",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Encuesta_Nota4",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Inscripcion_Final_Fecha",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Inscripcion_Final_Nro",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Examen_Final_Fecha",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Examen_Final_Hora",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Examen_Final_Descripcion",
    "DataType": "varchar"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Evaluacion_Final_Nota",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Evaluacion_Final_Presente",
    "DataType": "bit"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Factura_FechaEmision",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Factura_FechaVencimiento",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Factura_Total",
    "DataType": "decimal"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Factura_Numero",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Detalle_Factura_Importe",
    "DataType": "decimal"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Periodo_Anio",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Periodo_Mes",
    "DataType": "bigint"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Pago_Fecha",
    "DataType": "datetime2"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Pago_Importe",
    "DataType": "decimal"
  },
  {
    "TableName": "Maestra",
    "ColumnName": "Pago_MedioPago",
    "DataType": "varchar"
  }
]

Maestra table is inside GD2C2025 schema and it's real path is GD2C2025.gd_esquema.Maestra