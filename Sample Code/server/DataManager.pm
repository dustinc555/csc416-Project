package DataManager;
use strict;
use warnings;
use 5.010;
use LWP::Simple;
use HTML::TreeBuilder;
use Record;

=for Class Constructor
    basic constructor bless is what binds the hash to the class (mem address)
=cut
sub new {
    my $class = shift;
    return bless {}, $class;
}

=for get_data(String symbol)
    * Param symbol: makes request to nasdaq for the symbol
    parses the received html into Record objects 
    * Return:  
=cut
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

    my @rows = map { $_->as_text } $tree->look_down('_tag', 'tbody')->look_down('_tag', 'tr');
    my @records = map {
        $_ =~ s/,//g;           ### Strip Commas 
        my @data = split ' ', $_;
        Record->new($data[0], $data[1], $data[2], $data[3], $data[4], $data[5])
    } @rows;

    return @records;
}


1;
