
---QUERY 1
---La query trae los ingresos totales por ventas de cada categoria por mes 
WITH ventas_mensuales AS (
	SELECT c.nombre_categoria,  
			DATE_TRUNC('month', v.fecha) AS mes,
			SUM(v.cantidad * p.precio) AS total_ventas
	FROM ventas v
	INNER JOIN productos p
		ON p.producto_id=v.producto_id

	INNER JOIN categorias c
		ON p.id_categoria= c.categoria_id

	GROUP BY 
	 		c.nombre_categoria,
	 		DATE_TRUNC('month', fecha)
)
SELECT *
FROM ventas_mensuales
ORDER BY mes;

---QUERY 2
---La query trae los ingresos totales por ventas de cada categoria por mes,
---lo ordena por la categoria que mas ingreso genero por mes y realiza una suma
---acumulativa de los ingresos de cada categoria.
WITH ventas_mensuales AS (
    SELECT
        c.nombre_categoria,
        DATE_TRUNC('month', v.fecha) AS mes,
        SUM(v.cantidad * p.precio) AS total_ventas

    FROM ventas v

    INNER JOIN productos p
        ON p.producto_id = v.producto_id

    INNER JOIN categorias c
        ON p.id_categoria = c.categoria_id

    GROUP BY
        c.nombre_categoria,
        DATE_TRUNC('month', v.fecha)
),

metricas_ventana AS (
    SELECT
        nombre_categoria,
        mes,
        total_ventas,

        RANK() OVER (
            PARTITION BY mes
            ORDER BY total_ventas DESC
        ) AS ranking_mensual,

        SUM(total_ventas) OVER (
            PARTITION BY nombre_categoria
            ORDER BY mes
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS ventas_acumuladas

    FROM ventas_mensuales
)

SELECT *
  
FROM metricas_ventana
ORDER BY mes, ranking_mensual;

---QUERY 3
---La query trae los ingresos totales por ventas de cada categoria por mes,
---lo ordena por la categoria que mas ingreso genero por mes y realiza una suma
---acumulativa de los ingresos de cada categoria.
---Y para finalizar muestra el estado de ventas,clasificandolos entre exitoso o bajo de promedio
---dependiendo si genero mas ingresos que las ventas promedios.
WITH ventas_mensuales AS (
    SELECT
        c.nombre_categoria,
        DATE_TRUNC('month', v.fecha) AS mes,
        SUM(v.cantidad * p.precio) AS total_ventas
    FROM ventas v

    INNER JOIN productos p
        ON p.producto_id = v.producto_id

    INNER JOIN categorias c
        ON p.id_categoria = c.categoria_id

    GROUP BY
        c.nombre_categoria,
        DATE_TRUNC('month', v.fecha)
),

metricas_ventana AS (
    SELECT
        nombre_categoria,
        mes,
        total_ventas,

        RANK() OVER (
            PARTITION BY mes
            ORDER BY total_ventas DESC
        ) AS ranking_mensual,

        SUM(total_ventas) OVER (
            PARTITION BY nombre_categoria
            ORDER BY mes
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS ventas_acumuladas

    FROM ventas_mensuales
)

SELECT
    nombre_categoria,
    mes,
    total_ventas,
    ranking_mensual,
    ventas_acumuladas,

    CASE
        WHEN total_ventas >= AVG(total_ventas) OVER (
            PARTITION BY nombre_categoria
        )
        THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS estado_venta

FROM metricas_ventana
ORDER BY mes, ranking_mensual;

