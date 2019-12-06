from flask import Flask, request
from hashlib import sha256
import datetime
import time
import json
import mysql.connector


from flask_cors import CORS
app = Flask(__name__)
CORS(app)


def startConnection():
    return mysql.connector.connect(user='root', password=, host='127.0.0.1', database='grocery_store')

@app.route('/addProduct/<product_id>/<name>/<quantity_in_stock>/<unit_price>')
def addProduct(product_id, name, quantity_in_stock, unit_price):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        add_product = f'INSERT INTO products (product_id, name, quantity_in_stock, unit_price) VALUES ({int(product_id)}, \"{name}\", {int(quantity_in_stock)}, {float(unit_price)})'
        cursor.execute(add_product)
        cnx.commit()
        cursor.close()
        cnx.close()
        return json.dumps({"added": "ok"})
    except:
        return json.dumps({"added": "error"})


@app.route('/login/<user_name>/<password>')
def login(user_name, password):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query = f'SELECT * FROM user WHERE username = \"{user_name}\" AND password = \"{password}\"'
        cursor.execute(query)
        success = False
        for (user, passw, e_id, role)  in cursor:
            if user == user_name:
                success = True

        print(success)
        
        if success == False:
            raise Exception('I know Python!')
        now = datetime.datetime.now()
        var = now.strftime("%m%d%Y%H%M%S")
        hashedWord = sha256(var.encode('ascii')).hexdigest()
        add_product = f'INSERT INTO session (username, cookie) VALUES (\"{user_name}\", \"{hashedWord}\")'
        cursor.execute(add_product)
        cnx.commit()
        
        cursor.close()
        cnx.close()
        return json.dumps({"cookie": hashedWord})
    except:
        return json.dumps({"error": "error"})


@app.route('/getProducts/')
def getProducts():
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query= f'SELECT product_id, name, quantity_in_stock, unit_price FROM products '
        cursor.execute(query)
        dic = {}
        counter = 0
        for (product_id, name, quantity_in_stock, unit_price ) in cursor:
            dic[counter] = {"id": str(product_id), "name": name, "quantity": str(quantity_in_stock), "price":str(unit_price)}
            counter +=1
        cursor.close()
        cnx.close()
        return json.dumps({"number" : counter, "data": dic})
    except:
        return json.dumps({"error": "fatal"})


@app.route('/update/<id_prod>/<name>/<price>/<quantity>')
def update(id_prod, name, price, quantity):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query= f'UPDATE products SET name = \"{name}\", unit_price = {float(price)}, quantity_in_stock = {int(quantity)} WHERE product_id = {int(id_prod)}'
        #print(query)
        success= False
        cursor.execute(query)
        query= f'SELECT * FROM products WHERE name = \"{name}\" AND unit_price = {float(price)} AND quantity_in_stock = {int(quantity)} AND product_id = {int(id_prod)}'
        print(query)
        cursor.execute(query)
        for (n, p, q, i) in cursor:
            print(n, p, q, i)
            if n:
                success = True
        cnx.commit()
        cursor.close()
        cnx.close()
        if success:
            return json.dumps({"status": "ok"})
        else:
            return json.dumps({"error": "update fail"})
    except:
        return json.dumps({"error": "fatal"})

@app.route('/delete/<id_prod>')
def delete(id_prod):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query= f'DELETE FROM products WHERE product_id = {int(id_prod)}'
        cursor.execute(query)
        cnx.commit()
        cursor.close()
        cnx.close()
        return json.dumps({"status": "ok"})
    except:
        return json.dumps({"error": "fatal"})
















@app.route('/getProdById/<id_prod>')
def getProdById(id_prod):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query= f'SELECT product_id, name, quantity_in_stock, unit_price FROM products WHERE product_id = {int(id_prod)}'
        cursor.execute(query)
        dic = {}
        for (product_id, name, quantity_in_stock, unit_price ) in cursor:
            dic["product_id"]= product_id
            dic["name"]= name
            dic["quantity_in_stock"]= str(quantity_in_stock)
            dic["unit_price"]= str(unit_price)
        cursor.close()
        cnx.close()
        if dic:
            return json.dumps(dic)
        else:
            return json.dumps({"error": "not_found"})
    except:
        return json.dumps({"error": "fatal"})

@app.route('/test')
def test():
    return json.dumps({"connection": "ok"})

@app.route('/getUserByHash/<hashed>')
def getUserByHash(hashed):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query= f'SELECT employee_id FROM session JOIN user ON user.username = session.username WHERE cookie = \"{hashed}\" '
        cursor.execute(query)
        dic= {}
        for (employee_id) in cursor:
            dic["employee_id"]= employee_id[0]
        cursor.close()
        cnx.close()
        if dic:
            return json.dumps(dic)
        else:
            return json.dumps({"error": "not_found"})
    except:
        return json.dumps({"error": "fatal"})

@app.route('/removeInventary/<id_prod>/<quantity>')
def removeInventary(id_prod, quantity):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query= f'SELECT quantity_in_stock FROM products WHERE product_id = {int(id_prod)}'
        cursor.execute(query)
        number = -1
        for (q) in cursor:
            number = q[0] - quantity
        if number < 0:
            cursor.close()
            cnx.close()
            return json.dumps({"error": "not_enough"})
        query= f'UPDATE products SET quantity_in_stock = {int(number)} WHERE product_id = {int(id_prod)}'
        success= False
        cursor.execute(query)
        query= f'SELECT quantity_in_stock FROM products WHERE product_id = {int(id_prod)}'
        cursor.execute(query)
        for (q2) in cursor:
            if q2[0] == number:
                success = True
        cnx.commit()
        cursor.close()
        cnx.close()
        if success:
            return json.dumps({"status": "ok"})
        else:
            return json.dumps({"error": "update fail"})
    except:
        return json.dumps({"error": "fatal"})

@app.route('/getOrderOverView/')
def getOrderOverView():
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        orders = f'SELECT total, orders.order_id, employee_id, order_date FROM orders JOIN (SELECT sum(quantity * unit_price) AS total, order_id FROM order_items JOIN products ON order_items.product_id = products.product_id GROUP BY order_id) as complete_order on complete_order.order_id = orders.order_id'
        cursor.execute(orders)
        lis = []
        for (total, order_id, employee_id, order_date) in cursor:
            temp = {}
            temp["id"] = order_id
            temp["employee_id"] = employee_id
            temp["order_date"] = str(order_date)
            temp["total"] = float(total)
            lis.append(temp)
        cursor.close()
        cnx.close()
        return json.dumps({"csv": lis})
    except:
        return json.dumps({"added": "error"})


@app.route('/getQuantities/')
def getQuantities():
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        orders = f'SELECT * FROM products'
        cursor.execute(orders)
        lis = []
        for (product_id, name, quantity_in_stock, unit_price) in cursor:
            temp = {}
            temp["product_id"] = product_id
            temp["name"] = name
            temp["quantity_in_stock"] = quantity_in_stock
            temp["unit_price"] = float(unit_price)
            lis.append(temp)
        cursor.close()
        cnx.close()
        return json.dumps({"csv": lis})
    except:
        return json.dumps({"added": "error"})


@app.route('/getNameByHash/<hashed>')
def getNameByHash(hashed):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        query= f'SELECT first_name from employee JOIN (SELECT employee_id FROM session JOIN user ON user.username = session.username WHERE cookie = \"{hashed}\" ) AS EMP  on EMP.employee_id = employee.employee_id'
        cursor.execute(query)
        dic= {}
        for (employee_id) in cursor:
            dic["employee_name"]= employee_id[0]
        cursor.close()
        cnx.close()
        if dic:
            return json.dumps(dic)
        else:
            return json.dumps({"error": "not_found"})
    except:
        return json.dumps({"error": "fatal"})


@app.route('/getOrders/<id>')
def getOrders(id):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        orders = f'SELECT * from order_items JOIN products ON products.product_id = order_items.product_id WHERE order_items.order_id = {id}'
        cursor.execute(orders)
        sum1 = 0
        lis = []
        for (order_id, product_id, quantity, product_id, name, quantity_in_stock, unit_price) in cursor:
            temp = {}
            temp["product_id"] = product_id
            temp["name"] = name
            temp["quantity"] = quantity
            temp["unit_price"] = float(unit_price)
            temp["total"] = float(unit_price*quantity)
            sum1 += unit_price*quantity
            lis.append(temp)
        cursor.close()
        cnx.close()
        return json.dumps({"csv": lis, "total": str(sum1)})
    except:
        return json.dumps({"added": "error"})


@app.route('/createOrder/<longString>/<empId>')
def createOrder(longString, empId):
    try:
        cnx = startConnection()
        cursor = cnx.cursor()
        today = time.strftime('%Y-%m-%d')
        add_order =f'INSERT INTO orders (employee_id, order_date) VALUES ({int(empId)}, \"{today}\")'
        print(add_order)
        cursor.execute(add_order)
        order_no = cursor.lastrowid
        cnx.commit()
        cursor.close()
        cnx.close()
        parts1 = longString[:-1].split(":")
        for newString in parts1:
            dicc = {}
            parts2 = newString.split("_")
            dicc["quantity"]= parts2[1]
            dicc["id"]= parts2[0]
            cnx = startConnection()
            cursor = cnx.cursor()
            add_order_item =f'INSERT INTO order_items (order_id, product_id, quantity) VALUES ({int(order_no)}, {int(dicc["id"])}, {int(dicc["quantity"])} )'
            print(add_order_item)
            cursor.execute(add_order_item)
            cnx.commit()
            cursor.close()
            cnx.close()
        cnx = startConnection()
        cursor = cnx.cursor()
        orders = f'SELECT * from order_items JOIN products ON products.product_id = order_items.product_id WHERE order_items.order_id = {order_no}'
        cursor.execute(orders)
        sum1 = 0
        lis = []
        for (order_id, product_id, quantity, product_id, name, quantity_in_stock, unit_price) in cursor:
            temp = {}
            temp["product_id"] = product_id
            temp["name"] = name
            temp["quantity"] = quantity
            temp["unit_price"] = float(unit_price)
            temp["total"] = float(unit_price*quantity)
            sum1 += unit_price*quantity
            lis.append(temp)
        cursor.close()
        cnx.close()
        return json.dumps({"csv": lis, "total": str(sum1)})
    except:
        return json.dumps({"added": "error"})

