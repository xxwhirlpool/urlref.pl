#!/usr/bin/env perl

use 5.38.2;
use strict;
use warnings;

use Getopt::Long qw(GetOptions);

sub usage {
	print("Usage: urlref.pl [--get-code|--help]\n
	run without args to add URL\n");
	exit 0;
}

my $getcode;

my $filename = "links.txt";
my $dir = $ENV{"HOME"} . "/.local/share/urlref/";
my $fndir = $dir . $filename;

GetOptions(
	"get-code=s" => \$getcode,
	"help" => \&usage,
) or die("\nif you want to get a URL, supply a code: --get-code [CODE]\n");

mkdir $dir unless -d $dir;

sub encode {
	my @chars = ("A".."Z","0".."9");

	my $string;
	$string .= $chars[int(rand(@chars))] for 1..5;

	return $string;
}

sub addurl {
	print("enter URL: ");
	my $url = <STDIN>;
	chomp $url;
	my $code = encode($url);

	if (!length $url == 0) {
		print("code is: $code\n");

		open(my $fh, ">>", "$fndir") or die("could not open $fndir: $!");
		print $fh "$code $url\n";
		close $fh;

		print("saved URL to file: $fndir\n");
	} else {
		die("no URL given");
	}
}

if ($getcode) {
	open(my $fh, "<", "$fndir") or die("could not open $fndir: $!");
	while(my $line = <$fh>) {
		if($line =~ /^$getcode\s/) {
			print("found: $line");
		}
	}
	close $fh;
} else {
	addurl
}
