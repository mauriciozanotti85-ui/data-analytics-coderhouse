-- =====================================================================
-- M10 · Validación estadística del proyecto RetailPro
-- Motor utilizado: SQL Server (SSMS)
-- Nota SQL Server: PERCENTILE_CONT es una función de ventana y exige
-- OVER(). La forma "WITHIN GROUP (...)" sola, sin OVER, es de
-- PostgreSQL y en SSMS da error. Por eso abajo se usa SELECT DISTINCT
-- ... OVER ().
-- =====================================================================

USE tempdb;
GO

DROP TABLE IF EXISTS #ventas_semana;
DROP TABLE IF EXISTS #ventas;
GO


-- =====================================================================
-- PARTE 1 · Caso guiado: ventas diarias de dos sucursales (USD)
-- La columna venta es DECIMAL para que AVG no haga división entera.
-- =====================================================================

CREATE TABLE #ventas_semana (
    sucursal  VARCHAR(10)    NOT NULL,
    venta     DECIMAL(10,2)  NOT NULL
);

INSERT INTO #ventas_semana (sucursal, venta) VALUES
  ('Norte', 500), ('Norte', 510), ('Norte', 490), ('Norte', 505), ('Norte', 495),
  ('Sur',   100), ('Sur',   900), ('Sur',    50), ('Sur',  1200), ('Sur',   250);

-- 1.1 Media, rango y desviación estándar muestral (STDEV = muestral en SQL Server)
-- Se agrega el coeficiente de variación (desvío / media) para comparar
-- dispersión en términos relativos.
SELECT
    sucursal,
    CAST(AVG(venta)               AS DECIMAL(10,2)) AS media,
    MAX(venta) - MIN(venta)                         AS rango,
    CAST(STDEV(venta)             AS DECIMAL(10,2)) AS desvio_muestral,
    CAST(STDEV(venta) / AVG(venta) * 100 AS DECIMAL(10,1)) AS coef_variacion_pct
FROM #ventas_semana
GROUP BY sucursal
ORDER BY sucursal;
-- Resultado esperado:
--   Norte · media 500 · rango 20    · desvío 7,91   · CV 1,6%
--   Sur   · media 500 · rango 1.150 · desvío 518,41 · CV 103,7%


-- =====================================================================
-- PARTE 2 · Datos reales de RetailPro
-- Las 50 ventas de Fact_Ventas (dataset del dashboard de Power BI,
-- enero 2023 a julio 2024). total_venta = cantidad * precio * (1 - descuento).
-- =====================================================================

CREATE TABLE #ventas (
    id_venta         INT            NOT NULL PRIMARY KEY,
    fecha_venta      DATE           NOT NULL,
    id_cliente       INT            NOT NULL,
    id_producto      INT            NOT NULL,
    cantidad         INT            NOT NULL,
    precio_unitario  DECIMAL(10,2)  NOT NULL,
    descuento        DECIMAL(4,2)   NOT NULL,
    total_venta      DECIMAL(10,2)  NOT NULL,
    canal            VARCHAR(20)    NOT NULL
);

INSERT INTO #ventas (id_venta, fecha_venta, id_cliente, id_producto, cantidad,
                     precio_unitario, descuento, total_venta, canal) VALUES
  (1001, '2023-01-10', 1, 101, 2, 1200.00, 0.00, 2400.00, 'Online'),
  (1002, '2023-01-15', 2, 102, 5, 28.00, 0.00, 140.00, 'Presencial'),
  (1003, '2023-01-22', 3, 103, 1, 450.00, 0.05, 427.50, 'Online'),
  (1004, '2023-02-05', 4, 104, 3, 95.00, 0.00, 285.00, 'Presencial'),
  (1005, '2023-02-14', 5, 105, 2, 650.00, 0.00, 1300.00, 'Online'),
  (1006, '2023-02-28', 1, 106, 4, 120.00, 0.10, 432.00, 'Online'),
  (1007, '2023-03-08', 6, 107, 6, 45.00, 0.00, 270.00, 'Presencial'),
  (1008, '2023-03-15', 7, 108, 2, 85.00, 0.00, 170.00, 'Online'),
  (1009, '2023-03-22', 8, 109, 3, 130.00, 0.05, 370.50, 'Presencial'),
  (1010, '2023-04-03', 9, 110, 5, 60.00, 0.00, 300.00, 'Online'),
  (1011, '2023-04-18', 10, 111, 1, 1800.00, 0.00, 1800.00, 'Online'),
  (1012, '2023-04-25', 2, 101, 1, 1200.00, 0.00, 1200.00, 'Presencial'),
  (1013, '2023-05-06', 3, 102, 8, 28.00, 0.00, 224.00, 'Online'),
  (1014, '2023-05-20', 4, 103, 2, 450.00, 0.10, 810.00, 'Presencial'),
  (1015, '2023-05-30', 5, 104, 4, 95.00, 0.00, 380.00, 'Online'),
  (1016, '2023-06-08', 6, 105, 2, 650.00, 0.00, 1300.00, 'Presencial'),
  (1017, '2023-06-15', 7, 106, 3, 120.00, 0.05, 342.00, 'Online'),
  (1018, '2023-06-28', 8, 109, 2, 130.00, 0.00, 260.00, 'Online'),
  (1019, '2023-07-05', 9, 110, 6, 60.00, 0.00, 360.00, 'Presencial'),
  (1020, '2023-07-19', 10, 108, 3, 85.00, 0.00, 255.00, 'Online'),
  (1021, '2023-08-02', 1, 111, 2, 1800.00, 0.10, 3240.00, 'Online'),
  (1022, '2023-08-14', 2, 102, 10, 28.00, 0.00, 280.00, 'Presencial'),
  (1023, '2023-08-25', 3, 105, 1, 650.00, 0.00, 650.00, 'Online'),
  (1024, '2023-09-10', 4, 106, 5, 120.00, 0.05, 570.00, 'Presencial'),
  (1025, '2023-09-22', 5, 103, 3, 450.00, 0.00, 1350.00, 'Online'),
  (1026, '2023-10-04', 6, 101, 1, 1200.00, 0.00, 1200.00, 'Presencial'),
  (1027, '2023-10-18', 7, 107, 8, 45.00, 0.00, 360.00, 'Online'),
  (1028, '2023-11-06', 8, 104, 6, 95.00, 0.10, 513.00, 'Presencial'),
  (1029, '2023-11-20', 9, 109, 4, 130.00, 0.00, 520.00, 'Online'),
  (1030, '2023-12-05', 10, 111, 3, 1800.00, 0.00, 5400.00, 'Online'),
  (1031, '2023-12-15', 1, 110, 7, 60.00, 0.00, 420.00, 'Presencial'),
  (1032, '2023-12-28', 2, 105, 2, 650.00, 0.05, 1235.00, 'Online'),
  (1033, '2024-01-08', 3, 101, 2, 1200.00, 0.00, 2400.00, 'Online'),
  (1034, '2024-01-15', 4, 102, 6, 28.00, 0.00, 168.00, 'Presencial'),
  (1035, '2024-01-25', 5, 103, 1, 450.00, 0.00, 450.00, 'Online'),
  (1036, '2024-02-03', 6, 104, 4, 95.00, 0.10, 342.00, 'Presencial'),
  (1037, '2024-02-14', 7, 106, 3, 120.00, 0.00, 360.00, 'Online'),
  (1038, '2024-02-22', 8, 109, 2, 130.00, 0.05, 247.00, 'Online'),
  (1039, '2024-03-05', 9, 111, 1, 1800.00, 0.00, 1800.00, 'Presencial'),
  (1040, '2024-03-18', 10, 105, 3, 650.00, 0.00, 1950.00, 'Online'),
  (1041, '2024-03-28', 1, 107, 10, 45.00, 0.00, 450.00, 'Presencial'),
  (1042, '2024-04-06', 2, 108, 4, 85.00, 0.00, 340.00, 'Online'),
  (1043, '2024-04-20', 3, 110, 8, 60.00, 0.05, 456.00, 'Presencial'),
  (1044, '2024-05-04', 4, 101, 2, 1200.00, 0.00, 2400.00, 'Online'),
  (1045, '2024-05-18', 5, 103, 3, 450.00, 0.00, 1350.00, 'Presencial'),
  (1046, '2024-06-02', 6, 106, 5, 120.00, 0.10, 540.00, 'Online'),
  (1047, '2024-06-15', 7, 109, 3, 130.00, 0.00, 390.00, 'Presencial'),
  (1048, '2024-06-28', 8, 111, 2, 1800.00, 0.00, 3600.00, 'Online'),
  (1049, '2024-07-10', 9, 102, 12, 28.00, 0.00, 336.00, 'Presencial'),
  (1050, '2024-07-22', 10, 105, 2, 650.00, 0.05, 1235.00, 'Online');

SELECT COUNT(*) AS filas_cargadas, SUM(total_venta) AS total FROM #ventas;
-- Esperado: 50 filas · total 47.578,00


-- ---------------------------------------------------------------------
-- 2a · Ticket promedio real vs. representativo: media vs. mediana
-- ---------------------------------------------------------------------
SELECT DISTINCT
    CAST(AVG(total_venta) OVER ()                                   AS DECIMAL(10,2)) AS media,
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_venta)
         OVER ()                                                    AS DECIMAL(10,2)) AS mediana,
    CAST(STDEV(total_venta) OVER ()                                 AS DECIMAL(10,2)) AS desvio_muestral,
    MIN(total_venta) OVER ()                                                          AS minimo,
    MAX(total_venta) OVER ()                                                          AS maximo
FROM #ventas;
-- Esperado: media 951,56 · mediana 450,00 · desvío 1.041,76 · mín 140 · máx 5.400


-- ---------------------------------------------------------------------
-- 2b · Outliers con el método IQR
-- ---------------------------------------------------------------------
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta) OVER () AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta) OVER () AS q3
    FROM #ventas
)
SELECT
    CAST(q1                   AS DECIMAL(10,2)) AS q1,
    CAST(q3                   AS DECIMAL(10,2)) AS q3,
    CAST(q3 - q1              AS DECIMAL(10,2)) AS iqr,
    CAST(q1 - 1.5 * (q3 - q1) AS DECIMAL(10,2)) AS limite_inferior,
    CAST(q3 + 1.5 * (q3 - q1) AS DECIMAL(10,2)) AS limite_superior
FROM q;
-- Esperado: Q1 340,50 · Q3 1.283,75 · IQR 943,25
--           límite inferior -1.074,38 · límite superior 2.698,63

-- Registros fuera de los límites
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta) OVER () AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta) OVER () AS q3
    FROM #ventas
)
SELECT v.*,
       v.cantidad * v.precio_unitario * (1 - v.descuento) AS total_recalculado
FROM #ventas AS v
CROSS JOIN q
WHERE v.total_venta < q.q1 - 1.5 * (q.q3 - q.q1)
   OR v.total_venta > q.q3 + 1.5 * (q.q3 - q.q1)
ORDER BY v.total_venta DESC;
-- Esperado: 3 filas, todas del producto 111 (Laptop Gaming Pro), canal Online
--   1030 · 2023-12-05 · 3 u × 1.800       = 5.400
--   1048 · 2024-06-28 · 2 u × 1.800       = 3.600
--   1021 · 2023-08-02 · 2 u × 1.800 − 10% = 3.240
-- total_recalculado coincide con total_venta: no son errores de carga.


-- ---------------------------------------------------------------------
-- Control: media y mediana sin los outliers y por canal
-- ---------------------------------------------------------------------
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta) OVER () AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta) OVER () AS q3
    FROM #ventas
), sin_outliers AS (
    SELECT v.total_venta
    FROM #ventas AS v CROSS JOIN q
    WHERE v.total_venta BETWEEN q.q1 - 1.5 * (q.q3 - q.q1) AND q.q3 + 1.5 * (q.q3 - q.q1)
)
SELECT DISTINCT
    COUNT(*) OVER ()                                                                   AS ventas,
    CAST(AVG(total_venta) OVER ()                                    AS DECIMAL(10,2)) AS media_sin_outliers,
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_venta) OVER () AS DECIMAL(10,2)) AS mediana_sin_outliers
FROM sin_outliers;
-- Esperado: 47 ventas · media 751,87 · mediana 432,00

SELECT DISTINCT
    canal,
    COUNT(*) OVER (PARTITION BY canal)                                     AS ventas,
    CAST(AVG(total_venta) OVER (PARTITION BY canal)        AS DECIMAL(10,2)) AS media,
    CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_venta)
         OVER (PARTITION BY canal)                         AS DECIMAL(10,2)) AS mediana
FROM #ventas
ORDER BY canal;
-- Esperado: Online · 29 · media 1.191,98 · mediana 520,00
--           Presencial · 21 · media 619,55 · mediana 420,00
