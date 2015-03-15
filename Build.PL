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
        'Mock::Quick' => '1.100',
    },
    meta_merge => {
        'meta-spec' => { version => 2 },
        dynamic_config => 0,
        resources => {
            repository => {
                url => 'https://github.com/exodist/Test-Exception-LessClever.git',
                web => 'https://github.com/exodist/Test-Exception-LessClever',
                type => 'git',
            },
            bugtracker => {
                web => 'https://github.com/exodist/Test-Exception-LessClever/issues',
            },
        },
        x_deprecated => 1,
    },
);

$build->create_build_script;
