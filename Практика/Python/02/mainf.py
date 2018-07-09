#   2018, Maxim Degtyarev
#   My life...My rules
#
from database import Database
import sympy
import time

print("Enter filename")
nameFile = input()

try:
    file = open(nameFile,'r')
except IOError as error:
    print(str(error))
else:
    with file:
        for line in file:
            try:
                result = sympy.solve(str(line))
                Database.callFunction("ex_addeq", str(line), str(result))
                nowid = Database.callFunction("ex_getidbyeq", str(line))
                nowid = nowid[0][0]
                #Получили nowid, добавляем в базу данных логов
                rezstr = {
                    "equation": line,
                    "result" : result
                }
                Database.callFunction("ex_addlog", nowid, str(rezstr),time.strftime("%H:%M:%S"))
            except Exception as err:
                print("Hmmm...Some error")
                print(str(err))
                Database.callFunction("ex_addeq", str(line) + "-> error", "Some Error")
                nowid = Database.callFunction("ex_getidbyeq", str(line) + "-> error")
                nowid = nowid[0][0]
                rezstr = str("{Error: " + str(err) + " }")
                Database.callFunction("ex_addlog", int(nowid), rezstr, time.strftime("%H:%M:%S"))
