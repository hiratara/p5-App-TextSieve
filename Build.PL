#!perl
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    license        => 'perl',
    dynamic_config => 0,
    # dist_abstract  => 'XXX',

    build_requires     => {
        'Test::More'     => '0.98',
        'Test::Requires' => '0.06',
    },
    configure_requires => { 'Module::Build' => '0.38' },
    requires           => {
        perl         => '5.008001',
        # 'parent'     => 0,
    },

    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'App/TextSieve',
    module_name => 'App::TextSieve',

    # script_files => [''],

    test_files           => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,

    create_readme      => 1,
);
$build->create_build_script;
