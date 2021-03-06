#!perl -T

use strict;
use warnings;

use Test::More tests => 15;
use Test::Builder::Tester;

use Test::WWW::Mechanize;

my $ua_args;

sub Test::WWW::Mechanize::success { return 1; }
sub Test::WWW::Mechanize::head {
    my $self = shift;
    my $url  = shift;

    die 'Odd number of args sent in' if @_ % 2 != 0;

    $ua_args = {@_};

    return 1;
}

my $mech = Test::WWW::Mechanize->new();
isa_ok( $mech, 'Test::WWW::Mechanize' );

my $url = 'dummy://url';
$mech->head_ok( $url );
ok( eq_hash( {}, $ua_args ), 'passing URL only' );

$mech->head_ok( $url, 'Description' );
ok( eq_hash( {}, $ua_args ), 'Passing description' );

$mech->head_ok( $url, undef, 'Description' );
ok( eq_hash( {}, $ua_args ), 'Passing undef for hash' );

my $wanted = { foo=>1, bar=>2, baz=>3 };

$mech->head_ok( $url, [ %{$wanted} ] );
ok( eq_hash( $wanted, $ua_args ), 'Passing anonymous list for hash' );

$mech->head_ok( $url, [ %{$wanted} ], 'Description' );
ok( eq_hash( $wanted, $ua_args ), 'Passing anonymous list for hash' );

$mech->head_ok( $url, { %{$wanted} } );
ok( eq_hash( $wanted, $ua_args ), 'Passing anonymous array for hash' );

$mech->head_ok( $url, { %{$wanted} }, 'Description' );
ok( eq_hash( $wanted, $ua_args ), 'Passing anonymous array for hash' );

done_testing ();
