import sympy
import logging

logging.basicConfig(format= '{date: %(asctime)s, level: %(levelname)s, message: %(message)s}',level=logging.INFO , filename="logs.log")

print("Enter filename")
nameFile = input()

try:
    file= open(nameFile,'r')
except IOError as error:
    print(str(error))
else:
    with file:
        for line in file:
            result = {
                'equation': line,
                'solve': sympy.solve(line)
            }
            logging.info(result)