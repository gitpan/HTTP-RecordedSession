package HTTP::RecordedSession;
use strict;
use vars qw( $VERSION );
$VERSION = '0.03';

sub new {
    my ( $proto ) = shift;
    my ( $config_id ) = shift;
    my ( $class ) = ref( $proto ) || $proto;
    my ( $self )  = {};
    bless( $self, $class ); 
    $self->_init( $config_id );
    return $self;
}

sub _init {
    my ( $self ) = shift;
    my ( $config_id ) = shift;

    #Assign values
    $self->{ CONFIG_ID } = $config_id;
    $self->{ CLICK_AREF } = $self->_deserialize_clicks; 
}

sub get_id {
    my ( $self ) = shift;
    return $self->{ CONFIG_ID };
}

sub get_clicks {
    my ( $self ) = shift;
    return $self->{ CLICK_AREF };
}

sub _deserialize_clicks {
    my ( $self ) = shift;

    use Storable qw( lock_retrieve );
    my ( $file_path ) = "/usr/tmp/" . "recorder_conf_" . $self->{ CONFIG_ID };
    my ( $hashref ) = lock_retrieve( $file_path );

    my ( @session );
    my ( @keys ) = sort keys %$hashref;
    foreach my $key ( @keys ) {
	push( @session, [ $hashref->{ $key } ] );
    }
    return \@session;
}

1;

=head1 NAME

HTTP::RecordedSession - Class to interface with serialized clicks from Apache::Recorder

=head1 SYNOPSIS

use strict;

use HTTP::RecordedSession;

use HTTP::Monkeywrench;

my ( $config_id ) = '1WFmxpCj';  #TestEngineID from recorder.pl

my ( $conf ) = new HTTP::RecordedSession( $config_id );

my ( @clicks ) = @{ $conf->get_clicks };

my ( %settings ) =

    (
	
	show_cookies => '1',

	print_results => '1'
	    
    );

my ( $wrench ) = HTTP::Monkeywrench->new( \%settings );

#To test from a web browser, uncomment the following line.
#print "Content-type:text/html\n\n";

$wrench->test( @clicks );

=head1 DESCRIPTION

HTTP::RecordedSession will correctly format the output of Apache::Recorder for a script that uses HTTP::Monkeywrench.


=head1 AUTHOR

Chris Brooks <cbrooks@organiccodefarm.com>

=head1 SEE ALSO

Apache::Recorder

HTTP::Monkeywrench

=cut
