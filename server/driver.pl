#!/usr/bin/perl
use strict;
use warnings;
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname(dirname abs_path $0) . '/server';
use 5.010;
use DataManager;

my $parser = DataManager->new;
foreach my $row ($parser->get_data('aapl')) {
    say $row;
}