#!/home/acme/perl-5.10.0/bin//perl
use strict;
use warnings;
use LWP::Simple;
use Perl6::Say;
use Path::Class;
use Cwd;

my $thrift_trunk_dir = dir( cwd, 'thrift-trunk' );
my $thrift_trunk_configure = file( $thrift_trunk_dir, 'configure' );
my $thrift_trunk_makefile  = file( $thrift_trunk_dir, 'Makefile' );
my $thrift_trunk_thrift
    = file( $thrift_trunk_dir, 'compiler', 'cpp', 'thrift' );
my $cassandra_trunk_dir  = dir( cwd, 'cassandra-trunk' );
my $thrift_installed_dir = dir( cwd, 'thrift' );

unless ( -d $thrift_trunk_dir ) {
    say 'Fetching Thrift';
    system
        "svn co http://svn.apache.org/repos/asf/incubator/thrift/trunk $thrift_trunk_dir";
    die 'Failed to svn co' unless -d $thrift_trunk_dir;

}

unless ( -f $thrift_trunk_configure ) {
    say 'Bootstrapping Thrift';
    chdir $thrift_trunk_dir;
    system('./bootstrap.sh');
    die 'Failed to configure' unless -f $thrift_trunk_configure;
}

unless ( -f $thrift_trunk_makefile ) {
    say 'Configuring Thrift';
    chdir $thrift_trunk_dir;
    system("./configure --prefix=$thrift_installed_dir");
    die 'Failed to configure' unless -f $thrift_trunk_makefile;
}

unless ( -f $thrift_trunk_thrift ) {
    say 'Making Thrift';
    chdir $thrift_trunk_dir;
    system('make');
    die 'Failed to make' unless -f $thrift_trunk_thrift;
}

unless ( -d $thrift_installed_dir ) {
    say 'Make installing Thrift';
    chdir $thrift_trunk_dir;
    system('make install');
    die 'Failed to make' unless -d $thrift_installed_dir;
}

