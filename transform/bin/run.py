#!/usr/bin/env python3

from flask import Flask
from flask import jsonify

from flask_restful import Resource
from flask_restful import reqparse
from flask_restful import Api

app = Flask(__name__)
api = Api(app)

class TransformString(Resource):

    """
    A class transform data by reversing 
    the string
    ...

    Attributes
    ----------
    Methods
    -------
    post()
         receives a message through http post
         and returns the message reversed

    _get_new_message(message)
         message is reversed as new message

    """

    def __init__(self):
        self.classname = "TransformString"

    def _get_new_message(self,message):
        """reverses message and returns it"""

        return message[::-1]

    def post(self):

        """parses the http post and gets the message 
        and makes a call to get a new message that
        is reversed

        Returns
        -------
        json
            contains the transformed(reverse string) 
        """

        parser = reqparse.RequestParser()
        parser.add_argument('message', type=str, required=True, location='json')
        args = parser.parse_args()

        results = { "message": self._get_new_message(args["message"]) }

        return jsonify(results)

api.add_resource(TransformString, '/reverse')

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=8081,debug=True)
