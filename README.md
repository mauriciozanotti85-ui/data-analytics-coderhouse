Data Analytics · Coderhouse

Entregas del curso de Data Analytics. El proyecto integrador es RetailPro, una distribuidora de tecnología cuyo caso se trabaja módulo a módulo, desde el modelo de datos hasta el dashboard en Power BI.

Entregas
Módulo	Entrega	Archivo	Herramienta
M1	Brief analítico: definiendo el problema de negocio	Entregado en la plataforma (PDF)	—
M2	Diseño del modelo relacional: las tablas del proyecto	Entregado en la plataforma (PDF)	—
M3	Checkpoint: creación de la base Ventas_Tech_DB	RetailPro/ventas_tech_db.sql	SQL Server (SSMS)
M4	Pre-entrega: consultas SQL de negocio	RetailPro/m4_consultas_negocio.sql	SQL Server (SSMS)
M5	Pre-entrega: consultas con JOINs	RetailPro/m5_consultas_joins.sql	SQL Server (SSMS)
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

M5 · Consultas con JOINs
Vista base (INNER JOIN): cada venta con cliente, ciudad, producto y categoría. Es la fuente principal para Power BI.
Clientes sin ventas (LEFT JOIN + IS NULL).
Productos sin ventas (LEFT JOIN + IS NULL).
Consolidado por origen (UNION ALL) con una columna de texto creada en cada SELECT.

Incluye al inicio un cliente y un producto de prueba sin movimientos, para que las consultas 2 y 3 devuelvan resultados.

Cómo ejecutar los scripts
Abrir SQL Server Management Studio y conectarse al servidor local.
Ejecutar primero RetailPro/ventas_tech_db.sql, que crea la base y carga los datos.
Ejecutar después RetailPro/m4_consultas_negocio.sql y RetailPro/m5_consultas_joins.sql.

Motor utilizado: SQL Server 2019.
