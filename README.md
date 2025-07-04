# to.science.jsonSchema
JSON Schemas for the bibliographic metadata format toscience JSON

# Usage
git clone https://github.com/hbz/to.science.jsonSchemuse constant SCHEMAS => qw/ simpleObject /; 
cd to.science.jsonSchema

Edit schemas: simpleObject.schema.json, toscience.schema.json

Or add more schemas. Add more schemas also to validateModern.pl, to the line 

"use constant SCHEMAS => qw/ simpleObject, myObject, ... /;"

Edit the sample JSON file that should be validated against the schemas, simple_example.toscience.json

Or add your own JSON files that you want to be validated.

Validate a sample JSON file against the set of schemas (they should reference each other) like this:

validateModern.pl simple_example.toscience.json

validateModern.pl myJsonFile.toscience.json
