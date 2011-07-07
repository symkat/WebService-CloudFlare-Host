package WebService::CloudFlare::Host::Response::ZoneDelete;
use Moose;
with 'WebService::CloudFlare::Host::Role::Response';

sub res_map {
    return (
        'result'        => 'result',
        'msg'           => 'msg',
        'action'        => 'request:act',
        'zone_name'     => 'response:zone_name',
        'zone_deleted'  => 'response:zone_deleted',
    );
}



has [qw/ result action /] 
    => ( is => 'rw', isa => 'Str', required => 1 );

has [qw/ msg zone_name zone_deleted /] 
    => ( is => 'rw', isa => 'Str', required => 0 );

1;
