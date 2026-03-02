--Calculate the Potential Revenue for Every Product
WITH
	PRODUCTREVENUE AS (
		SELECT
			CATEGORY,
			PRODUCT,
			AVAILABLE_QUANTITY,
			DISCOUNTED_SELLING_PRICE,
			(AVAILABLE_QUANTITY * DISCOUNTED_SELLING_PRICE) AS POTENTIAL_REVENUE
		FROM
			PRODUCT_LEVEL_INVENTORY
		WHERE
			OUT_OF_STOCK = 'FALSE'
	)
SELECT
	*
FROM
	PRODUCTREVENUE
ORDER BY
	POTENTIAL_REVENUE DESC;


--Rank Products by Revenue Within Each Category

SELECT
	CATEGORY,
	PRODUCT,
	DISCOUNTED_SELLING_PRICE * QUANTITY AS SELLING_WISE_PRODUCT_REVENUE,
	DENSE_RANK() OVER (
		PARTITION BY
			CATEGORY
		ORDER BY
			DISCOUNTED_SELLING_PRICE * QUANTITY DESC
	) AS CATEGORY_RANK
FROM
	PRODUCT_LEVEL_INVENTORY
WHERE
	OUT_OF_STOCK = 'FALSE';

--Extract Only the Top 3 Products Per Category
 
WITH
	RANKED_PRODUCTS AS (
		SELECT
			CATEGORY,
			PRODUCT,
			DISCOUNTED_SELLING_PRICE * QUANTITY AS SELLING_WISE_PRODUCT_REVENUE,
			DENSE_RANK() OVER (
				PARTITION BY
					CATEGORY
				ORDER BY
					DISCOUNTED_SELLING_PRICE * QUANTITY DESC
			) AS CATEGORY_RANK
		FROM
			PRODUCT_LEVEL_INVENTORY
		WHERE
			OUT_OF_STOCK = 'FALSE'
	)
SELECT
	*
FROM
	RANKED_PRODUCTS
WHERE
	CATEGORY_RANK <= 3
ORDER BY
	CATEGORY,
	CATEGORY_RANK asc;


--Category Concentration

SELECT
	CATEGORY,
	SUM(DISCOUNTED_SELLING_PRICE * QUANTITY) AS CATEGORY_WISE_REVENUE
FROM
	PRODUCT_LEVEL_INVENTORY
WHERE
	OUT_OF_STOCK = 'TRUE'
GROUP BY
	CATEGORY
ORDER BY
	CATEGORY_WISE_REVENUE DESC;


-- % revenue contribution of each product to its category

WITH
	PRODUCT_REVENUE AS (
		SELECT
			CATEGORY,
			PRODUCT,
			(DISCOUNTED_SELLING_PRICE * AVAILABLE_QUANTITY) AS EACH_PRODUCT_REVENUE
		FROM
			PRODUCT_LEVEL_INVENTORY
	)
SELECT
	CATEGORY,
	PRODUCT,
	EACH_PRODUCT_REVENUE,
	SUM(EACH_PRODUCT_REVENUE) OVER (
		PARTITION BY
			CATEGORY
	) AS CATEGORY_WISE_TOTAL_REVENUE,
	ROUND(
		(
			EACH_PRODUCT_REVENUE * 100.0 / NULLIF(
				SUM(EACH_PRODUCT_REVENUE) OVER (
					PARTITION BY
						CATEGORY
				),
				0
			)
		),
		2
	) AS REVENUE_CONTRIBUTION_EACH_PRODUCT
FROM
	PRODUCT_REVENUE
ORDER BY
	CATEGORY,
	REVENUE_CONTRIBUTION_EACH_PRODUCT DESC;



--Inventory Risk Model...where the business is bleeding money

select product,category,mrp,discount_percent,available_quantity,out_of_stock from PRODUCT_LEVEL_INVENTORY 
where discount_percent>20
      and available_quantity<5
	  and out_of_stock = 'FALSE'
	  order by discount_percent desc;
	 

--Inventory Risk Model - "Luxury Anchors" (High MRP + Low Demand Proxy)

SELECT *
FROM (
    SELECT
        category,
        product,
        mrp,
        available_quantity,
        discount_percent,
        AVG(mrp) OVER (PARTITION BY category) AS category_avg_mrp
    FROM product_level_inventory
) 
WHERE
    mrp > category_avg_mrp
    AND available_quantity>2
    AND discount_percent >30
	ORDER BY available_quantity DESC;




                                     --Margin Leakage
									 
--High discount + low stock products

SELECT
	CATEGORY,
	PRODUCT,
	MRP,
	DISCOUNT_PERCENT,
	AVAILABLE_QUANTITY
FROM
	PRODUCT_LEVEL_INVENTORY
WHERE
	DISCOUNT_PERCENT > 15
	AND AVAILABLE_QUANTITY < 3
	AND OUT_OF_STOCK = 'FALSE'
ORDER BY
	DISCOUNT_PERCENT DESC;

