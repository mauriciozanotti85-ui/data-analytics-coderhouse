-- =====================================================================
-- M4 · Consultas SQL de negocio
-- Base: Ventas_Tech_DB (creada en M3)
-- Motor utilizado: SQL Server (SSMS)
-- Tabla de trabajo: ventas
--   (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta)
-- Cada fila de ventas es un pedido; el importe se calcula como
-- cantidad * precio_unitario.
-- =====================================================================

USE Ventas_Tech_DB;
GO


-- =====================================================================
-- CONSULTA 1 · Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
-- Se agrupa también por año para no mezclar el mismo mes de años distintos.
-- =====================================================================

SELECT
    YEAR(fecha_venta)                                       AS anio,
    MONTH(fecha_venta)                                      AS mes,
    SUM(cantidad * precio_unitario)                         AS total_facturado,
    COUNT(*)                                                AS cantidad_pedidos,
    CAST(AVG(cantidad * precio_unitario) AS DECIMAL(10,2))  AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;


-- =====================================================================
-- CONSULTA 2 · Ranking de productos
-- Top 5 de productos por total facturado, con las unidades vendidas.
-- =====================================================================

SELECT TOP 5
    id_producto,
    SUM(cantidad)                    AS unidades_vendidas,
    SUM(cantidad * precio_unitario)  AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- =====================================================================
-- CONSULTA 3 · Clientes recurrentes
-- Clientes con más de un pedido, con la cantidad de pedidos y el total gastado.
-- =====================================================================

SELECT
    id_cliente,
    COUNT(*)                         AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)  AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- =====================================================================
-- CONSULTA 4 · Meses por encima / por debajo del promedio
-- Total facturado por mes y su comparación contra el promedio mensual
-- general. Si un mes coincide exactamente con el promedio se etiqueta
-- 'En el promedio', para no forzarlo a uno de los dos lados.
-- =====================================================================

WITH facturacion_mensual AS (
    SELECT
        YEAR(fecha_venta)                AS anio,
        MONTH(fecha_venta)               AS mes,
        SUM(cantidad * precio_unitario)  AS total_facturado
    FROM ventas
    GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
)
SELECT
    anio,
    mes,
    total_facturado,
    CAST((SELECT AVG(total_facturado) FROM facturacion_mensual) AS DECIMAL(10,2)) AS promedio_mensual,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM facturacion_mensual) THEN 'Por debajo'
        ELSE 'En el promedio'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY anio, mes;


-- =====================================================================
-- HALLAZGOS
-- =====================================================================
-- 1. Un solo producto sostiene más de la mitad del negocio: el producto 1
--    facturó $3.600 de un total de $6.444 (55,9%). Junto con el producto 3
--    concentran el 76,8%. Ambos son de la categoría Computación, así que
--    una baja en esa categoría impactaría de lleno en la facturación.
--
-- 2. Volumen no es igual a facturación: el producto 2 es el más vendido en
--    unidades (13, más que todos los demás) pero facturó solo $364 (5,6%)
--    y queda quinto en el ranking por su precio bajo ($28).
--
-- 3. Los 5 clientes son recurrentes (2 pedidos cada uno), pero el gasto
--    está muy concentrado: los clientes 1 y 5 suman $4.740, el 73,6% de la
--    facturación, porque fueron los que compraron el producto 1. Perder a
--    uno de ellos tendría mucho más impacto que perder a cualquiera de los
--    otros tres.
--
-- Nota: todas las ventas de la base son de marzo de 2024, por lo que las
-- consultas 1 y 4 devuelven un único mes ($6.444, 10 pedidos, ticket
-- promedio $644,40). Con un solo mes no hay comparación posible: el mes
-- coincide con el promedio. Las consultas quedan listas para cuando la
-- base tenga más meses de historia.
