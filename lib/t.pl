#!/usr/bin/perl
use warnings;
use strict;
use WebService::CloudFlare::Host;
use Data::Dumper;

my $CF = WebService::CloudFlare::Host->new(
    host_key => '53796d4b617420205761732020486572652e2e2e',
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

