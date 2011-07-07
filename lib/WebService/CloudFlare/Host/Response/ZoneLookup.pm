package WebService::CloudFlare::Host::Response::ZoneLookup;
use Moose;
with 'WebService::CloudFlare::Host::Role::Response';

sub res_map {
    return (
        'result'        => 'result',
        'msg'           => 'msg',
        'action'        => 'request:act',
        'zone_name'     => 'response:zone_name',
        'zone_exists'   => 'response:zone_exists',
        'zone_hosted'   => 'response:zone_hosted',
        'hosted'        => 'response:hosted_cnames',
        'forward'       => 'response:forward_tos',
    );
}



has [qw/ result action /] 
    => ( is => 'rw', isa => 'Str', required => 1 );

has [qw/ msg zone_name zone_exists zone_hosted  /] 
    => ( is => 'rw', isa => 'Str', required => 0 );

has [qw/ hosted forward /]
    => ( is => 'rw', isa => 'HashRef[Str]', required => 0 );

1;
