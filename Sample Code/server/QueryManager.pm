package QueryManager;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/server';
use 5.010;

use strict;
use warnings;
 
use DataManager;
use Record;

=for fieldToIndex
    maps an array address to a stock field
=cut
my %fieldToIndex = ('date' => 0,
                    'open' => 1,
                    'high' => 2,
                    'low' => 3,
                    'close' => 4,
                    'volume' => 5);

=for constructor
    basic constructor
    class is used as dispatch table for server
=cut
sub new {
	# looks funky but this is how perl does classes
	my $class = shift;
	my $self = { update => \&update,
                max => \&max,
                min => \&min,
                get => \&get};
	return bless $self, $class;
}

=for update(String symbol) : String
    * checks if the symbol is in our list of approved stocks
    if so uses DataManager to make a get request to site and parse information
    * Param symbol: the stock symbol to get
    * Return: a string describing if the operation was a success
=cut
sub update {
    #symbol should be the first param
    my $self = shift; # this is how you get all args and assign them to vars at the same time
    my $symbol = shift;
   
    my @stockList = ("aapl", "amzn", "msft"); 
    my %stockHash = map { $_ => 1 } @stockList;       # easiest way to find if item is in list is to convert to hash
   

    if ($symbol eq "all") {
        foreach my $s (@stockList) {
            $self->__updateStock($s);
            sleep 3;
        }
    } elsif (exists($stockHash{$symbol})) {
        $self->__updateStock($symbol);
    } else {
      # the array does not yet contain this ip address; add it
      return "Stock not in list";
    }
    
    return "Successfully Updated $symbol";
}

=for max(String symbol, String field) : String
    * returns the max field for the symbol
    * Param symbol: the stock symbol
    * Param field: the field for the stock object (open, high, low, close, volume)
    * Return: either a string representing the stock or an error message
=cut
sub max {
    my $self = shift;
    my @args = split ' ', shift;
    
    my $symbol = $args[0];
    my $field = $args[1];
    my $index = $fieldToIndex{$field};
    my $filename = "$symbol.txt";
    
    open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";
    
    my $firstLine = <$fh>;
    my @line = split ' ', $firstLine;
    my $val = $line[$index];
    my $stock = $firstLine;
    while (my $row = <$fh>) {
        my @arr = split ' ', $row;
        if ($val < $arr[$index]) {
            $val = $arr[$index];
            $stock = $row;
        }
    }
    return $stock;
}

=for min(String symbol, String field) : String
    * returns the min field for the symbol
    * Param symbol: the stock symbol
    * Param field: the field for the stock object (open, high, low, close, volume)
    * Return: either a string representing the stock or an error message
=cut
sub min {
    my $self = shift; # this is how you get all args and assign them to vars at the same time
    my @args = split ' ', shift;
    
    my $symbol = $args[0];
    my $field = $args[1];
    my $index = $fieldToIndex{$field};
    my $filename = "$symbol.txt";
    
    open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";
    
    my $firstLine = <$fh>;
    my @line = split ' ', $firstLine;
    my $val = $line[$index];
    my $stock = $firstLine;
    while (my $row = <$fh>) {
        my @arr = split ' ', $row;
        if ($val > $arr[$index]) {
            $val = $arr[$index];
            $stock = $row;
        }
    }
    return $stock;
}

=for get(String symbol, String date) : String
    * looks for stock information with corresponding date
    * Param symbol: the stock symbol
    * Param date: MM/DD/YYYY e.g. 11/28/2018
    * Return: a string representing the stock or an error message
=cut
sub get {
    my $self = shift; # this is how you get all args and assign them to vars at the same time
    my @args = split ' ', shift;
    my $symbol = $args[0];
    my $date = $args[1];
    
    my $filename = "$symbol.txt";
    my $field = $fieldToIndex{ 'date' };
    
    open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";
    
    while (my $row = <$fh>) {
        my @arr = split ' ', $row;
        # $this->date, $this->open, $this->high, $this->low, $this->close, $this->volume
        if ($arr[$field] eq $date) {
            return $row;
        }
    }
    
    return "date not found";
}


=for __updateStock(String symbol) : Void
    * private function uses DataManager to fetch and parse stock information
    if successful stores to file
    * Param symbol: the stock symbol
    * Return: nothing but can die and send up die message to be caught
=cut
sub __updateStock {
    my $self = shift;
    my $symbol = shift;
    # have DataManager handle getting and parsing the data
    my $parser = DataManager->new;
    my @records = $parser->get_data($symbol);
    open(my $fh, '>', "$symbol.txt");
    foreach my $row (@records) {
        say $fh $row->to_string;
    }
}

1;
