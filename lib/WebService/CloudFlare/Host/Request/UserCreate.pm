package WebService::CloudFlare::Host::Request::UserCreate;
use Moose;

has 'map' => (
    is => 'ro',
    isa => 'HashRef[Str]',
    init_arg => undef,
    default => sub {{
        act                     => 'action',
        cloudflare_email        => 'email',
        cloudflare_pass         => 'pass',
        cloudflare_username     => 'user',
        unique_id               => 'unique_id',
        clobber_unique_id       => 'clobber',
    }},
);

has 'action' => ( 
    is => 'ro',
    isa => 'Str', 
    init_arg => undef, 
    default => 'user_create' 
);


has 'email'     => ( is => 'ro', isa => 'Str', required => 1);
has 'pass'      => ( is => 'ro', isa => 'Str', required => 1);
has 'user'      => ( is => 'ro', isa => 'Str', required => 0);
has 'unique_id' => ( is => 'ro', isa => 'Str', required => 0);
has 'clobber'   => ( is => 'ro', isa => 'Str', required => 0);

1;
