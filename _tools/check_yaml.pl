#!/usr/bin/perl
#
#  check themes.yaml
#
use strict;
use CPAN::Meta::YAML;
use JSON;
use YAML qw/LoadFile/;

my $fn="_data/themes.yaml";

my $d=LoadFile $fn;

my %df;
my $ec=0;
foreach my $n ( @$d ) {
	if ( ! exists $n->{name} ) {
		printf "error: no name field in record\n";
		$ec=1;
	}
	#printf "%s\n",$n->{name};
	my $format="png";
	if ( exists $n->{format} ) {
		$format=$n->{format};
	}
	if ( ! -e "$n->{name}.$format" ) {
		print "error: no $n->{name}.$format\n";
		$ec=1;
	}
	if ( ! -e "thumb/t_$n->{name}.$format" ) {
		print "error: no thumb/t_$n->{name}.$format\n";
		$ec=1;
	}
	my $download="$n->{name}.theme";
	if ( exists $n->{download_format} ) {
		$download="$n->{name}.$n->{download_format}";
	}
	if ( exists $n->{download_link} ) {
		$download=$n->{download_link};
	}
	if ( ! -e "$download" ) {
		print "error: no download file $download\n";
		$ec=1;
	}
	$df{$download}=$n;
	if ( ! exists $n->{by} ) {
		print "warning: no by field for $n->{name}\n";
	}
	if ( ! exists $n->{download_format} && ! exists $n->{download_link} ) {
		foreach my $f ( ('bgColor', 'fgColor' ) ) {
			if ( ! exists $n->{$f} ) {
				print "warning: no $f field for $n->{name}\n";
			}
		}
	}
}

opendir my $di, "." ;
my @dl = readdir $di;
closedir $di;

@dl = grep { 
	m/\.theme$/ 
	|| m/\.zip$/ 
	|| m/\.tar\./ 
	|| m/\.tgz$/ 
	|| m/\.tbz2$/ 
} @dl;

foreach my $f ( @dl ) {
	if ( exists $df{$f} ) {
		delete $df{$f};
	} else {
		print "error: no record in themes.yaml for $f \n";
		$ec=1;
	}
}

exit $ec;
