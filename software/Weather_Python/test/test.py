import sys
import os

os.system("cp ./"+sys.argv[1]+"/data.txt ./data/data.txt")

print(os.popen("cat ./data/data.txt").read())

