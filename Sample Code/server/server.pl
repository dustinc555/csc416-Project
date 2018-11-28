#!/usr/bin/perl

package SimpleServer;

use 5.010;
use strict; 
use warnings;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/server';
use String::Util 'trim';
use Term::ANSIColor;
use IO::Socket::INET;
use QueryManager;

# auto-flush on socket
$| = 1;

my $qm = new QueryManager();
 
# creating a listening socket
my $socket = new IO::Socket::INET (
    LocalHost => '0.0.0.0',
    LocalPort => '50000',
    Proto => 'tcp',
    Listen => 5,
    Reuse => 1
);
die "cannot create socket $!\n" unless $socket;
print "server waiting for client connection on port 50000\n";

# program main loop
# accept any given request from client
while(1)
{
    # waits for client
    my $client_socket = $socket->accept();
    # get information about a nyewly connected client
    my $client_address = $client_socket->peerhost();
    my $client_port = $client_socket->peerport();
    print color('bold green');
    print "connection from $client_address:$client_port\n";
    print color('reset');

    # read up to 1024 characters from the connected client
    my $query = "";
    $client_socket->recv($query, 1024);
    print color('bold red');
    print "received query: $query\n";
    print color('reset');    

    # process the request
    my $response = "Undefined Command";
    
    $query =~ /(\w+).*/;
    my $action = $1;                  # store first word from query (the command)
    $query =~ s/^\S+\s*//;            # now remove first word from query 
    $action = trim($action);          # get rid of newlines and whitespace
    $query = trim($query);            # trim: gets rid of trailing whitespace
    chomp $query;                     # chomp: gets rid of trailing newlines
    chomp $action;
   
    # can: checks to see if a class has this subroutine 
    if ($qm->can($action)) { 
        eval {                             # if its a valid method
        $response = $qm->$action($query)   # call it 
        }; $response = $@ if $@;           # if something went wrong (die), this catches the error message
    }
 
    # write response data to the connected client
    $client_socket->send($response);
 
    # notify client that response has been sent
    shutdown($client_socket, 1);
}
 
$socket->close();
