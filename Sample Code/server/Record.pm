package Record;
use strict;
use warnings;

=for new(String date, String open, String high, String low, String close, String volume)
    data structure to represent a day of stock data
    Param date: MM/DD/YYYY the date for the data
    Param open: the stock open price
    Param high: the stocks greatest value for the day
    Param low: the stocks low for the day
    Param close: the closing price for the day
    Param volume: the amount the stock is traded for the day
=cut
sub new {
    my $class = shift;

    my $object = {
        'date' => shift,
        'open' => shift,
        'high' => shift,
        'low' => shift,
        'close' => shift,
        'volume' => shift,
    };
    
    return bless $object, $class;
}

sub date {
    my $this = shift;
    return $this->{date}
}

sub open {
    my $this = shift;
    return $this->{open}
}

sub high {
    my $this = shift;
    return $this->{high}
}

sub low {
    my $this = shift;
    return $this->{low}
}

sub close {
    my $this = shift;
    return $this->{close}
}

sub volume {
    my $this = shift;
    return $this->{volume}
}

=for to_string
    returns: sprintf '%s %s %s %s %s %s', $this->date, $this->open, $this->high, $this->low, $this->close, $this->volume
=cut
sub to_string {
    my $this = shift;
    return sprintf '%s %s %s %s %s %s', $this->date, $this->open, $this->high, $this->low, $this->close, $this->volume;
}

1;
