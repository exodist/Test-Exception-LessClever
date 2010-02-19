#!/usr/bin/perl
use strict;
use warnings;

use Test::Builder::Tester;
use Test::More;
use Object::Quick qw/obj method/;

our $CLASS;


BEGIN {
    test_out( 'ok 1 - use Test::Exception::LessClever;' );
    $CLASS = 'Test::Exception::LessClever';
    use_ok( $CLASS, qw/lives_ok dies_ok throws_ok lives_and live_or_die/ );
}

test_out( "not ok 2 - dies_ok fail" );
test_fail(+1);
dies_ok { 1 } "dies_ok fail";

test_out( "not ok 3 - lives_ok fail" );
test_fail(+1);
lives_ok { die( 'xxx' )} 'lives_ok fail';

test_err( "# Test did not die as expected at $0 line 29." );
test_out( "not ok 4 - throws_ok doesn't die" );
test_fail(+1);
throws_ok { 1 } qr/xxx/, "throws_ok doesn't die";

test_out( "not ok 5 - throws_ok error doesn't match" );
test_fail(+2);
test_err( "# t/tests.t line 34:\n#   Wanted: (?-xism:YYY)\n#   Got: XXX at t/tests.t line 34." );
throws_ok { die "XXX" } qr/YYY/, "throws_ok error doesn't match";

test_err( "# Test unexpectedly died: 'xxx at t/tests.t line 39.' at t/tests.t line 39." );
test_out( "not ok 6 - did not live to test" );
test_fail(+1);
lives_and { die 'xxx' } "did not live to test";

test_test "Test output was as desired";

######
#
# End of failure tests
#
######

my $ret = live_or_die( sub { die( 'apple' ) });
ok( !$ret, "Registered a die" );

($ret, my $error) = live_or_die( sub { die( 'apple' ) });
ok( !$ret, "Registered a die" );
like( $error, qr/apple/, "Got error" );

$ret = live_or_die( sub { 1 });
ok( $ret, "Registered a live" );

($ret, my $msg) = live_or_die( sub { 1; });
ok( $ret, "Registered a live" );
like( $msg, qr/did not die/, "Got msg" );

{
    my @warn;
    local $SIG{ __WARN__ } = sub { push @warn => @_ };

    ($ret, $error) = live_or_die( sub {
        my $obj = obj( DESTROY => method { eval { 1 }} );
        die( 'apple' );
        $obj->x;
    });
    ok( !$ret, "Registered a die despite eval in DESTROY" );
    ok( !$error, "Error was masked by eval in DESTROY" );
    like(
        $warn[0],
        qr/
            code \s died \s as \s expected, \s however \s the \s error \s is \s
            masked\. \s This \s can \s occur \s when \s an \s object's \s
            DESTROY\(\) \s method \s calls \s eval \s at \s $0
        /x,
        "Warn of edge case"
    );

    @warn = ();
    $ret = live_or_die( sub {
        my $obj = obj( DESTROY => method { eval { 1 }} );
        die( 'apple' );
        $obj->x;
    });
    ok( !$ret, "Registered a die despite eval in DESTROY" );
    ok( !@warn, "No warning when error is not requested" );

    @warn = ();
    throws_ok {
        my $obj = obj( DESTROY => method { eval { 1 }} );
        die( 'xxx' );
        $obj->x;
    } qr/^$/, "Throw edge case";

    like(
        $warn[0],
        qr/
            code \s died \s as \s expected, \s however \s the \s error \s is \s
            masked\. \s This \s can \s occur \s when \s an \s object's \s
            DESTROY\(\) \s method \s calls \s eval \s at \s $0
        /x,
        "Warn of edge case"
    );
}

lives_ok { 1 } "Simple living sub";
dies_ok { die( 'xxx' )} "Simple dying sub";
throws_ok { die( 'xxx' )} qr/xxx/, "Simple throw";
lives_and { ok( 1, "Blah" )} "Test did not die";

done_testing;
