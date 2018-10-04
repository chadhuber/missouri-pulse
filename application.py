#!/usr/bin/env python

import os

from flask import Flask
application = Flask(__name__)

# elastic beanstalk expects application as callable
app = application

if os.environ.get("DEBUG", False):
  app.debug = True

from app import views
views.register(app)

from app import helpers
helpers.register(app)

if __name__ == "__main__":
    app.run(port=int(os.getenv("PORT", 5000)))
