#!/usr/bin/env perl

use 5.010001;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'MojoX::CPAN::Uploader',
  VERSION_FROM => 'lib/MojoX/CPAN/Uploader.pm',
  ABSTRACT     => 'Mojo way to upload files to CPAN',
  AUTHOR       => 'Yaroslav Korshak <yko@cpan.org>',
  LICENSE      => 'perl',
  META_MERGE   => {
    dynamic_config => 0,
    'meta-spec'    => {version => 2},
    no_index       => {directory => ['t']},
    prereqs        => {runtime => {requires => {perl => '5.010001'}}},
    resources      => {
      license    => ['http://dev.perl.org/licenses/'],
      repository => {
        type => 'git',
        web => 'http://github.com/yko/mojox-cpan-uploader',
        url => 'http://github.com/yko/mojox-cpan-uploader.git',
      },
      bugtracker => {web => 'http://github.com/yko/mojox-cpan-uploader/issues' },
    },
    x_deprecated => 1,
  },
  PREREQ_PM => {
    'Mojolicious' => '1.51',
    'IO::Socket::SSL' => 1.43,
    'Term::ReadKey' => 0,
    'Getopt::Long' => 0,
    'File::Spec' => 0,
    'IPC::Open3' => 0,
  },
  EXE_FILES => ['bin/mojo-cpanup'],
  test => {TESTS => 't/*.t t/*/*.t'}
);

