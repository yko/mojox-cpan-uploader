# Copyright (C) 2010, Yaroslav Korshak.
 
package MojoX::CPAN::Uploader;

use warnings;
use strict;
use Carp;
use File::Basename;

use base 'Mojo::Base';

require Mojo::Client;
require IO::Socket::SSL;

__PACKAGE__->attr(client => sub { Mojo::Client->new });
__PACKAGE__->attr([qw/user pass/]);
__PACKAGE__->attr(url => sub { Mojo::URL->new('https://pause.perl.org/pause/authenquery') });
__PACKAGE__->attr(
    defaults => sub {
        {   CAN_MULTIPART => 1,
            SUBMIT_pause99_add_uri_httpupload =>
              " Upload this file from my disk ",
            pause99_add_uri_uri => "",
        };
    }
);

our $VERSION = '0.01_3';

sub auth {
    my $self = shift;

    croak("Basic authorization user name can't contain ':'")
        if $_[0] =~ /:/;

    $self->user(shift);
    $self->pass(shift);
}

sub upload {
    my ($self, $file, $subdir) = splice @_, 0, 3;
    my $url = $self->url->clone->userinfo($self->user . ':' . $self->pass);

    croak "Auth info required!" unless $self->user;

    my $tx = $self->client->post_form(
        $url,
        {   %{$self->defaults},
            HIDDENNAME                 => $self->user,
            pause99_add_uri_upload     => basename($file),
            pause99_add_uri_httpupload => {file => $file},
            ($subdir ? (pause99_add_uri_subdirtext => $subdir) : ()),
        },
        @_
    );

    return 1 if $tx->res->code == 200;

    if ($tx->res->code == 406) {
        my $reason = $tx->res->dom->at('blockquote.actionresponse');
        my $title  = $reason->at('h3');
        $title = $title ? $title->all_text : 'unknown';
        my @p;
        my $table = 0;
        $reason->find('p')->each(
            sub {
                return $table = 1 if $_[0]->at('table');
                my $t = shift->all_text;
                $t =~ s/^\s+|\s$//g;
                $t =~ s/[\n\r]/ /g;
                $t =~ s/\s{2,}/ /g;
                push @p, $t;
            }
        );

        return Mojo::Exception->new(
            "Error '$title' " . $tx->res->code . "\n" . join("\n", @p, ''));

    }
    elsif ($tx->res->code == 401) {
        return Mojo::Exception->new(
            "Wrong login/password for Perl Author '" . $self->user . "'");
    }

    return Mojo::Exception->new("Unknown error: " . $tx->res->code);
}


1;
__END__

=head1 NAME

MojoX::CPAN::Uploader - Mojo way to upload on CPAN


=head1 VERSION

This document describes MojoX::CPAN::Uploader version 0.1_3


=head1 SYNOPSIS

    use MojoX::CPAN::Uploader;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.

=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
MojoX::CPAN::Uploader requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 AUTHOR

Yaroslav Korshak  C<< <ykorshak@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Yaroslav Korshak C<< <ykorshak@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

