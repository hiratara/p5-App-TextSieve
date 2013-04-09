package App::TextSieve::Tty;
use strict;
use warnings;
use base "App::TextSieve";

sub disp_status {
    my ($self, $status) = @_;
    if (my $len = $self->{_last_length}) {
        print {$self->{out}} "\r", (' ' x $len), "\r";
    }

    $self->{_last_length} = length $status;
    print {$self->{out}} $status if $status;
}

1;
