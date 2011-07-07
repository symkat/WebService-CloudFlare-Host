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
        $self->throw_exception( $_, "Loading request class: $class", 
            "Class::MOP::load_class", 
            "WebService::CloudFlare::Host::Request::$class"
        );
    };

    # Create the request object.
    my $req = try {
        "WebService::CloudFlare::Host::Request::$class"->new( %args )
    } catch {
        $self->throw_exception( $_, 'Creating API Request',
            "WebService::CloudFlare::Host::Request::$class", Dumper \%args
        );
    };

    # Make the actual HTTP request.
    my $http_res = try {
        $self->_do_call( $req );
    } catch {
        $self->throw_exception( $_, 'Making HTTP Call To Server API',
            'WebService::CloudFlare::Host::do_call', Dumper $req
        );
    };

    # print Dumper $http_res;
    #print "------------------------------------\n";
    #print $http_res->content;
    
    # Create a response object to send back to the user.
    my $res = try {
        $self->_create_response( $class, $http_res );
    } catch {
        $self->throw_exception( $_, 'Creating API Response From HTTP Data',
            'WebService::CloudFlare::Host::create_response', Dumper $http_res,
        );
    };
    return $res;
}

sub throw_exception {
    my ( $self, $message, $layer, $function, $args ) = @_;

    # We installed ::Exception with the package, it's here.
    Class::MOP::load_class('WebService::CloudFlare::Host::Exception');

    die WebService::CloudFlare::Host::Exception->new( 
        message  => $message,
        layer    => $layer,
        function => $function,
        args     => $args,
    );
}

sub _do_call {
    my ( $self, $request ) = @_;
    
    my %arguments = map { my $v = $request->{$request->map->{$_}}; 
        defined($v) ? ($_ => $v) : ()
    } keys %{$request->map};
    $arguments{host_key} = $self->host_key;
    
    return $self->_http_post( $self->base_api, \%arguments );
}

sub _http_post {
    my ( $self, $url, $post_data ) = @_;
    my $res = $self->ua->post( $url, $post_data );
    return $res;
}  

sub _create_response {
    my ( $self, $class, $http ) = @_;
    
    try {
        Class::MOP::load_class("WebService::CloudFlare::Host::Response::$class");
        print "Loaded class";
    } catch {
        $self->throw_exception( $_, "Loading request class: $class", 
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
