#!/home/acme/perl-5.10.0/bin//perl
use strict;
use warnings;
use lib 'lib';
use Net::Cassandra;

my $cassandra = Net::Cassandra->new;
my $client    = $cassandra->client;

my $key_user_id = '3141';
my $timestamp   = time;
eval {
    $client->insert( 'Table1', $key_user_id, 'Standard1:name', 'Leon Brocard',
        $timestamp );
};
die $@->why if $@;
