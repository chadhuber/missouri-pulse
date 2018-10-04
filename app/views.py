
from flask import render_template, Response
from app import models
from app.data import FIELD_MAPPING
import ujson

def register(app):

    @app.route("/")
    def index():
        return render_template("index.html")

    ##
    # Data endpoints.

    # High-level %'s, used to power the donuts.
    @app.route("/data/reports/<report_name>.json")
    def report(report_name):
        response = Response(ujson.dumps(models.Report.latest().get(report_name, {})))
        response.headers['Content-Type'] = 'application/json'
        return response


    # Detailed data per-domain, used to power the data tables.
    @app.route("/data/domains/<report_name>.<ext>")
    def domain_report(report_name, ext):
        domains = models.Domain.eligible(report_name)
        domains = sorted(domains, key=lambda k: k['domain'])

        if ext == "json":
          response = Response(ujson.dumps({'data': domains}))
          response.headers['Content-Type'] = 'application/json'
        elif ext == "csv":
          response = Response(models.Domain.to_csv(domains, report_name))
          response.headers['Content-Type'] = 'text/csv'
        return response


    @app.route("/https/domains/")
    def https_domains():
        return render_template("https/domains.html")


    @app.route("/https/guidance/")
    def https_guide():
        return render_template("https/guide.html")


    # Sanity-check RSS feed, shows the latest report.
    @app.route("/data/reports/feed/")
    def report_feed():
        return render_template("feed.xml")


    @app.errorhandler(404)
    def page_not_found(e):
      return render_template('404.html'), 404
