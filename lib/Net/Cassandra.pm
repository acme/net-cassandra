package Net::Cassandra;
use Moose;
use MooseX::StrictConstructor;
use Net::Cassandra::Backend::Cassandra;
use Net::Cassandra::Backend::Thrift;
use Net::Cassandra::Backend::Thrift::Socket;
use Net::Cassandra::Backend::Thrift::BufferedTransport;
use Net::Cassandra::Backend::Thrift::BinaryProtocol;

has 'hostname' => ( is => 'ro', isa => 'Str', default => 'localhost' );
has 'port'     => ( is => 'ro', isa => 'Int', default => 9160 );
has 'client'   => (
    is         => 'ro',
    isa        => 'Net::Cassandra::Backend::CassandraClient',
    lazy_build => 1
);

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