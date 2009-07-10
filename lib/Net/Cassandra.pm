package Net::Cassandra;
use Moose;
use MooseX::StrictConstructor;
use Net::Cassandra::Backend::Cassandra;
use Net::Cassandra::Backend::Thrift;
use Net::Cassandra::Backend::Thrift::Socket;
use Net::Cassandra::Backend::Thrift::BufferedTransport;
use Net::Cassandra::Backend::Thrift::BinaryProtocol;

our $VERSION = '0.33';

has 'hostname' => ( is => 'ro', isa => 'Str', default => 'localhost' );
has 'port'     => ( is => 'ro', isa => 'Int', default => 9160 );
has 'client'   => (
    is         => 'ro',
    isa        => 'Net::Cassandra::Backend::CassandraClient',
    lazy_build => 1
);

__PACKAGE__->meta->make_immutable;

sub _build_client {
    my $self = shift;

    my $socket
        = Net::Cassandra::Backend::Thrift::Socket->new( $self->hostname,
        $self->port );
    my $transport
        = Net::Cassandra::Backend::Thrift::BufferedTransport->new($socket);
    my $protocol
        = Net::Cassandra::Backend::Thrift::BinaryProtocol->new($transport);
    my $client = Net::Cassandra::Backend::CassandraClient->new($protocol);

    eval { $transport->open };
    confess $@->{message} if $@;
    return $client;
}

1;

__END__

=head1 NAME

Net::Cassandra - Interface to Cassandra

=head1 SYNOPSIS

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

=head1 DESCRIPTION

This module provides an interface the to Cassandra distributed database.
It uses the Thrift interface. This is changing rapidly and supports the
development version of Cassandra built from Subversion trunk.

=head1 AUTHOR

Leon Brocard <acme@astray.com>.

=head1 COPYRIGHT

Copyright (C) 2009, Leon Brocard

=head1 LICENSE

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.
