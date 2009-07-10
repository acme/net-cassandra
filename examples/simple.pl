#!/home/acme/perl-5.10.0/bin//perl
use strict;
use warnings;
use lib 'lib';
use Net::Cassandra;
use Perl6::Say;

my $cassandra = Net::Cassandra->new;
my $client    = $cassandra->client;

my $key       = '123';
my $timestamp = time;

eval {
    $client->insert( 'Table1', $key, 'Standard1:name', 'Leon Brocard',
        $timestamp, 0 );
};
die $@->why if $@;

eval {

    $client->remove( 'Table1', $key, 'Standard1:age', $timestamp );
};
die $@->why if $@;

my $column;
eval { $column = $client->get_column( 'Table1', $key, 'Standard1:name' ); };
die $@->why if $@;
say $column->{columnName}, ', ', $column->{value}, ', ', $column->{timestamp};

my $slice;
eval { $slice = $client->get_slice( 'Table1', $key, 'Standard1', -1, -1 ); };
die $@->why if $@;

foreach my $row (@$slice) {
    say $row->{columnName}, ', ', $row->{timestamp}, ', ', $row->{value};
}
