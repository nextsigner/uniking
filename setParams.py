import sys

folder=sys.argv[1]
key=sys.argv[2]
folderQml=sys.argv[3]

filePath=folder+"/key"
data=key+'\n'
data+=folderQml


with open(filePath, 'w') as file:
    file.write(data)
    print("key saved data:"+data)

