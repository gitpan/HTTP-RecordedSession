BEGIN { $| = 1; print "1..1\n"; }

END {print "not ok 2\n" unless $storable;}

use strict;
use vars qw( $storable );

use Storable;
$storable = 1;
print "ok 1\n";
