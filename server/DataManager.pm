package DataManager;
use strict;
use warnings;
use LWP::Simple;
use HTML::TreeBuilder;
use 5.010;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub get_data {
    my $this = shift;
    my $symbol = shift;
    die "No Symbol provided" unless defined $symbol;

    my $url = 'https://www.nasdaq.com/symbol/' . $symbol . '/historical';
    my $result = get($url);
    die "Failed to get page!" unless defined $result;

    my $tree = HTML::TreeBuilder->new();
    $tree->parse($result);
    $tree->eof;

    return map { $_->as_text } $tree->look_down('_tag', 'tbody')->look_down('_tag', 'tr');
}

1;