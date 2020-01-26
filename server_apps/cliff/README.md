# Processing Geographic Locations from Unstructured Text

## CLIFF-CLAVIN server

Learn more about the CLIFF server here: https://github.com/mitmedialab/CLIFF, and here: https://cliff.mediacloud.org/. CLIFF server uses Geonames, CLAVIN and the Stanford Named Entity Recognizer to create a lightweight geoparser for unstructured text.

### Citation for CLIFF-CLAVIN

*D’Ignazio, C., Bhargava, R., Zuckerman, E., & Beck, L. (2014). CLIFF-CLAVIN: Determining geographic focus for news. In NewsKDD: Data Science for News Publishing, at KDD 2014. New York, NY, USA.*

## Steps to Build CLIFF-CLAVIN server

1. Build the docker image: docker-compose -f docker-compose-cliff.yml build
2. Start up the Docker container (takes a while to build): docker-compose -f docker-compose-cliff.yml up -d
3. Monitor the progress of the build: docker-compose -f docker-compose-cliff.yml logs -t -f --tail='all'
4. Continue to run in the background: Press Ctrl-C, the CLIFF-CLAVIN server will be running in the background.

## Python Client

Learn more about the Python client here: https://pypi.org/project/mediacloud-cliff/
