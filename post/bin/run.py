#!/usr/bin/env python3

from flask import Flask
#from flask import jsonify
#from flask import current_app as app

from flask_restful import Resource
#from flask_restful import reqparse
from flask_restful import Api

app = Flask(__name__)
api = Api(app)

class GetEndpoint(Resource):

    """
    A class that accepts a http get
    ...

    Attributes
    ----------
    Methods
    -------
    get()
         receives a http get 
    """

    def __init__(self):
        self.classname = "GetEndpoint"

    def get(self):

        """parses the http get

        Returns
        -------
        True
        """
        app.logger.info("Receives an HTTP get at /ad")

        return True

api.add_resource(GetEndpoint, '/ad')

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=8081,debug=True)
