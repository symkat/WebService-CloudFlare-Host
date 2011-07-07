package WebService::CloudFlare::Host::Response::UserLookup;
use Moose;
with 'WebService::CloudFlare::Host::Role::Response';

sub res_map {
    return (
        'result'        => 'result',
        'msg'           => 'msg',
        'action'        => 'request:act',
        'unique_id'     => 'response:unique_id',
        'user_exists'   => 'response:user_exists',
        'email'         => 'response:cloudflare_email',
        'user_authed'   => 'response:user_authed',
        'user_key'      => 'response:user_key',
        'zones'         => 'response:hosted_zones',
    );
}



has [qw/ result action /] 
    => ( is => 'rw', isa => 'Str', required => 1 );

has [qw/ msg unique_id user_exists cloudflare_email user_authed user_key  /] 
    => ( is => 'rw', isa => 'Str', required => 0 );

has [qw/ zones /]
    => ( is => 'rw', isa => 'ArrayRef[Str]', required => 0 );

1;
