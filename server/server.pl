#!/usr/bin/perl

package SimpleServer;

use strict; 
use warnings;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/server';
use 5.010;

use QueryManager;
use LWP::Simple;
use base qw(Net::Server);


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
