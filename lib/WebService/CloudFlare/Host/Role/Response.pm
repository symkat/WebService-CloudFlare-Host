package WebService::CloudFlare::Host::Role::Response;
use Moose::Role;
use JSON;

requires 'res_map';

sub BUILDARGS {
    my ( $class, $http ) = @_;
    
    die "HTTP Status " . $http->code . " returned, expected 200."
        unless $http->code == 200;

    my $json = decode_json( $http->content );
    my %map = $class->res_map;
    my $args = {};

    OUTER: for my $key ( keys %map ) {
        my ( @elems ) = split( ":", $map{$key} );
        my $tmp_json = $json;
        for my $elem ( @elems ) {
            next OUTER unless exists $tmp_json->{$elem};
            $tmp_json = $tmp_json->{$elem};
        }
        $args->{$key} = $tmp_json;
        #$self->$key($tmp_json);
    }
    return $args;
}

1;
