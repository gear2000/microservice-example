#!/usr/bin/env python3

import requests

from json import dumps
from random import random
from flask import Flask
from flask import jsonify

from flask_restful import Resource
from flask_restful import reqparse
from flask_restful import Api

app = Flask(__name__)
api = Api(app)

class TransformInsertsRandString(Resource):

    """
    A class used to receive a string, transform it,
    insert a random number, and return the results
    ...

    Attributes
    ----------
    Methods
    -------
    _get_random_num()
        returns a random number that is a float
    _post_transform_message(message)
        makes a call to get the transformed message
    post()
         receives a message, makes a post with 
         message to have it transform, inserts a
         random number, and returns the result
    """

    def __init__(self):
  
        self.classname = "TransformInsertsRandString"
        self.http_endpt = "http://transform"
        self.http_port = "8081"

    def _get_random_num(self,length=None):

        """Generates and returns random number

        Parameters
        ----------
        length : int
            The length of the significant numbers to return in the float

        Returns
        -------
        float
            a random number that is a float
        """

        try:
            length = int(length)
        except:
            length = None

        _rand_num = random()

        if length and length > 1: 

            print("attempting to return length {}".format(length))

            try:
                _rand_num = float(str(_rand_num)[0:length])
            except:
                print("Could not adjust length of random number")

        return _rand_num

    def _post_transform_message(self,message):

        """makes an http port to microservice
        "transform" with the message and gets the
        transformed message.

        Parameters
        ----------
        message : str
            The message to send for transformation

        Returns
        -------
        str
            transformed message
        """
    
        inputargs = {"timeout":30}
        inputargs["headers"] = {'Content-type': 'application/json' }
        inputargs["data"] = dumps({"message":message})

        _endpoint = "{}:{}/reverse".format(self.http_endpt,self.http_port)
        _req = requests.post(_endpoint,**inputargs)

        if int(_req.status_code) != 200: return

        return _req.json()["message"]

    def post(self):

        """parses the http post and gets the mesage. 
        makes a call to the microservice transform to 
        transform the message, inserts a random number, 
        and returns the result

        Returns
        -------
        json
            contains the transformed(reverse string) 
            and a random number
        """

        parser = reqparse.RequestParser()
        parser.add_argument('message', type=str, required=True, location='json')

        args = parser.parse_args()
        message = args["message"]

        _transform_str = self._post_transform_message(message)

        rand = self._get_random_num()

        results = { "rand":rand,
                    "message":_transform_str }

        return jsonify(results)

api.add_resource(TransformInsertsRandString, '/api')

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=8080,debug=True)
