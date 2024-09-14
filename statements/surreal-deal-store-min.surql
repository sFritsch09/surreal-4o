DEFINE FUNCTION fn::number_of_unfulfilled_orders() { RETURN (SELECT count() FROM order WHERE order_status NOTINSIDE ['processed', 'shipped'] GROUP ALL); } PERMISSIONS FULL;
DEFINE FUNCTION fn::pound_to_usd($price: number) { RETURN $price * 1.26f; } PERMISSIONS FULL;

-- ------------------------------
-- INDEXES
-- ------------------------------

DEFINE INDEX unique_wishlist_relationships 
    ON TABLE wishlist 
    COLUMNS in, out UNIQUE;

DEFINE INDEX unique_cart_relationships 
    ON TABLE cart 
    COLUMNS in, out UNIQUE;

DEFINE INDEX unique_order_relationships 
    ON TABLE order 
    COLUMNS in, out UNIQUE;

DEFINE INDEX unique_review_relationships 
    ON TABLE review 
    COLUMNS in, out UNIQUE;

DEFINE INDEX unique_product_sku_relationships 
    ON TABLE product_sku 
    COLUMNS in, out UNIQUE;

DEFINE INDEX person_country 
    ON TABLE person 
    COLUMNS address.country;

DEFINE INDEX order_count 
    ON TABLE order 
    COLUMNS order_status, created_at;

DEFINE INDEX order_product
    ON TABLE order
    COLUMNS product_name;

DEFINE ANALYZER blank_snowball
    TOKENIZERS blank 
    FILTERS lowercase, snowball(english);

DEFINE INDEX review_content 
    ON TABLE review 
    COLUMNS review_text 
    SEARCH ANALYZER blank_snowball BM25 HIGHLIGHTS;

DEFINE INDEX idx_product_details_embedding ON product 
    FIELDS details_embedding 
    MTREE DIMENSION 768 DIST COSINE;

-- ------------------------------
-- TABLE: avg_product_review
-- ------------------------------

DEFINE TABLE avg_product_review TYPE NORMAL SCHEMAFULL AS SELECT count() AS number_of_reviews, math::mean(<float> rating) AS avg_review, ->product.id AS product_id, ->product.name AS product_name FROM review GROUP BY product_id, product_name;
DEFINE FIELD avg_review 
    ON TABLE avg_product_review 
    TYPE number;
DEFINE FIELD id 
    ON TABLE avg_product_review 
    TYPE record<avg_product_review>;
DEFINE FIELD number_of_reviews 
    ON TABLE avg_product_review 
    TYPE number;
DEFINE FIELD product_id 
    ON TABLE avg_product_review 
    TYPE array<record<product>>;
DEFINE FIELD product_name 
    ON TABLE avg_product_review 
    TYPE array<string>;

-- ------------------------------
-- TABLE: monthly_sales
-- ------------------------------

DEFINE TABLE monthly_sales TYPE NORMAL SCHEMAFULL AS SELECT count() AS number_of_orders, time::format(time.created_at, '%Y-%m') AS month, math::sum(price * quantity) AS sum_sales, currency FROM order GROUP BY month, currency;
DEFINE FIELD id 
    ON TABLE monthly_sales 
    TYPE record<monthly_sales>;
DEFINE FIELD currency 
    ON TABLE monthly_sales 
    TYPE string;
DEFINE FIELD month 
    ON TABLE monthly_sales 
    TYPE string;
DEFINE FIELD number_of_orders 
    ON TABLE monthly_sales 
    TYPE number;
DEFINE FIELD sum_sales 
    ON TABLE monthly_sales 
    TYPE number;
-- ------------------------------
-- TABLE: address_history
-- ------------------------------

DEFINE TABLE address_history TYPE NORMAL SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE address_history 
    TYPE record<address_history>;
DEFINE FIELD person 
    ON TABLE address_history 
    TYPE record<person>;
DEFINE FIELD addresses 
    ON TABLE address_history 
    TYPE array<object>;
DEFINE FIELD addresses.*.address_line_1 
    ON TABLE address_history 
    TYPE string;
DEFINE FIELD addresses.*.address_line_2 
    ON TABLE address_history 
    TYPE option<string>;
DEFINE FIELD addresses.*.city 
    ON TABLE address_history 
    TYPE string;
DEFINE FIELD addresses.*.coordinates 
    ON TABLE address_history 
    TYPE geometry<point>;
DEFINE FIELD addresses.*.country 
    ON TABLE address_history 
    TYPE string;
DEFINE FIELD addresses.*.post_code 
    ON TABLE address_history 
    TYPE string;
DEFINE FIELD time 
    ON TABLE address_history 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE address_history 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE address_history 
    TYPE datetime
    VALUE time::now();

-- ------------------------------
-- TABLE: payment_details
-- ------------------------------

DEFINE TABLE payment_details TYPE NORMAL SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE payment_details 
    TYPE record<payment_details>;
DEFINE FIELD person 
    ON TABLE payment_details 
    TYPE record<person>;
DEFINE FIELD stored_cards 
    ON TABLE payment_details 
    FLEXIBLE TYPE array<object>;
DEFINE FIELD time 
    ON TABLE payment_details 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE payment_details 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE payment_details 
    TYPE datetime
    VALUE time::now();

-- ------------------------------
-- TABLE: person
-- ------------------------------

DEFINE TABLE person TYPE NORMAL SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE person 
    TYPE record<person>;
DEFINE FIELD first_name 
    ON TABLE person 
    TYPE string;
DEFINE FIELD last_name 
    ON TABLE person 
    TYPE string;
DEFINE FIELD name 
    ON TABLE person 
    TYPE string;
DEFINE FIELD company_name 
    ON TABLE person 
    TYPE option<string>;
DEFINE FIELD email 
    ON TABLE person 
    TYPE string 
    ASSERT string::is::email($value);
DEFINE FIELD phone 
    ON TABLE person 
    TYPE string;
DEFINE FIELD address 
    ON TABLE person 
    FLEXIBLE TYPE object;
DEFINE FIELD address_history 
    ON TABLE person 
    TYPE record<address_history>;
DEFINE FIELD payment_details 
    ON TABLE person 
    TYPE record<payment_details>;
DEFINE FIELD time 
    ON TABLE person 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE person 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE person 
    TYPE datetime
    VALUE time::now();

-- ------------------------------
-- TABLE: product
-- ------------------------------

DEFINE TABLE product TYPE NORMAL SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE product 
    TYPE record<product>;
DEFINE FIELD name 
    ON TABLE product 
    TYPE string;
DEFINE FIELD details 
    ON TABLE product 
    TYPE array<string>;
DEFINE FIELD details_embedding
    ON TABLE product 
    TYPE array<decimal>;
DEFINE FIELD category 
    ON TABLE product 
    TYPE string;
DEFINE FIELD sub_category 
    ON TABLE product 
    TYPE string;
DEFINE FIELD colours 
    ON TABLE product 
    TYPE array<string>;
DEFINE FIELD sizes 
    ON TABLE product 
    TYPE array<string>;
DEFINE FIELD price 
    ON TABLE product 
    TYPE number;
DEFINE FIELD currency 
    ON TABLE product 
    TYPE string;
DEFINE FIELD images 
    ON TABLE product 
    TYPE array<object>;
DEFINE FIELD images.*.url 
    ON TABLE product 
    TYPE string
    ASSERT string::is::url($value);
DEFINE FIELD images.*.position 
    ON TABLE product 
    TYPE number;
DEFINE FIELD seller 
    ON TABLE product 
    TYPE record<seller>;
DEFINE FIELD time 
    ON TABLE product 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE product 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE product 
    TYPE datetime
    VALUE time::now();

-- ------------------------------
-- TABLE: product_sku
-- ------------------------------

DEFINE TABLE product_sku TYPE RELATION FROM product TO product SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE product_sku 
    TYPE record<product_sku>;
DEFINE FIELD quantity 
    ON TABLE product_sku 
    TYPE number;
DEFINE FIELD colour 
    ON TABLE product_sku 
    TYPE string;
DEFINE FIELD size 
    ON TABLE product_sku 
    TYPE string;
DEFINE FIELD time 
    ON TABLE product_sku 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE product_sku 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE product_sku 
    TYPE datetime
    VALUE time::now();

-- ------------------------------
-- TABLE: wishlist
-- ------------------------------

DEFINE TABLE wishlist TYPE RELATION FROM person TO product SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE wishlist 
    TYPE record<wishlist>;
DEFINE FIELD time 
    ON TABLE wishlist 
    TYPE object;
DEFINE FIELD colour 
    ON TABLE wishlist
    TYPE string;
DEFINE FIELD size 
    ON TABLE wishlist
    TYPE string;
DEFINE FIELD time.created_at 
    ON TABLE wishlist 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.deleted_at 
    ON TABLE wishlist 
    TYPE option<datetime>;

-- ------------------------------
-- TABLE: cart
-- ------------------------------

DEFINE TABLE cart TYPE RELATION FROM person TO product SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE cart 
    TYPE record<cart>;
DEFINE FIELD in 
    ON TABLE cart 
    TYPE record<person>;
DEFINE FIELD out 
    ON TABLE cart 
    TYPE record<product>;
DEFINE FIELD product_name 
    ON TABLE cart 
    TYPE string;
DEFINE FIELD currency 
    ON TABLE cart 
    TYPE string;
DEFINE FIELD price 
    ON TABLE cart 
    TYPE number;
DEFINE FIELD quantity 
    ON TABLE cart 
    TYPE number;
DEFINE FIELD colour 
    ON TABLE cart
    TYPE string;
DEFINE FIELD size 
    ON TABLE cart
    TYPE string;
DEFINE FIELD time 
    ON TABLE cart 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE cart 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE cart 
    TYPE datetime
    VALUE time::now();


-- ------------------------------
-- TABLE: order
-- ------------------------------

DEFINE TABLE order TYPE RELATION FROM person TO product SCHEMAFULL PERMISSIONS none;
DEFINE FIELD product_name 
    ON TABLE order 
    TYPE string;
DEFINE FIELD currency 
    ON TABLE order 
    TYPE string;
DEFINE FIELD price 
    ON TABLE order 
    TYPE number;
DEFINE FIELD quantity 
    ON TABLE order 
    TYPE number;
DEFINE FIELD colour 
    ON TABLE order
    TYPE string;
DEFINE FIELD size 
    ON TABLE order
    TYPE string;
DEFINE FIELD shipping_address 
    ON TABLE order 
    FLEXIBLE TYPE object;
DEFINE FIELD payment_method 
    ON TABLE order 
    TYPE string;
DEFINE FIELD order_status 
    ON TABLE order 
    TYPE string;
DEFINE FIELD id 
    ON TABLE order 
    TYPE record<order>;
DEFINE FIELD in 
    ON TABLE order 
    TYPE record<person>;
DEFINE FIELD out 
    ON TABLE order 
    TYPE record<product>;
DEFINE FIELD time 
    ON TABLE order 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE order 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE order 
    TYPE datetime
    VALUE time::now();
DEFINE FIELD time.processed_at 
    ON TABLE order 
    TYPE option<datetime>;
DEFINE FIELD time.shipped_at 
    ON TABLE order 
    TYPE option<datetime>;

-- ------------------------------
-- TABLE: review
-- ------------------------------

DEFINE TABLE review TYPE RELATION FROM person TO product SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE review 
    TYPE record<review>;
DEFINE FIELD in 
    ON TABLE review 
    TYPE record<person>;
DEFINE FIELD out 
    ON TABLE review 
    TYPE record<product>;
DEFINE FIELD rating 
    ON TABLE review 
    TYPE number 
    ASSERT $value > 0 AND $value < 6;
DEFINE FIELD review_text 
    ON TABLE review 
    TYPE string;
DEFINE FIELD time 
    ON TABLE review 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE review 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE review 
    TYPE datetime
    VALUE time::now();

-- ------------------------------
-- TABLE: seller
-- ------------------------------

DEFINE TABLE seller TYPE NORMAL SCHEMAFULL PERMISSIONS none;
DEFINE FIELD id 
    ON TABLE seller 
    TYPE record<seller>;
DEFINE FIELD name 
    ON TABLE seller 
    TYPE string;
DEFINE FIELD addresses 
    ON TABLE seller 
    FLEXIBLE TYPE object;
DEFINE FIELD website 
    ON TABLE seller 
    TYPE object;
DEFINE FIELD website.main 
    ON TABLE seller 
    TYPE string;
DEFINE FIELD website.docs 
    ON TABLE seller 
    TYPE string;
DEFINE FIELD website.store 
    ON TABLE seller 
    TYPE string;
DEFINE FIELD email 
    ON TABLE seller 
    TYPE string;
DEFINE FIELD time 
    ON TABLE seller 
    TYPE object;
DEFINE FIELD time.created_at 
    ON TABLE seller 
    TYPE datetime
    DEFAULT time::now();
DEFINE FIELD time.updated_at 
    ON TABLE seller 
    TYPE datetime
    VALUE time::now();