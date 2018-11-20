#!/usr/bin/perl

package SimpleServer;

use strict; 
use warnings;

use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/server';
use 5.010;

use QueryManager;
use IO::Socket::INET;

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

while(1)
{
    # waiting for a new client connection
    my $client_socket = $socket->accept();
 
    # get information about a newly connected client
    my $client_address = $client_socket->peerhost();
    my $client_port = $client_socket->peerport();
    print "connection from $client_address:$client_port\n";
 
    # read up to 1024 characters from the connected client
    my $command = "";
    $client_socket->recv($command, 1024);
    print "received data: $command\n";
    
    # process the request
    $respond = $qm->dispatch($command);
 
    # write response data to the connected client
    $client_socket->send($command);
 
    # notify client that response has been sent
    shutdown($client_socket, 1);
}
 
$socket->close();


