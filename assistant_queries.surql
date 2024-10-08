// Query 108
SELECT * FROM product WHERE id IN (SELECT VALUE out FROM review WHERE rating = 5);

// Query 109
SELECT name, email FROM seller WHERE id IN (SELECT VALUE seller FROM product WHERE category = 'Electronics');

// Query 110
SELECT * FROM order WHERE quantity < 5;

// Query 111
SELECT * FROM product WHERE 'M' IN sizes OR 'L' IN sizes;

// Query 112
SELECT out.seller AS seller_id, math::sum(price * quantity) AS total_revenue FROM order GROUP BY seller_id;

// Query 113
SELECT array::distinct(in) AS person_ids FROM review WHERE time.created_at >= time::now() - 30d GROUP ALL;

// Query 114
SELECT * FROM seller WHERE website.store CONTAINS 'store';

// Query 115
SELECT * FROM product WHERE array::len(images) > 0;

// Query 116
SELECT * FROM product WHERE name CONTAINS 'Smartphone';

// Query 117
SELECT out AS product_id, count() AS order_count FROM order GROUP BY product_id;

// Query 118
SELECT array::distinct(in) AS person_ids FROM cart GROUP ALL;

// Query 119
SELECT * FROM product WHERE id IN array::distinct(SELECT VALUE in FROM product_sku);

// Query 120
SELECT * FROM seller WHERE time.updated_at >= time::now() - 7d;

// Query 121
SELECT * FROM product WITH INDEX idx_product_details_embedding;

// Query 122
SELECT * FROM order WHERE order_status NOTINSIDE ['processed', 'shipped'];

// Query 123
SELECT * FROM review WHERE string::len(review_text) > 0;

// Query 124
SELECT * FROM order WHERE order_status = 'processed' AND time.shipped_at IS NONE;

// Query 125
SELECT *, fn::pound_to_usd(price) AS price_usd FROM product WHERE currency = 'GBP';

// Query 126
SELECT * FROM product WHERE id IN (SELECT VALUE in FROM product_sku WHERE quantity = 0);

// Query 127
SELECT out AS product_id, math::mean(quantity) AS avg_quantity FROM order GROUP BY product_id;

