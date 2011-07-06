#!/usr/bin/perl
use warnings;
use strict;
use WebService::CloudFlare::Host;
use Data::Dumper;

my $CF = WebService::CloudFlare::Host->new(
    host_key => '8afbe6dea02407989af4dd4c97bb6e25',
);

my $this = eval { $CF->call('UserCreate',
    email => 'symkat@symkat.com',
    pass  => '8tMF0YPut#sYKUrA',
    user  => 'SymKat',
) };

if ( $@ ) {
    print "Got error: \n";
    print Dumper $@;
} else {
    print "Worked!:\n";
    print Dumper $this;
}

