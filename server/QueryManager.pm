package QueryManager;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/server';
use 5.010;

use strict;
use warnings;

use DataManager;

sub update {
        #symbol should be the first param
        my $self = shift; # this is how you get all args and assign them to vars at the same time
        my $symbol = shift;

        # have DataManager handle getting and parsing the data
        my $parser = DataManager->new;
        foreach my $row ($parser->get_data($symbol)) {
                say $row; # do stuff with row of stock data
        }
}

sub new {
	# looks funky but this is how perl does classes
	my $class = shift;
	my $self = ( update => \&update );
	return bless $self, $class;
}

sub dispatch {
	my $self = shift;
	my $query = shift;
	my @args = split ' ', $query;
	my $routine = $args[0];
	my $symbol = $args[1];
	$self->$routine($symbol); # look for it in our list of actions
}

1;
