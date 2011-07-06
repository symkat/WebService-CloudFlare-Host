package WebService::CloudFlare::Host::Response::UserCreate;
use Moose;
use JSON;
use Data::Dumper;

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

has 'http'      => ( is => 'ro', isa => 'HTTP::Response', required => 1, clearer => 'unset_http' );

1;

sub BUILD {
    my ( $self ) = @_;

    die "HTTP Status " . $self->http->code . " returned, expected 200."
        unless $self->http->code == 200;

    my $json = decode_json( $self->http->content );

    my %map = $self->map;

    for my $key ( keys %map ) {
        my ( @elems ) = split(":", $map{$key});

        # This is dumb, how do I make it less dumb?
        if ( @elems == 1 ) {
            $self->$key( $json->{$elems[0]} )
                if exists $json->{$elems[0]};
        } elsif ( @elems == 2 ) {
            $self->$key( $json->{$elems[0]}->{$elems[1]})
                if exists $json->{$elems[0]}->{$elems[1]};
        } elsif ( @elems == 3 ) {
            $self->$key( $json->{$elems[0]}->{$elems[1]}->{$elems[2]})
                if exists $json->{$elems[0]}->{$elems[1]}->{$elems[2]};
        }
    }

    $self->unset_http;

}

__END__
sub BUILDARGS {
    my ( $class, $orig, $http ) = @_;
    print Dumper $class;
    print DUmper $http;
    my %new;

    die "HTTP Status " . $http->code . " returned, expected 200."
        unless $http->code == 200;

    my $json = decode_json( $http->content );

    my %map = $class->map;

    for my $key ( keys %map ) {
        my ( @elems ) = split(":", $map{$key});

        # This is dumb, how do I make it less dumb?
        if ( @elems == 1 ) {
            $new{$key} = $json->{$elems[0]};
        } elsif ( @elems == 2 ) {
            $new{$key} = $json->{$elems[0]}->{$elems[1]};
        } elsif ( @elems == 3 ) {
            $new{$key} = $json->{$elems[0]}->{$elems[1]}->{$elems[2]};
        }
    }
    return $class->new(%new);
    #return $class->$orig(%new);
}
1;
