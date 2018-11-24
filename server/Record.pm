package Record;
use strict;
use warnings;


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

sub to_string {
    my $this = shift;
    return sprintf '%s %s %s %s %s %s', $this->date, $this->open, $this->high, $this->low, $this->close, $this->volume;
}

1;
