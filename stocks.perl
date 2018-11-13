#!/usr/bin/perl

use strict; use warnings;

package SimpleServer;

use LWP::Simple;
use base qw(Net::Server);

# perl v5.28.0


sub process_request
{

    while (<STDIN>) 
    {    
        s/[\r\n]+$//;   
        sleep 5; # dont get black listed
        
        my $symbol = $_; # get command

        my $url = "http://www.nasdaq.com/symbol/$symbol/historical";
        
        print "retreiving: $url...    ";
        
        my $html = get("$url"); # get data, die if failure
        die "Failed to get page!" unless defined $html;

	my $stream = HTML::TokeParser->new(\$content);
	
	while (my $token = $stream->get_token)
	{
		if ($token eq '')
	}




        # write data to file
	$symbol .= ".html"
	# fh - the file object
	# > to overwrite $symbol
	# >> to append to symbol
        open(my $fh, '>', $symbol) or die "Could not open file '$symbol' $!";
        print $fh "$p";
        close $fh;
        print "done\n";
    }
}


SimpleServer->run(port => 8080);

        

