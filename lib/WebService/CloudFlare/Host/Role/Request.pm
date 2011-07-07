package WebService::CloudFlare::Host::Role::Request;
use Moose::Role;

sub as_post_params {
    my ( $self ) = @_;
    my %arguments = map { my $v = $self->{$self->req_map->{$_}}; 
        defined($v) ? ($_ => $v) : ()
    } keys %{$self->req_map};
    return %arguments;
    $arguments{host_key} = $self->host_key;
}
1;
