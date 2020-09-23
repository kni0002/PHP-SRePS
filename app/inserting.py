import connection
import reading
import re

def insert_product(product_name, manufacturer_name, price, db, cursor):
    '''
    This function inserts a new product into the product table.
    If the product does not already exists in the table, the function
    will insert a new record and return the corresponding id.
    If the product already exisits in the table, the function will return
    the corresponding id only.

    :param product_name: name of the product
    :param manufacturer_name: name of manufacturer
    :param price: price (@type: float)
    :param db: connection to the database
    :param cursor: the cursor of the database connection
    :return: product id

    Example:
    Existing product table in the database
    +------------+-----------------------------+-----------------+---------+
    | product_id | product_name                | manufacturer_id | price   |
    +------------+-----------------------------+-----------------+---------+
    |          1 | Panadol - 25 pill box       |               1 |    5.60 |
    |          2 | Meat - unknown origin, 200g |               2 |   15.20 |
    |          6 | Panadol - 26 pill box       |               1 |    5.60 |
    +------------+-----------------------------+-----------------+---------+

    >>> insert_product("Panadol - 26 pill box", "Chemical Company", 5.60, connect, mycursor)
    The function above will return 6 because the product already existed in the table
    '''
    assert type(product_name) == str
    assert type(manufacturer_name) == str
    assert type(price) == float
    alist = reading.check_value("product", "product_id",
                                "product_name", product_name, cursor)
    if len(alist) == 0:
        manufacturer_id = insert_manufacturer(manufacturer_name, db, cursor)
        query = (
            "INSERT INTO product (`product_name`, `manufacturer_id`, `price`) "
            "VALUES  ('" + product_name + "', '" + str(manufacturer_id) + "', '" + str(price) + "'); "
        )
        cursor.execute(query)
        db.commit()
        print("New product " + product_name + " added! ")
        return cursor.lastrowid
    else:
        return alist[0][0]


def insert_manufacturer(manufacturer_name, db, cursor):
    '''
    This function inserts to the database a new manufacturer record
    and returns the corresponding manufacturer_id

    :param manufacturer_name: the name of the manufacturer
    :param db: connection to the database
    :param cursor: the cursor of the database connection
    :return: manufacturer id

    '''
    assert type(manufacturer_name) == str
    alist = reading.check_value("manufacturer", "manufacturer_id",
                                "manufacturer_name", manufacturer_name, cursor)
    if len(alist) == 0:
        query = (
                "INSERT INTO manufacturer (`manufacturer_name`) "
                "VALUES ('" + manufacturer_name + "'); "
        )
        cursor.execute(query)
        db.commit()
        print("New manufacturer " + manufacturer_name + " added! ")
        return cursor.lastrowid
    else:
        return alist[0][0]


def insert_batch(product_id, exp_date, import_date, quantity, db, cursor):
    '''
    This function updates both the batch table and inventory table, and returns
    the corresponding batch_id.
    Note: batch table and inventory table may seem to represent the same thing
    and the inventory table may seem redundant. However, the design of the databse
    assigns these two tables different purposes. Records in the batch table, after
    initial insertion will not be changed in the future; the purpose of the batch
    table is to keep track of the order batches from suppliers. The inventory table,
    on the other hand, is dynamic, the quantity column will change (mainly decrease
    in value) as customers make purchase.

    :param product_id: ID of a product
    :param exp_date: expire date of the product
    :param import_date: the date on which the product is imported
    :param quantity: quantity of the product
    :param db: connection to the database
    :param cursor: the cursor of the database connection
    :return: batch ID

    Example:
    Original batch table:
    +----------+------------+------------+-------------+----------+
    | batch_id | product_id | exp_date   | import_date | quantity |
    +----------+------------+------------+-------------+----------+
    |        4 |          4 | NULL       | NULL        |     NULL |
    |        5 |          5 | 0000-01-01 | NULL        |       50 |
    +----------+------------+------------+-------------+----------+
    Original inventory table:
    +----------+----------+------------+----------+
    | inven_id | batch_id | product_id | quantity |
    +----------+----------+------------+----------+
    |        5 |        4 |          4 |        4 |
    |        6 |        5 |          2 |       50 |
    +----------+----------+------------+----------+

    >>> insert_batch(4, '2021-12-10', '2019-09-10', 500, connect, mycursor)
    @return: 6
    batch table after the funtion runs:
    +----------+------------+------------+-------------+----------+
    | batch_id | product_id | exp_date   | import_date | quantity |
    +----------+------------+------------+-------------+----------+
    |        4 |          4 | NULL       | NULL        |     NULL |
    |        5 |          5 | 0000-01-01 | NULL        |       50 |
    |        6 |          4 | 2021-12-10 | 2019-09-10  |      500 |
    +----------+------------+------------+-------------+----------+
    inventory table after the function runs:
    +----------+----------+------------+----------+
    | inven_id | batch_id | product_id | quantity |
    +----------+----------+------------+----------+
    |        5 |        4 |          4 |        4 |
    |        6 |        5 |          2 |       50 |
    |        7 |        6 |          4 |      500 |
    +----------+----------+------------+----------+

    '''
    assert type(exp_date) == str and type(import_date) == str
    assert re.search("^\d{4}-\d{2}-\d{2}$", exp_date) and re.search("^\d{4}-\d{2}-\d{2}$", import_date)
    assert type(product_id) == int
    assert type(quantity) == int

    query = (
            "INSERT INTO batch (`product_id`, `exp_date`, `import_date`, `quantity`) "
            "VALUES ('" + str(product_id) + "', '" + exp_date + "', '" + import_date + "', '" + str(quantity) + "'); "
    )
    cursor.execute(query)
    db.commit()
    batch_id = cursor.lastrowid
    insert_inventory(batch_id, product_id, quantity, db, cursor)
    return batch_id


def insert_inventory(batch_id, product_id, quantity, db, cursor):
    '''
    This function inserts into the inventory table 1 record and
    returns the corresponding ID.

    :param batch_id: ID of a batch in the batch table
    :param product_id: ID of a product
    :param quantity: product quantity
    :param db: connection to the database
    :param cursor: the cursor of the database connection
    :return: inventory ID

    Example:
    Suppose the last updated inventory id was 5
    >>> insert_inventory(5, 2, 50, connect, mycursor)
    @return: 6
    '''
    assert type(batch_id) == int
    assert type(product_id) == int
    assert type(quantity) == int

    query = (
            "INSERT INTO inventory (`batch_id`, `product_id`, `quantity`)  "
            "VALUES ('" + str(batch_id) + "', '" + str(product_id) + "', '" + str(quantity) + "'); "
    )
    cursor.execute(query)
    db.commit()
    return cursor.lastrowid


def insert_customer(surname, given_name, address, dob, db, cursor):
    '''
    This function insert a new record of customer and returns the corresponding ID.

    :param surname: customer surname
    :param given_name: customer given name
    :param address: customer address
    :param dob: date of birth, in yyyy-mm-dd format
    :param db: connection to the database
    :param cursor: the cursor of the database connection
    :return: customer id that is inserted

    Example:
    >>> insert_customer('Matthew', 'Peterson', 'vic 3033', '1998-08-08', connect, mycursor)
    Suppose that the last customer ID before inserting is 5
    @return: 6
    '''
    assert type(surname) == str
    assert type(given_name) == str
    assert type(address) == str
    assert type(dob) == str
    assert re.search("^\d{4}-\d{2}-\d{2}$", dob)

    query = (
            "INSERT INTO customer (`surname`, `given_name`, `address`, `dob`) "
            "VALUES  ('" + surname + "', '" + given_name + "', '" + address + "', '" + dob + "'); "
    )
    cursor.execute(query)
    db.commit()
    print("New customer added! ")
    return cursor.lastrowid


def insert_new_sale():
    return


if __name__ == "__main__":
    # tests
    connect = connection.conn()
    # Note: cursor must be set up this way (although the parameter 'buffered=True')
    # can be omitted. Otherwise 'weakly-referenced object no longer exists' error will occur
    mycursor = connect.cursor(buffered=True)
    print(insert_batch(4, '2021-12-10', '2019-09-10', 500, connect, mycursor))
    connect.close()
