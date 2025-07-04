#!/usr/bin/perl -w
# Validiert eine JSON-Datei gegen ein oder mehere JSON-Schemata (=> gegen toscience-JSON)
# Autor: I. Kuss, hbz, 30.06.2025
# Usage: perl $0 <JSON-Datei>

use strict;
## Dokumentation: https://github.com/karenetheridge/JSON-Schema-Modern
use JSON;
use JSON::Schema::Modern;
use JSON::Schema::Modern::Document;
use Path::Tiny;  # für Dateioperationen
# Hier eine Liste aller von toscience abhängigen Schemata:
use constant SCHEMAS => qw/ simpleObject /;

my $js = JSON::Schema::Modern->new(
  specification_version => 'draft2020-12',
  output_format => 'flag',
  strict => 1
);
# Einlesen und prüfen aller abhängigen Schemata in einer Schleife
print "SCHEMATA:\n";
foreach my $schema ( (SCHEMAS) ) {
  print "$schema\n";
  my $schema_filename = "$schema.schema.json";
  open my $fh, '<', $schema_filename or die "ERROR opening schema $schema $!";
  my $schema_file = Path::Tiny::path($schema_filename);
  my $schemaString = do { local $/; <$fh> };
  #print "$schemaString\n";
  eval { decode_json ( $schemaString ) };
  if ($@)
  {
    print "decode_json failed, invalid json. error:$@\n";
  }
  my $schemaDocument = JSON::Schema::Modern::Document->new(
    canonical_uri => "https://www.hbz-nrw.de/toscience/$schema.schema.json",
    metaschema_uri => "https://json-schema.org/draft/2020-12/schema",
    schema => $schemaString
  );
  print $schemaDocument->TO_JSON . "\n";

  # Das Schema ist gültig und wird zum Validator hinzugefügt
  $js->add_schema(decode_json($schema_file->slurp_raw));
}

# Schließlich wird auch das Haupt-Schema hinzugefügt: toscience-JSON
print "toscience\n";
my $schema_filename = "toscience.schema.json";
my $schema_file = Path::Tiny::path($schema_filename);
print $schema_file->slurp_raw . "\n";

# Und nun der Datensatz, der validiert werden soll:
print "INSTANCE DATA: " . $ARGV[0] . "\n";
my $instance_file = Path::Tiny::path($ARGV[0]);
print $instance_file->slurp_raw . "\n";

# Hier die eigentliche Validierung:
my $result = $js->evaluate(decode_json($instance_file->slurp_raw), decode_json($schema_file->slurp_raw));

# Ausgabe der Ergebnisse:
print "instance data are valid: " . $result->valid . "\n";
foreach my $error ( $result->errors ) {
	print $error . "\n";
}
exit 0;
