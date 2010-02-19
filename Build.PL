#!/usr/bin/perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    module_name => 'Test::Exception::LessClever',
    license     => 'perl',
    dist_author => 'Chad Granum <exodist7@gmail.com>',
    create_readme => 1,
    requires => {
        Carp => 0,
        Exporter => 0,
        'Test::Builder' => 0,
    },
    build_requires => {
        'Test::Simple' => 0.88,
        'Object::Quick' => '0.012',
    },
);

$build->create_build_script;
