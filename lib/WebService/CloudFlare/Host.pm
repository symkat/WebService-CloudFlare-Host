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

WebService::CloudFlare::Host - A client API For Hosting Partners 

=head1 VERSION

000100 (0.1.0)

=head1 SYNOPSIS

    my $CloudFlare = WebService::CloudFlare::Host->new(
        host_key => 'cloudflare hostkey',
        timeout  => 30,
    );

    my $response = eval { $CloudFlare->call('UserCreate',
        email => 'richard.castle@hyperionbooks.com',
        pass  => 'ttekceBetaK',
    ) };

    if ( $@ ) {
        die "Error: in " . $@->function . ": " . $@->message;
    }


    printf("Got API Keys: User Key: %s, User API Key: %s",
        $response->user_key, $response->api_key
    );

=head1 DESCRIPTION

WebService::CloudFlare::Host is a client side API library
to make using CloudFlare simple for hosting providers.

It gives a simple interface for making API calls, getting
response objects, and implementing additional API calls.

All API calls have a Request and Response object that define
the accepted information for that call.

=head1 METHODS

The only method used is C<call($api_call, %arguments)>.

When making an API call the first argument defines the API request
to load.  This is loaded from Request::.  Additional arguments are
passed as-is to the Request Object.

Once the object has been made, an HTTP call to the CloudFlare API
is made.  The JSON returned is used to construct a Response object
loaded from Response:: with the same name as the Request object.

C<call> dies on error giving a WebService::CloudFlare::Host::Exception
object and should be run in an eval or with Try::Tiny.

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
