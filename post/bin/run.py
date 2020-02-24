#!/usr/bin/env python3

from flask import Flask
#from flask import jsonify
#from flask import current_app as app

from flask_restful import Resource
from flask_restful import reqparse
from flask_restful import Api

app = Flask(__name__)
api = Api(app)

class PostEndpoint(Resource):

    """
    A class that accepts a http post
    ...

    Attributes
    ----------
    Methods
    -------
    post()
         receives a http post 
    """

    def __init__(self):
        self.classname = "PostEndpoint"

    def post(self):

        """parses the http post

        Returns
        -------
        True
        """

        parser = reqparse.RequestParser()
        args = parser.parse_args()

        app.logger.info("Receives an HTTP post at /ad-event with args {}".format(args))

        return True

api.add_resource(PostEndpoint, '/ad-event')

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=8081,debug=True)
