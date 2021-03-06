# You will need a mysql server installed to run this.
# I am using Xampp to run my mysql server
# I am running this via mysql workbench, but copy-pasting this to terminal should work too.

# Will need to comment out drop if database doesnt exist.
DROP DATABASE PHP_SRePS;

CREATE DATABASE PHP_SRePS;
USE PHP_SRePS;

CREATE TABLE manufacturer (
    manufacturer_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    manufacturer_name VARCHAR(50),
    PRIMARY KEY (manufacturer_id)
);

INSERT INTO manufacturer (`manufacturer_name`) VALUES ('Chemical Company');
INSERT INTO manufacturer (`manufacturer_name`) VALUES ('Chem Shop');
INSERT INTO manufacturer (`manufacturer_name`) VALUES ('Manu-chem');
INSERT INTO manufacturer (`manufacturer_name`) VALUES ('My Dad');
INSERT INTO manufacturer (`manufacturer_name`) VALUES ('Found It');

CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    surname VARCHAR(15) NOT NULL,
    given_name VARCHAR(15) NOT NULL,
    address VARCHAR(255),
    dob DATE,
    PRIMARY KEY (customer_id)
);

INSERT INTO customer (`surname`, `given_name`, `address`, `dob`) VALUES ('unknown', 'unknown', NULL, NULL);
INSERT INTO customer (`surname`, `given_name`, `address`, `dob`) VALUES ('Spin', 'Shooter', '62 buddy drive, sunshine west', '2002-02-02');
INSERT INTO customer (`surname`, `given_name`, `address`, `dob`) VALUES ('Fut', 'Jigglehouse', '72 thirteen lane, fertree gully', '0600-12-25');
INSERT INTO customer (`surname`, `given_name`, `address`) VALUES ('Perman', 'Danger', '2000 excelcior glade, wilderness');
INSERT INTO customer (`surname`, `given_name`, `dob`) VALUES ('Thradburry', 'Leina', '2050-09-12');

CREATE TABLE product (
    product_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    manufacturer_id INT NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (product_id),
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(manufacturer_id)
);

INSERT INTO product (`product_name`, `manufacturer_id`, `price`) VALUES ('Panadol - 25 pill box', '1', '5.60');
INSERT INTO product (`product_name`, `manufacturer_id`, `price`) VALUES ('Meat - unknown origin, 200g', '2', '15.20');
INSERT INTO product (`product_name`, `manufacturer_id`, `price`) VALUES ('Liquid - heavy, 100ml cups', '3', '20.05');
INSERT INTO product (`product_name`, `manufacturer_id`, `price`) VALUES ('Pain - heavy, 1 serving', '4', '0.01');
INSERT INTO product (`product_name`, `manufacturer_id`, `price`) VALUES ('Guck - 1 handful', '5', '12.5');

CREATE TABLE batch (
    batch_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    product_id INT NOT NULL,
    exp_date DATE,
    import_date DATE,
    quantity MEDIUMINT,
    PRIMARY KEY (batch_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO batch (`product_id`, `exp_date`, `import_date`, `quantity`) VALUES ('1', '2022-09-19', '2020-09-12', '200');
INSERT INTO batch (`product_id`, `exp_date`, `import_date`, `quantity`) VALUES ('2', '2020-09-19', '2020-09-10', '10');
INSERT INTO batch (`product_id`, `import_date`, `quantity`) VALUES ('3', '2020-01-01', '10000');
INSERT INTO batch (`product_id`) VALUES ('4');
INSERT INTO batch (`product_id`, `exp_date`, `quantity`) VALUES ('5', '0000-01-01', '50');

CREATE TABLE inventory (
    inven_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    batch_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity MEDIUMINT,
    PRIMARY KEY (batch_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (batch_id) REFERENCES batch(batch_id)
);

INSERT INTO inventory (`batch_id`, `product_id`, `quantity`) VALUES ('1', '1', '200');
INSERT INTO inventory (`batch_id`, `product_id`, `quantity`) VALUES ('2', '2', '10');
INSERT INTO inventory (`batch_id`, `product_id`, `quantity`) VALUES ('3', '3', '10000');
INSERT INTO inventory (`batch_id`, `product_id`, `quantity`) VALUES ('4', '4', '4');
INSERT INTO inventory (`batch_id`, `product_id`, `quantity`) VALUES ('5', '5', '50');

CREATE TABLE sales (
    sales_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    date DATE,
    PRIMARY KEY (sales_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

INSERT INTO sales (`customer_id`, `date`) VALUES ('1', '2019-09-09');
INSERT INTO sales (`customer_id`, `date`) VALUES ('1', '2019-09-11');
INSERT INTO sales (`customer_id`, `date`) VALUES ('2', '2019-12-25');
INSERT INTO sales (`customer_id`, `date`) VALUES ('2', '2019-12-28');
INSERT INTO sales (`customer_id`, `date`) VALUES ('3', '2020-01-01');
INSERT INTO sales (`customer_id`, `date`) VALUES ('3', '2020-02-02');
INSERT INTO sales (`customer_id`, `date`) VALUES ('4', '2020-03-03');
INSERT INTO sales (`customer_id`, `date`) VALUES ('4', '2020-04-04');
INSERT INTO sales (`customer_id`, `date`) VALUES ('5', '2020-05-05');
INSERT INTO sales (`customer_id`, `date`) VALUES ('5', '2020-06-06');
INSERT INTO sales (`customer_id`, `date`) VALUES ('1', '2020-09-01');
INSERT INTO sales (`customer_id`) VALUES ('2');
INSERT INTO sales (`customer_id`, `date`) VALUES ('3', '2020-09-03');
INSERT INTO sales (`customer_id`, `date`) VALUES ('4', '2020-09-05');
INSERT INTO sales (`customer_id`, `date`) VALUES ('5', '2020-09-09');
INSERT INTO sales (`customer_id`, `date`) VALUES ('1', '2020-09-12');
INSERT INTO sales (`customer_id`, `date`) VALUES ('1', '2020-09-16');
INSERT INTO sales (`customer_id`, `date`) VALUES ('2', '2020-09-18');
INSERT INTO sales (`customer_id`, `date`) VALUES ('2', '2020-09-22');
INSERT INTO sales (`customer_id`, `date`) VALUES ('3', '2020-10-01');
INSERT INTO sales (`customer_id`, `date`) VALUES ('3', '2020-10-06');
INSERT INTO sales (`customer_id`, `date`) VALUES ('4', '2020-10-09');
INSERT INTO sales (`customer_id`, `date`) VALUES ('4', '2020-10-09');
INSERT INTO sales (`customer_id`, `date`) VALUES ('5', '2020-10-10');
INSERT INTO sales (`customer_id`, `date`) VALUES ('5', '2020-10-11');

CREATE TABLE sale_items (
    sale_item_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    sales_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (sale_item_id),
    FOREIGN KEY (sales_id) REFERENCES sales(sales_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('1', '1', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('1', '2', '5');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('2', '2', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('3', '3', '6');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('4', '3', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('4', '4', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('5', '5', '10');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('6', '1', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('6', '2', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('7', '1', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('7', '2', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('8', '3', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('8', '4', '3');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('9', '4', '5');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('9', '5', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('10', '4', '5');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('10', '5', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('11', '1', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('11', '2', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('12', '1', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('12', '2', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('13', '3', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('13', '4', '3');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('14', '3', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('14', '4', '3');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('16', '4', '5');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('16', '5', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('17', '4', '5');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('17', '5', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('18', '1', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('18', '2', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('19', '1', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('19', '2', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('20', '3', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('20', '4', '3');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('21', '3', '4');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('21', '4', '3');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('22', '1', '5');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('22', '5', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('23', '1', '5');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('23', '5', '1');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('24', '2', '3');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('24', '3', '2');
INSERT INTO sale_items (`sales_id`, `product_id`, `quantity`) VALUES ('25', '2', '3');
