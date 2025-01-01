// Query 90
SELECT * FROM person WHERE count(->order->product) > 3;

// Query 91
SELECT * FROM product WHERE <-cart<-person WHERE address.country = 'Canada';

// Query 92
SELECT name FROM person WHERE ->order->(product WHERE name = 'Smartphone') AND ->review->(product WHERE name = 'Smartphone');

// Query 93
SELECT math::sum(price * quantity) AS total_revenue FROM order WHERE out IN (SELECT id FROM product WHERE category = 'Books');

// Query 94
SELECT * FROM product WHERE <-wishlist<-(person WHERE age >= 20 AND age <= 30);

// Query 95
SELECT * FROM person WHERE ->order->(product WHERE price > 500);

// Query 96
SELECT * FROM product WHERE <-review WHERE rating < 2;

// Query 97
SELECT * FROM person WHERE !->cart;

// Query 98
SELECT * FROM product WHERE <-order<-person->review->product WHERE id = product.id;

// Query 99
SELECT * FROM person WHERE ->wishlist->(product WHERE name = 'Laptop') AND !->order->(product WHERE name = 'Laptop');

// Query 100
SELECT * FROM product WHERE <-order<-(person WHERE address.country = 'USA') AND <-order<-(person WHERE address.country = 'Canada');

// Query 101
SELECT math::mean(rating) AS avg_rating FROM review WHERE ->product->(product WHERE category = 'Electronics');

// Query 102
SELECT * FROM person WHERE ->(order WHERE time::now() - time.created_at <= 7d);

// Query 103
SELECT *, count(<-cart<-) AS cart_count FROM product GROUP BY id HAVING cart_count > 50;

// Query 104
SELECT * FROM person WHERE ->cart->product->(product_sku WHERE quantity < 5);

// Query 105
SELECT * FROM product WHERE !<-order;

// Query 106
SELECT * FROM person WHERE ->order AND address.shipping IS NONE;

// Query 107
SELECT * FROM product WHERE <-review<-(person WHERE age > 50);

// Query 108
SELECT id, math::sum(<-order.quantity) AS total_quantity FROM product GROUP BY id;

// Query 109
SELECT * FROM product WHERE <-order<-(person WHERE count(->wishlist) > 5);

// Query 110
SELECT id, count(->cart) AS cart_items FROM person;

// Query 111
SELECT *, count(<-order<-) AS user_count FROM product GROUP BY id HAVING user_count >= 3;

// Query 112
SELECT * FROM person WHERE ->wishlist->(product WHERE name = 'Tablet') AND ->cart->(product WHERE name = 'Laptop');

// Query 113
SELECT * FROM product WHERE <-order WHERE time::now() - time.created_at <= 30d;

// Query 114
SELECT * FROM person WHERE ->review->product.id NOT IN (SELECT VALUE out FROM order WHERE in = person.id);

// Query 115
SELECT id, math::mean(<-review.rating) AS avg_rating FROM product GROUP BY id HAVING avg_rating < 3;

// Query 116
SELECT * FROM person WHERE count(->order) > 10;

// Query 117
SELECT * FROM product WHERE <-order WHERE order_status = 'returned';

// Query 118
SELECT * FROM person WHERE ->order->(product WHERE category = 'Furniture');

// Query 119
SELECT id, count(->review) AS review_count FROM person;

// Query 120
SELECT * FROM product WHERE count(<-cart<-person GROUP BY address.city) > 1;

// Query 121
SELECT * FROM person WHERE ->(order WHERE quantity < 0);

// Query 122
SELECT * FROM product WHERE <-order WHERE order_status != 'shipped';

// Query 123
SELECT * FROM person WHERE address.shipping = address.billing;

// Query 124
SELECT math::mean(age) AS avg_age FROM person WHERE ->order->(product WHERE name = 'Smartwatch');

// Query 125
SELECT * FROM product WHERE EXISTS(<-review WHERE string::contains(string::lowercase(review_text), 'excellent'));

// Query 126
SELECT * FROM person WHERE ->order->(product WHERE price > 1000);

// Query 127
SELECT * FROM product WHERE <-order<-(person WHERE email IS NONE);

// Query 128
SELECT * FROM person WHERE count(->order GROUP BY out) > 1;

// Query 129
SELECT *, math::sum(<-order.quantity * price) AS total_sales FROM product GROUP BY id ORDER BY total_sales DESC LIMIT 10;

