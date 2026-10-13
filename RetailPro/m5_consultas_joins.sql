-- =====================================================================
-- M5 · Consultas con JOINs
-- Base: Ventas_Tech_DB (esquema del Checkpoint M3)
-- Motor utilizado: SQL Server (SSMS)
-- Tablas: ventas (hechos) · clientes · productos · categorias (dimensiones)
-- Requiere haber ejecutado antes ventas_tech_db.sql.
-- =====================================================================

USE Ventas_Tech_DB;
GO


-- =====================================================================
-- DATOS DE PRUEBA PARA LAS CONSULTAS 2 Y 3
-- En la carga del M3 todos los clientes compraron y todos los productos
-- se vendieron, así que las consultas 2 y 3 devolverían 0 filas. Para
-- poder verificarlas se agrega un cliente sin compras y un producto sin
-- ventas. El IF NOT EXISTS evita duplicarlos si el script se corre de
-- nuevo, y no altera la tabla ventas.
-- =====================================================================

IF NOT EXISTS (SELECT 1 FROM clientes WHERE id_cliente = 6)
    INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro)
    VALUES (6, 'Sofía Díaz', 'sofia@mail.com', 'Salta', '2024-03-20');

IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = 7)
    INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
    VALUES (7, 'Webcam Full HD', 2, 65.00, 25, 1);
GO


-- =====================================================================
-- CONSULTA 1 · Vista base del proyecto (INNER JOIN)
-- Una fila por venta con los datos del cliente, el producto y su
-- categoría. Es la fuente principal para Power BI:
--   · para agrupar: categoria, ciudad_cliente, producto
--   · para filtrar: fecha_venta, categoria, ciudad_cliente
-- =====================================================================

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre                           AS cliente,
    c.ciudad                           AS ciudad_cliente,
    p.id_producto,
    p.nombre_producto                  AS producto,
    cat.nombre_categoria               AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario     AS total_venta
FROM ventas AS v
INNER JOIN clientes   AS c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  AS p   ON v.id_producto  = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;


-- =====================================================================
-- CONSULTA 2 · Clientes sin ventas (LEFT JOIN)
-- Clientes registrados que todavía no hicieron ninguna compra (para CRM).
-- =====================================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;


-- =====================================================================
-- CONSULTA 3 · Productos sin ventas (LEFT JOIN)
-- Artículos del catálogo sin ninguna venta registrada (para producto).
-- =====================================================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria  AS categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas     AS v   ON p.id_producto  = v.id_producto
LEFT JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL
ORDER BY p.precio DESC;


-- =====================================================================
-- CONSULTA 4 · Consolidado por origen (UNION ALL)
-- La columna "origen" no existe en las tablas: se crea como texto fijo
-- en cada SELECT. El criterio de corte es el período de la venta:
--   · Primera quincena: ventas hasta el 10/03/2024
--   · Segunda quincena: ventas desde el 11/03/2024
-- Los dos filtros son complementarios, así que cada venta se cuenta una
-- sola vez. Se usa UNION ALL para no eliminar filas que coincidan en
-- todos sus valores.
-- =====================================================================

SELECT
    origen,
    COUNT(*)    AS cantidad_ventas,
    SUM(total)  AS total_origen
FROM (
    SELECT v.fecha_venta, v.cantidad * v.precio_unitario AS total, 'Primera quincena' AS origen
    FROM ventas AS v
    WHERE v.fecha_venta <  '2024-03-11'

    UNION ALL

    SELECT v.fecha_venta, v.cantidad * v.precio_unitario AS total, 'Segunda quincena' AS origen
    FROM ventas AS v
    WHERE v.fecha_venta >= '2024-03-11'
) AS consolidado
GROUP BY origen
ORDER BY origen;


-- =====================================================================
-- RESULTADOS OBTENIDOS
-- =====================================================================
-- Consulta 1: 10 filas, una por venta, del 05/03 al 15/03/2024.
--             La suma de total_venta da $6.444, igual que en el M4.
-- Consulta 2: 1 fila → Sofía Díaz · sofia@mail.com · 2024-03-20
-- Consulta 3: 1 fila → Webcam Full HD · Accesorios · 65.00
-- Consulta 4: 2 filas
--             Primera quincena · 5 ventas · $3.620
--             Segunda quincena · 5 ventas · $2.824
--             Total: $6.444, sin ventas duplicadas ni perdidas.
