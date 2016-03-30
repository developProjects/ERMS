from http.server import HTTPServer,BaseHTTPRequestHandler  
import io,shutil,urllib  
import pymysql.cursors

connection = pymysql.connect(host='localhost',
                                 user='alan',
                                 password='25518115a',
                                 db='test',
                                 charset='utf8mb4',
                                 cursorclass=pymysql.cursors.DictCursor)

class MyHttpHandler(BaseHTTPRequestHandler):  
    def do_GET(self):
        acct_no = 'null'
        credit_name = 'null'
        function = 'null'
        group_name = 'null'
        group_type = 'null'
        pageSize = 'null'
        action = 'null'
        ccd_id = 'null'
        page = 'null'

        if '?' in self.path:
            self.queryString = urllib.parse.unquote(self.path.split('?',1)[1])   
            params = urllib.parse.parse_qs(self.queryString)  

            function = params["function"][0] if "function" in params else None
            group_name = params["group_name"][0] if "group_name" in params else None
            group_type = params["group_type"][0] if "group_type" in params else None
            acct_no = params["acct_no"][0] if "acct_no" in params else None
            credit_name = params["credit_name"][0] if "credit_name" in params else None
            pageSize = params["pageSize"][0] if "pageSize" in params else None
            action = params["action"][0] if "action" in params else None
            ccd_id = params["ccd_id"][0] if "ccd_id" in params else None
            page = params["page"][0] if "page" in params else None

        if function == 'enquiry_loan_sub_participation_ratio':
            with connection.cursor() as cursor:
                # Read records

                sql = ""

                sql = "select count(*) as total from enquiry_loan_sub_participation_ratio"

                cursor.execute(sql)

                count = cursor.fetchone()
                totalRow = count["total"]
                start = 1
                end = 5
                
                if acct_no is None:
                    print("PAGE -----------> ", page)

                    if page == None:
                        page = 1

                    if int(page) > 1:
                        start = 5
                        end = 10

                    sql = "select * from enquiry_loan_sub_participation_ratio where Client_Name like %s order by client_name limit %d, %d" % ("\'"+credit_name+"\'",start, end)

                    cursor.execute(sql)
                else:
                    sql = "select * from enquiry_loan_sub_participation_ratio where Account_No = %s limit %d, %d" % ("\'"+acct_no+"\'", 1, 5)

                    cursor.execute(sql, (acct_no))

                # else:
                #     sql = "select * from enquiry_loan_sub_participation_ratio"
                #     cursor.execute(sql)

                jsonFormat = "["
                
                result = cursor.fetchall()

                for i in range(totalRow):
                    try:
                        jsonFormat += "{\"Credit_Group\":\"" + result[i]['Credit_Group'] + "\","
                        jsonFormat += "\"Client_Name\":\"" + result[i]['Client_Name'] + "\","
                        jsonFormat += "\"Source_System\":\"" + result[i]['Source_System'] + "\","
                        jsonFormat += "\"Account_No\":\"" + result[i]['Account_No'] + "\","
                        jsonFormat += "\"Sub_Acc\":\"" + result[i]['Sub_Acc'] + "\","
                        jsonFormat += "\"Account_Name\":\"" + result[i]['Account_Name'] + "\","
                        jsonFormat += "\"Acc_Entity\":\"" + result[i]['Acc_Entity'] + "\","
                        jsonFormat += "\"Limit_Type\":\"" + result[i]['Limit_Type'] + "\"},"
                    except IndexError as ie:
                        jsonFormat += "{\"Credit_Group\":\"" + "null" + "\","
                        jsonFormat += "\"Client_Name\":\"" + "null" + "\","
                        jsonFormat += "\"Source_System\":\"" + "null" + "\","
                        jsonFormat += "\"Account_No\":\"" + "null" + "\","
                        jsonFormat += "\"Sub_Acc\":\"" + "null" + "\","
                        jsonFormat += "\"Account_Name\":\"" + "null" + "\","
                        jsonFormat += "\"Acc_Entity\":\"" + "null" + "\","
                        jsonFormat += "\"Limit_Type\":\"" + "null" + "\"},"
                
                jsonObject = jsonFormat[0:len(jsonFormat)-1]
                jsonObject += "]"

            # Simulate the JSON response   
            # r_str=jsonObject

            # enc="UTF-8" 
            # encoded = ''.join(r_str).encode(enc)  
            # f = io.BytesIO()  
            # f.write(encoded)  
            # f.seek(0)  
            # self.send_response(200)  
            # self.send_header("Content-type", "text/html; charset=%s" % enc)  
            # self.send_header("Content-Length", str(len(encoded)))  
            # self.send_header("Access-Control-Allow-Origin","*")
            # self.end_headers()  
            # shutil.copyfileobj(f,self.wfile)

        if function == 'group_maintenance':
            with connection.cursor() as cursor:
                # Read records

                # sql = ""
                if group_name != '%%':   
                    sql = "select * from group_maintenance where Group_Name like %s"
                    print(sql)
                    cursor.execute(sql, (group_name))
                # else:
                elif group_type != '%%':
                    sql = "select * from group_maintenance where group_type like %s"
                    print(sql)
                    cursor.execute(sql, (group_type))
                else:
                    sql = "select * from group_maintenance"
                    print(sql)
                    cursor.execute(sql)         

                # else:
                #     sql = "select * from group_maintenance"
                #     cursor.execute(sql)
 
                jsonFormat = "["
                
                result = cursor.fetchall()

                for i in range(len(result)):
                    jsonFormat += "{\"Group_Name\":\"" + result[i]['Group_Name'] + "\","
                    jsonFormat += "\"Group_Type\":\"" + result[i]['Group_Type'] + "\","
                    jsonFormat += "\"External_Key_ID_1\":\"" + result[i]['External_Key_ID_1'] + "\","
                    jsonFormat += "\"External_Key_ID_2\":\"" + result[i]['External_Key_ID_2'] + "\","
                    jsonFormat += "\"External_Key_ID_3\":\"" + result[i]['External_Key_ID_3'] + "\","
                    jsonFormat += "\"External_Key_ID_4\":\"" + result[i]['External_Key_ID_4'] + "\","
                    jsonFormat += "\"External_Key_ID_5\":\"" + result[i]['External_Key_ID_5'] + "\","
                    jsonFormat += "\"External_Key_ID_6\":\"" + result[i]['External_Key_ID_6'] + "\","
                    jsonFormat += "\"External_Key_ID_7\":\"" + result[i]['External_Key_ID_7'] + "\","
                    jsonFormat += "\"External_Key_ID_8\":\"" + result[i]['External_Key_ID_8'] + "\","
                    jsonFormat += "\"External_Key_ID_9\":\"" + result[i]['External_Key_ID_9'] + "\","
                    jsonFormat += "\"External_Key_ID_10\":\"" + result[i]['External_Key_ID_10'] + "\","
                    jsonFormat += "\"last_update\":\"" + result[i]['last_update'] + "\","
                    jsonFormat += "\"Updated_by\":\"" + result[i]['Updated_by'] + "\","
                    jsonFormat += "\"action\":\"" + result[i]['action'] + "\"},"
                
                jsonObject = jsonFormat[0:len(jsonFormat)-1]
                jsonObject += "]"

        if function == 'group_detail_maintenance':
            with connection.cursor() as cursor:

                sql = "select * from group_member where ccd_id = %s"    
                print(sql)
                cursor.execute(sql, {ccd_id})        

                jsonFormat = "["
                
                result = cursor.fetchall()

                for i in range(len(result)):
                    jsonFormat += "{\"ccd_id\":\"" + result[i]['ccd_id'] + "\","
                    jsonFormat += "\"client_counterparty\":\"" + result[i]['client_counterparty'] + "\","
                    jsonFormat += "\"account_no\":\"" + result[i]['account_no'] + "\","
                    jsonFormat += "\"sub_acc\":\"" + result[i]['sub_acc'] + "\","
                    jsonFormat += "\"account_name\":\"" + result[i]['account_name'] + "\","
                    jsonFormat += "\"biz_unit\":\"" + result[i]['biz_unit'] + "\"},"
                
                jsonObject = jsonFormat[0:len(jsonFormat)-1]
                jsonObject += "]"

        # Simulate the JSON response   
        r_str = jsonObject
        enc="UTF-8" 
        encoded = ''.join(r_str).encode(enc)    
        f = io.BytesIO()  
        f.write(encoded)  
        f.seek(0)  
        self.send_response(200)  
        self.send_header("Content-type", "text/html; charset=%s" % enc)  
        self.send_header("Content-Length", str(len(encoded)))  
        self.send_header("Access-Control-Allow-Origin","*")
        self.end_headers()  
        shutil.copyfileobj(f,self.wfile)
       
    def do_POST(self):  
        s=str(self.rfile.readline(),'UTF-8')
        print(urllib.parse.parse_qs(urllib.parse.unquote(s)))  
        self.send_response(200)  
        self.send_header("Location", "/?"+s)  
        self.end_headers()  

try:
     
    httpd=HTTPServer(('',8080),MyHttpHandler)  
    print("Server started on 127.0.0.1,port 8080.....")  
    httpd.serve_forever()  

except Exception as e:
    raise e
finally:
    connection.close()
