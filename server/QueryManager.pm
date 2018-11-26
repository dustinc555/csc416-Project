package QueryManager;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/server';
use 5.010;

use strict;
use warnings;

use DataManager;
use Record;

my %fieldToIndex = ('date' => 0,
                    'open' => 1,
                    'high' => 2,
                    'low' => 3,
                    'close' => 4,
                    'volume' => 5);

sub new {
	# looks funky but this is how perl does classes
	my $class = shift;
	my $self = { update => \&update,
                max => \&max,
                min => \&min,
                get => \&get};
	return bless $self, $class;
}

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

sub max {
    my $self = shift; # this is how you get all args and assign them to vars at the same time
    my @args = split ' ', shift;
    
    my $symbol = $args[0];
    my $field = $args[1];
    my $index = $fieldToIndex{$field};
    my $filename = "$symbol.txt";
    
    #print("symbol: $symbol, field: $field, index: $index");
    
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

sub min {
    my $self = shift; # this is how you get all args and assign them to vars at the same time
    my @args = split ' ', shift;
    
    my $symbol = $args[0];
    my $field = $args[1];
    my $index = $fieldToIndex{$field};
    my $filename = "$symbol.txt";
    
    #print("symbol: $symbol, field: $field, index: $index");
    
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
