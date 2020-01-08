from flask import Flask,render_template,request
from flask_mysqldb import MySQL
from flask import jsonify

app = Flask(__name__)
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '@n00p007'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_DB'] = 'apartment'


mysql = MySQL(app)

@app.route('/', methods=['GET', 'POST'])
def index():
    return  render_template('login-page.html')

@app.route('/showList', methods=['GET', 'POST'])
def lpage():
    return  render_template('list-page.html')

@app.route('/showReport', methods=['GET', 'POST'])
def rpage():
    return  render_template('report-page.html')




    
@app.route('/render-user-creation', methods=['GET', 'POST'])
def renderusercreation():
    return  render_template('user-creation.html')

@app.route('/login', methods=['POST'])
def login():
    usr = request.form.get('username')
    passw = request.form.get('password')
    cur = mysql.connection.cursor()
    cur.execute("select * from user_details where username=%s and password=%s",[usr.strip(),passw.strip()])
    data = cur.fetchall()
    cur.close()
    if len(data) > 0:
     return render_template('menu-page.html',useridx = data[0][2])
    else:
     return render_template('login-page-error.html')
    
@app.route('/signup', methods=['POST'])
def signup():
    usr = request.form.get('username')
    passw = request.form.get('password')
    email = request.form.get('email')
    cur = mysql.connection.cursor()
    cur.execute("select * from user_details where username=%s or email=%s",[usr.strip(),email.strip()])
    data = cur.fetchall()

    if len(data) == 0:
        cur.execute("insert into user_details (email,username,password) values (%s,%s,%s)",(email,usr,passw))
        mysql.connection.commit()
        cur.close()
        return render_template('login-page.html')
    else:
        cur.close()
        return render_template('user-creation-error.html')   

@app.route('/get-all', methods=['get'])
def getalldetails():
    cur = mysql.connection.cursor()
    cur.execute("select apd.apar_id,apd.name,apd.image_url,apd.image_t_url,apd.bedrooms,apd.floor_area,apd.thermal_isolation,apd.price,apd.details,bk.userid,bk.apar_id,bk.status from apartment_details apd left join  booking bk on  apd.trans_id=bk.booking_id  left  join user_details usr on  bk.userid = usr.userid; ")
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/get-thermal-unique', methods=['get'])
def thermal():
    cur = mysql.connection.cursor()
    cur.execute("select distinct thermal_isolation from apartment_details")
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/get-bedroom-unique', methods=['get'])
def bedroom():
    cur = mysql.connection.cursor()
    cur.execute("select distinct bedrooms  from apartment_details")
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/get-area-unique', methods=['get'])
def area():
    cur = mysql.connection.cursor()
    cur.execute("select distinct floor_area  from apartment_details")
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/filter', methods=['get'])
def filter():
    bedr=  request.args.get('bedroom')
    ther = request.args.get('thermal')
    area = request.args.get('area')
    filterstring = ""
    
    if area != "any":
        # area_f = float(request.args.get('area'))
        filterstring+=" floor_area ="+ area +" and "
    else:
         filterstring+=" floor_area is not null and "

    if ther != "any":
        # ther_b = bool(request.args.get('thermal'))
        filterstring +=" thermal_isolation ="+ther+" and "
    else:
        filterstring +=" thermal_isolation is not null "

    
    if bedr != "any":
        # bedr_i = int(request.args.get('bed'))
        filterstring +=" bedrooms ="+bedr
    else:
        filterstring +=" bedrooms is not null"

        
    cur = mysql.connection.cursor()
    cur.execute("select apd.apar_id,apd.name,apd.image_url,apd.image_t_url,apd.bedrooms,apd.floor_area,apd.thermal_isolation,apd.price,apd.details,bk.userid,bk.apar_id,bk.status from apartment_details apd left join  booking bk on  apd.apar_id=bk.apar_id  left  join user_details usr on  bk.userid = usr.userid where"+filterstring) 
    data = cur.fetchall()
    cur.close()
    return jsonify(data)

@app.route('/book', methods=['GET'])
def updatestatus():
        userid =  request.args.get('userid')
        bs = request.args.get('bookstatus')
        ap_id = request.args.get('apar_id')
        print(userid)
        cur = mysql.connection.cursor()
        cur.execute("""insert into booking (userid,apar_id,status)values (%s,%s,%s);""",(userid,ap_id,bs))
        cur.execute("update apartment_details set trans_id =%s where apar_id = %s;",(cur.lastrowid,ap_id))
        mysql.connection.commit()
        data = cur.fetchall()
        print(data)
        return 'success'

@app.route('/get-most-expensive-apart', methods=['get'])
def getexpensiveapart():
    userid =  request.args.get('userid')
    cur = mysql.connection.cursor()
    cur.execute("select apd.name,apd.image_url,apd.image_t_url,count(apd.apar_id) ,sum(apd.price) from booking bk inner join apartment_details apd on apd.apar_id = bk.apar_id inner join user_details usr on usr.userid = bk.userid  where bk.userid = %s and bk.status = 1 group by apd.apar_id ,apd.name;",(userid))
    data = cur.fetchall()
    cur.close()
    return jsonify(data)     

@app.route('/get-frequent-flats', methods=['get'])
def getfrequentflats():
    userid =  request.args.get('userid')
    cur = mysql.connection.cursor()
    cur.execute("select apd.name,apd.image_url,image_t_url,count(apd.apar_id) ,apd.price from booking bk inner join apartment_details apd on apd.apar_id = bk.apar_id inner join user_details usr on usr.userid = bk.userid  where bk.userid = %s and bk.status = 1 group by apd.apar_id ,apd.name,apd.price order by apd.price",(userid))
    data = cur.fetchall()
    cur.close()
    return jsonify(data)    

@app.route('/get-current-apart', methods=['get'])
def getcurrentaprt():
    userid =  request.args.get('userid')
    cur = mysql.connection.cursor()
    cur.execute("select apd.apar_id,apd.name,apd.image_url,apd.image_t_url,apd.bedrooms,apd.floor_area,apd.thermal_isolation,apd.price,apd.details,bk.userid,bk.apar_id,bk.status from apartment_details apd inner join booking bk on bk.booking_id = apd.trans_id where bk.userid = %s and bk.status = 1",(userid))
    data = cur.fetchall()
    cur.close()
    return jsonify(data) 


if __name__ == '__main__':
    app.run()
