package WebService::CloudFlare::Host;
use Moose;
use Try::Tiny;
use Data::Dumper;
use LWP;

has 'host_key' => (
    is          => 'rw',
    isa         => 'Str',
    required    => 1,
);

has 'base_api'  => (
    is          => 'ro',
    isa         => 'Str',
    default     => 'https://api.cloudflare.com/host-gw.html',
);

has 'user_agent' => (
    is          => 'ro',
    isa         => 'Str',
    default     => 'WebService::CloudFlare::Host/1.0',
);

has 'http_timeout' => (
    is          => 'ro',
    isa         => 'Int',
    default     => 60,
);

has 'ua'        => (
    is          => 'ro',
    isa         => 'LWP::UserAgent',
    lazy_build  => 1,
);

sub call {
    my ( $self, $class, %args ) = @_;

    # Load the request class.
    try {
        Class::MOP::load_class("WebService::CloudFlare::Host::Request::$class");
    } catch {
        $self->_throw_exception( $_, "Loading request class: $class", 
            "Class::MOP::load_class", 
            "WebService::CloudFlare::Host::Request::$class"
        );
    };

    # Create the request object.
    my $req = try {
        "WebService::CloudFlare::Host::Request::$class"->new( %args )
    } catch {
        $self->_throw_exception( $_, 'Creating API Request',
            "WebService::CloudFlare::Host::Request::$class", Dumper \%args
        );
    };

    # Make the actual HTTP request.
    my $http_res = try {
        $self->_do_call( $req );
    } catch {
        $self->_throw_exception( $_, 'Making HTTP Call To Server API',
            'WebService::CloudFlare::Host::do_call', Dumper $req
        );
    };

    # Create a response object to send back to the user.
    my $res = try {
        $self->_create_response( $class, $http_res );
    } catch {
        $self->_throw_exception( $_, 'Creating API Response From HTTP Data',
            'WebService::CloudFlare::Host::create_response', Dumper $http_res,
        );
    };
    return $res;
}

sub _throw_exception {
    my ( $self, $message, $layer, $function, $args ) = @_;

    # We installed ::Exception with the package, it's here.
    Class::MOP::load_class('WebService::CloudFlare::Host::Exception');

    # Let's get to the bottom of the exception...
    my $exception;
    while ( $message->isa( 'WebService::CloudFlare::Host::Exception' ) ) {
        $exception = $message;
        $message = $message->message;
    }
    die $exception if $exception;


    die WebService::CloudFlare::Host::Exception->new( 
        message  => $message,
        layer    => $layer,
        function => $function,
        args     => $args,
    );
}

sub _do_call {
    my ( $self, $request ) = @_;
    
    my %arguments = $request->as_post_params;
    $arguments{host_key} = $self->host_key;

    return $self->ua->post($self->base_api, \%arguments);
}

sub _create_response {
    my ( $self, $class, $http ) = @_;
    
    try {
        Class::MOP::load_class("WebService::CloudFlare::Host::Response::$class");
    } catch {
        $self->_throw_exception( $_, "Loading request class: $class", 
            "Class::MOP::load_class", 
            "WebService::CloudFlare::Host::Reponse::$class"
        );
    };

    return "WebService::CloudFlare::Host::Response::$class"->new( $http );

}

sub _build_ua {
    my ( $self ) = @_;
    return LWP::UserAgent->new(
        timeout => $self->http_timeout,
        user_agent => $self->user_agent
    );
}

1;

=head1 NAME

WebService::CloudFlare::Host - 

=head1 VERSION

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 API CALLS

=head2 UserCreate

=head2 UserAuth

=head2 UserLookup

=head2 ZoneCreate

=head2 ZoneDelete

=head2 ZoneLookup

=head1 CREATING API CALLS

=head2 Request Classes

=head2 Response Classes

=head1 AUTHOR

=head1 COPYRIGHT AND LICENSE

=head1 AVAILABILITY

=cut
