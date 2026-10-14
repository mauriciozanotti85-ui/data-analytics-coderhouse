# Data Analytics · Coderhouse

Entregas del curso de Data Analytics. El proyecto integrador es **RetailPro**, una distribuidora de tecnología cuyo caso se trabaja módulo a módulo, desde el modelo de datos hasta el dashboard en Power BI.

## Entregas

| Módulo | Entrega | Archivo | Herramienta |
| --- | --- | --- | --- |
| M1 | Brief analítico: definiendo el problema de negocio | Entregado en la plataforma (PDF) | — |
| M2 | Diseño del modelo relacional: las tablas del proyecto | Entregado en la plataforma (PDF) | — |
| M3 | Checkpoint: creación de la base `Ventas_Tech_DB` | [`RetailPro/ventas_tech_db.sql`](RetailPro/ventas_tech_db.sql) | SQL Server (SSMS) |
| M4 | Pre-entrega: consultas SQL de negocio | [`RetailPro/m4_consultas_negocio.sql`](RetailPro/m4_consultas_negocio.sql) | SQL Server (SSMS) |
| M5 | Pre-entrega: consultas con JOINs | [`RetailPro/m5_consultas_joins.sql`](RetailPro/m5_consultas_joins.sql) | SQL Server (SSMS) |
| M6 | Práctica: Pipeline ETL | [`PowerBI/Pipeline_ETL_Zanotti_Mauricio.pbix`](PowerBI/Pipeline_ETL_Zanotti_Mauricio.pbix) | Power BI (Power Query) |
| M7 | Pre-entrega: boceto del dashboard | Entregado en la plataforma (PNG) | — |
| M7 | Checkpoint 2: modelo, calendario y medidas DAX | [`PowerBI/Zanotti_Mauricio_Checkpoint2.pbix`](PowerBI/Zanotti_Mauricio_Checkpoint2.pbix) | Power BI (DAX) |

## Detalle

### M3 · Ventas_Tech_DB
Script repetible con cuatro secciones: `DROP`, `CREATE`, `INSERT` y `VALIDACIÓN`. Crea las tablas `categorias`, `clientes`, `productos` y `ventas`, carga 25 registros y valida 4, 5, 6 y 10 filas.

### M4 · Consultas de negocio
Cuatro consultas sobre la tabla `ventas`:
1. Resumen ejecutivo mensual: total facturado, pedidos y ticket promedio.
2. Top 5 de productos por facturación.
3. Clientes recurrentes (más de un pedido).
4. Meses por encima o por debajo del promedio mensual.

Al final del archivo hay un bloque con tres hallazgos sobre los resultados.

### M5 · Consultas con JOINs
1. Vista base (INNER JOIN): cada venta con cliente, ciudad, producto y categoría. Es la fuente principal para Power BI.
2. Clientes sin ventas (LEFT JOIN + IS NULL).
3. Productos sin ventas (LEFT JOIN + IS NULL).
4. Consolidado por origen (UNION ALL) con una columna de texto creada en cada SELECT.

Incluye al inicio un cliente y un producto de prueba sin movimientos, para que las consultas 2 y 3 devuelvan resultados.

### Pipeline ETL (Power Query)
Cuatro consultas con nomenclatura `Dim_` / `Fact_`: Dim_Clientes (11 filas), Dim_Productos (12), Dim_Categorias (4) y Fact_Ventas (50). Se eliminan filas vacías y duplicados por clave, se corrigen tipos, se tratan los nulos (email y ciudad a "Sin datos", precio imputado, categoría asignada) y se combina Fact_Ventas con Dim_Productos.

### Checkpoint 2 · Modelo de datos y DAX
- Modelo estrella con cuatro relaciones 1:N de dirección única: Dim_Clientes, Dim_Productos y Dim_Fechas hacia Fact_Ventas, y Dim_Categorias hacia Dim_Productos (se agregó `id_categoria` a Dim_Productos con un Merge por nombre).
- `Dim_Fechas` creada con `CALENDAR`, con columnas Año, Mes Número, Mes Nombre (ordenado por Mes Número), Trimestre y Semana, y marcada como tabla de fechas.
- Tabla `_Medidas` con cinco medidas: Total Ventas, Ventas Online (CALCULATE), Ventas YTD (TOTALYTD), Ventas LY (SAMEPERIODLASTYEAR) y % Crecimiento Anual (VAR + DIVIDE).
- Página **Validación** con una matriz Mes × Año: el YTD acumula mes a mes, Ventas LY queda en blanco en 2023 y en 2024 muestra los valores de 2023. Crecimiento enero–julio 2024 vs. 2023: 44,43%.

## Cómo ejecutar los scripts
1. Abrir SQL Server Management Studio y conectarse al servidor local.
2. Ejecutar primero `RetailPro/ventas_tech_db.sql`, que crea la base y carga los datos.
3. Ejecutar después `RetailPro/m4_consultas_negocio.sql` y `RetailPro/m5_consultas_joins.sql`.

Motor utilizado: SQL Server 2019.

## Cómo abrir los archivos de Power BI
Los `.pbix` de la carpeta `PowerBI` leen el Excel `Pipeline_ETL_Dataset.xlsx` desde la ruta de la PC donde se crearon. Al abrirlos en otra computadora:
1. En Power BI Desktop: **Inicio > Transformar datos (flecha) > Configuración de origen de datos**.
2. Seleccionar la ruta anterior, **Cambiar origen… > Examinar** y elegir el Excel en su ubicación nueva.
3. **Aplicar cambios** o **Actualizar**.
