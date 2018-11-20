package DataManager;
use strict;
use warnings;
use 5.010;
use LWP::Simple;
use HTML::TreeBuilder;
use Record;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub get_data {
    my $this = shift;
    my $symbol = shift;
    die "No Symbol provided" unless defined $symbol;
	
	print "$symbol \n";

    my $url = "https://www.nasdaq.com/symbol/$symbol/historical";
	print "$url \n";
    my $result = get($url);
    die "Failed to get page!" unless defined $result;

    my $tree = HTML::TreeBuilder->new();
    $tree->parse($result);
    $tree->eof;

    my @rows = map { $_->as_text } $tree->look_down('_tag', 'tbody')->look_down('_tag', 'tr');
    my @records = map {
        my @data = split ' ', $_;
        Record->new($data[0], $data[1], $data[2], $data[3], $data[4], $data[5])
    } @rows;

    return @records;
}

1;