use strict;
use warnings;
use Module::Build;
use 5.006;

my $builder = Module::Build->new(
    module_name       => 'MojoX::CPAN::Uploader',
    license           => 'perl',
    dist_author       => 'Yaroslav Korshak <ykorshak@gmail.com>',
    dist_version_from => 'lib/MojoX/CPAN/Uploader.pm',
    script_files      => ['bin/mojo-cpanup'],
    requires          => {
        'Mojolicious' => 0.999939,
        'IO::Socket::SSL' => 0,
        'Term::ReadKey' => 0,
        'Getopt::Long' => 0,
        'File::Spec' => 0,
        'IPC::Open3' => 0,
        'Test::More'  => 0,
        'version'     => 0,
    },
    add_to_cleanup => ['mojox-cpan-uploader-*'],
);

$builder->create_build_script();
