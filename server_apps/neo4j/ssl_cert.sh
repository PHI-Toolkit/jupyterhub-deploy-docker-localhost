#!/bin/bash
# Generate SSL certificates for Neo4J
openssl x509 -outform der -in ../secrets/jupyter.pem -out ../secrets/neo4j.cert
cp ../secrets/jupyter.key ../secrets/neo4j.key
