Data Analytics · Coderhouse

Entregas del curso de Data Analytics. El proyecto integrador es RetailPro, una distribuidora de tecnología cuyo caso se trabaja módulo a módulo, desde el modelo de datos hasta el dashboard en Power BI.

Entregas
Módulo	Entrega	Archivo	Herramienta
M1	Brief analítico: definiendo el problema de negocio	Entregado en la plataforma (PDF)	—
M2	Diseño del modelo relacional: las tablas del proyecto	Entregado en la plataforma (PDF)	—
M3	Checkpoint: creación de la base Ventas_Tech_DB	Modulo_3/ventas_tech_db.sql	SQL Server (SSMS)
M4	Pre-entrega: consultas SQL de negocio	RetailPro/m4_consultas_negocio.sql	SQL Server (SSMS)
Detalle
M3 · Ventas_Tech_DB

Script repetible con cuatro secciones: DROP, CREATE, INSERT y VALIDACIÓN. Crea las tablas categorias, clientes, productos y ventas, carga 25 registros y valida 4, 5, 6 y 10 filas.

M4 · Consultas de negocio

Cuatro consultas sobre la tabla ventas:

Resumen ejecutivo mensual: total facturado, pedidos y ticket promedio.
Top 5 de productos por facturación.
Clientes recurrentes (más de un pedido).
Meses por encima o por debajo del promedio mensual.

Al final del archivo hay un bloque con tres hallazgos sobre los resultados.

Cómo ejecutar los scripts
Abrir SQL Server Management Studio y conectarse al servidor local.
Ejecutar primero Modulo_3/ventas_tech_db.sql, que crea la base y carga los datos.
Ejecutar después RetailPro/m4_consultas_negocio.sql.

Motor utilizado: SQL Server 2019.
