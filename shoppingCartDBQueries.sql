-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.

DROP TABLE IF EXISTS public.products;

CREATE TABLE IF NOT EXISTS public.products
(
    product_id bigserial,
    name character varying(30),
    price numeric(10, 2),
    PRIMARY KEY (product_id)
);

DROP TABLE IF EXISTS public.users;

CREATE TABLE IF NOT EXISTS public.users
(
    user_id bigserial,
    name character varying(50),
    PRIMARY KEY (user_id)
);

DROP TABLE IF EXISTS public.cart;

CREATE TABLE IF NOT EXISTS public.cart
(
    product_id smallint,
    quantity smallint,
    PRIMARY KEY (product_id)
);

DROP TABLE IF EXISTS public.order_header;

CREATE TABLE IF NOT EXISTS public.order_header
(
    order_id bigserial,
    user_id smallint,
    order_date date,
    PRIMARY KEY (order_id)
);

DROP TABLE IF EXISTS public.order_details;

CREATE TABLE IF NOT EXISTS public.order_details
(
    order_header smallint,
    product_id smallint,
    quantity smallint
);

-- QUERIES --

-- POPULATEING products TABLE WITH VALUES --

INSERT INTO products (name, price)
VALUES 
	('Coke', 14.99),
	('Chips', 19.99),
	('Milk', 24.99),
	('Bread', 29.99),
	('Ice Cream', 39.99),
	('Butter', 24.99),
	('Chicken', 59.99),
	('Beef', 69.99),
	('Cheese', 39.99),
	('Lettuce', 29.99);
	
SELECT * FROM products;
	
-- POPULATING THE users TABLE WITH VALUES --

INSERT INTO users (name)
VALUES
	('John'),
	('Mike'),
	('Jane'),
	('Hally'),
	('Tom');
	
SELECT * FROM users;

-- ADDING AN ITEM TO cart --

CREATE OR REPLACE FUNCTION add(p_id smallint)
RETURNS void AS $$
BEGIN
	IF EXISTS (SELECT * FROM cart WHERE product_id = p_id)
	THEN
		UPDATE cart SET quantity = quantity + 1 WHERE product_id = p_id;
	ELSE
		INSERT INTO cart (product_id,quantity) VALUES (p_id,1);
	END IF; 
END;
$$ LANGUAGE plpgsql;

SELECT add(6::int2);

SELECT * FROM cart;

-- REMOVING AN ITEM FROM cart --

CREATE OR REPLACE FUNCTION remove(p_id smallint)
RETURNS void AS $$
BEGIN
	IF EXISTS (SELECT * FROM cart WHERE product_id = p_id)
	THEN
		IF EXISTS (SELECT * FROM cart WHERE quantity > 0 AND product_id = p_id)
		THEN
			UPDATE cart SET quantity = quantity - 1 WHERE product_id = p_id;
		ELSE
			DELETE FROM cart WHERE product_id = p_id;
		END IF;
	END IF; 
END;
$$ LANGUAGE plpgsql;

SELECT remove(1::int2);

SELECT * FROM cart;

-- CHECKOUT --

CREATE OR REPLACE FUNCTION checkout(u_id smallint)
RETURNS void AS $$
BEGIN
	INSERT INTO order_header(user_id, order_date)
	VALUES (u_id, now());
	
	INSERT INTO order_details(order_header, product_id, quantity)
	SELECT u_id, product_id, quantity FROM cart;
	DELETE FROM cart WHERE product_id > 0;
END;
$$ LANGUAGE plpgsql;

SELECT checkout(1::int2);

SELECT * FROM order_header;

SELECT * FROM order_details;

-- CLEAR ORDER DETAILS --

DELETE FROM order_details WHERE order_header > 0;









