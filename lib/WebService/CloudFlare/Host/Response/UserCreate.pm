package WebService::CloudFlare::Host::Response::UserCreate;
use Moose;
use JSON;

sub map {
    return (
        'result'        => 'result',
        'msg'           => 'msg',
        'action'        => 'request:act',
        'email'         => 'response:cloudflare_email',
        'user_key'      => 'response:user_key',
        'unique_id'     => 'response:unique_id',
        'username'      => 'response:cloudflare_username',
    );
}

has 'result'    => ( is => 'rw', isa => 'Str', required => 0 );
has 'msg'       => ( is => 'rw', isa => 'Str', required => 0 );
has 'action'    => ( is => 'rw', isa => 'Str', required => 0 );

has 'email'     => ( is => 'rw', isa => 'Str', required => 0 );
has 'user_key'  => ( is => 'rw', isa => 'Str', required => 0 );
has 'username'  => ( is => 'rw', isa => 'Str', required => 0 );
has 'unique_id' => ( is => 'rw', isa => 'Str', required => 0 );

sub BUILDARGS {
    my ( $class, $http ) = @_;
    
    die "HTTP Status " . $http->code . " returned, expected 200."
        unless $http->code == 200;

    my $json = decode_json( $http->content );
    my %map = $class->map;
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
