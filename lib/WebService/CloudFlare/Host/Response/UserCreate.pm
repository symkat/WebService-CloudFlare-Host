package WebService::CloudFlare::Host::Response::UserCreate;
use Moose;
with 'WebService::CloudFlare::Host::Role::Response';

sub res_map {
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

has 'result'    => ( is => 'rw', isa => 'Str', required => 1 );
has 'msg'       => ( is => 'rw', isa => 'Str', required => 1 );
has 'action'    => ( is => 'rw', isa => 'Str', required => 1 );

has 'email'     => ( is => 'rw', isa => 'Str', required => 0 );
has 'user_key'  => ( is => 'rw', isa => 'Str', required => 0 );
has 'username'  => ( is => 'rw', isa => 'Str', required => 0 );
has 'unique_id' => ( is => 'rw', isa => 'Str', required => 0 );

1;
