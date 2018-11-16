#!/usr/bin/perl

package SimpleServer;

use strict; 
use warnings;

use LWP::Simple;
use base qw(Net::Server);

use QueryManager; 


sub process_request
{
	my $qm = new QueryManager();

	while (<STDIN>) 
	{    
        	s/[\r\n]+$//;   
        	sleep 5; # dont get black listed

		my $command = $_; # get command
		$qm->dispatch($command);

		print "done\n";
	}
}


SimpleServer->run(port => 50000);
