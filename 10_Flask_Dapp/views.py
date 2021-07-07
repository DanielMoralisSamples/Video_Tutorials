import app
from flask import render_template
from flask import request, redirect, jsonify, make_response
import json

@app.route('/')
def index():
    return render_template("index.html")
