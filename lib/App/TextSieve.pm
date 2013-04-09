package App::TextSieve;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

sub new {
    my ($class, %params) = @_;
    my $self = bless {
        in => \*STDIN,
        out => \*STDOUT,
        patterns => [],
        %params,
    }, $class;

    {
        # Disable buffering
        my $orig_fh = select $self->{out};
        local $| = 1;
        select $orig_fh;
    }

    $self;
}

sub print_log {
    my ($self, $line, $fibre) = @_;
    my $duration = time - $fibre->{start_time};
    $line =~ s/(\r?\n)$//;
    print {$self->{out}} $line, "($fibre->{count} times par $duration sec)", $1;
}

sub run {
    my $self = shift;
    my %fibres;
    my $skipped = 0;
    my $in = $self->{in};
    LOOP: while (my $line = <$in>) {
        print "\r" if $skipped;
        for my $pat (@{$self->{patterns}}) {
            if ($line =~ $pat->{regex}) {
                my $name = $pat->{name};
                my $fibre = $fibres{$name} //= {
                    count => 0, start_time => time,
                };
                $fibre->{count}++;
                my $duration = time - $fibre->{start_time};
                if (
                    $pat->{max} && $fibre->{count} >= $pat->{max} ||
                    $pat->{duration} && $duration >= $pat->{duration}
                ) {
                    $skipped = 0;
                    $self->print_log($line, delete $fibres{$name});
                } else {
                    $skipped++;
                    print {$self->{out}} "skipped $skipped lines";
                }

                next LOOP;
            }
        }
        $skipped = 0;
        print {$self->{out}} $line;
    }
}

1;
__END__

=head1 NAME

App::TextSieve - Perl extention to do something

=head1 VERSION

This document describes App::TextSieve version 0.01.

=head1 SYNOPSIS

    use App::TextSieve;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Masahiro Honma E<lt>hiratara@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Masahiro Honma. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
