import json
from flask import Flask
app = Flask(__name__)


@app.route("/shards/<userid>")
def shard(userid=""):
    users = json.loads(open("usershards.json").read())
    print(userid)
    if users.get(userid) != None:
        print("Found user with cookie")
        return str(users.get(userid))
    else:
        return ""

