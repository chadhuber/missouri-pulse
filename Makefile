scss ?= static/scss/main.scss
css ?= static/css/main.css

all: styles

staging:
	cd deploy/ && fab deploy --set environment=staging && cd ..

production:
	cd deploy/ && fab deploy --set environment=production && cd ..

debug:
	DEBUG=true python pulse.py

styles:
	sass $(scss):$(css)

watch:
	sass --watch $(scss):$(css)

clean:
	rm -f $(css)

# Production data update process:
#
# Run a fresh scan, update the database, and upload data to S3.
update_production:
	python -m data.update --scan=here --upload

# Staging data update process:
#
# Download last production scan data, update the database.
update_staging:
	python -m data.update --scan=download

# Development data update process:
#
# Don't scan or download latest data (rely on local cache), update database.
update_development:
	python -m data.update --scan=skip

# downloads latest snapshot of data locally
data_init:
	mkdir -p data/output/scan/results/
	curl https://s3.amazonaws.com/pulse.cio.gov/live/scan/analytics.csv > data/output/scan/results/analytics.csv
	curl https://s3.amazonaws.com/pulse.cio.gov/live/scan/pshtt.csv > data/output/scan/results/pshtt.csv
	curl https://s3.amazonaws.com/pulse.cio.gov/live/scan/tls.csv > data/output/scan/results/tls.csv
	curl https://s3.amazonaws.com/pulse.cio.gov/live/scan/meta.json > data/output/scan/results/meta.json
	curl https://s3.amazonaws.com/pulse.cio.gov/live/db/db.json > data/db.json
