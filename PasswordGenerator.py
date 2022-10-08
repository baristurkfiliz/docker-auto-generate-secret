import sys
import secrets

byte_number = int(sys.argv[1])
c_set_1 = "abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ"
c_set_2 = "123456789|\!$&/()'?^~[=]}%{+*@#<>,;.:-_"
charset = c_set_1 + c_set_2
password = "".join((secrets.choice(charset))
                   for x in range(byte_number))
print(password)