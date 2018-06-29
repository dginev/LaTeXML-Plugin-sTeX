package LaTeXML::Util::STest;

use strict;
use warnings;

use XML::LibXML;
use Test::More;

use base qw(Exporter);

our @EXPORT = (qw(&stex_tests), );

# Runs LaTeXML-Plugin-STeX tests
sub stex_tests {
    my ($directory) = @_;

    # open the direcory with tests in them or fail
    my $DIR;
    if (!opendir($DIR, $directory)) {
        return do_fail($directory, "Couldn't read directory $directory:$!"); 
    }

    # Find all the .tex files inside the directory
    my @dir_contents = sort readdir($DIR);
    my $t;
    my @stex_tests   = map { (($t = $_) =~ s/\.tex$//      ? (
        ($t eq "pre" or $t eq "post") ? () : ($t)
    ) : ()); } @dir_contents;

    # Setup tests and plan them out
    stex_tests_init(scalar(@stex_tests));

    # Run all the individual tests
    foreach my $test (@stex_tests) {
        stex_test_job("$directory/$test");
    }

    # And finish
    stex_tests_finalize();
}


# Initialize STeX Test Suite
sub stex_tests_init {
    my ($filecount) = @_;

    # plan out the tests
    plan tests => (2 + 2*$filecount);

    # Load basic modules
    eval {
        use_ok("LaTeXML");
        use_ok("LaTeXML::Common::Config");
    }
}

# Finalize STeX Test Suite
sub stex_tests_finalize {
    done_testing();
}

# Test that a single input file works properly
# Does load pre-amble and post-amble (if they exist)
sub stex_test_job {
    my ($jobname) = @_;

    # We will need to parse a lot of XML
    my $xml = XML::LibXML->new;

    # Read the tex input and convert (where possible)
    my $tex = read_stex_file($jobname);
    my $response = stex_convert($tex);
    my $responseXML = $xml->parse_string($response->{result}) if $response->{result};
    my $actualResponse = stex_clean_xml($responseXML) if $response->{result};

    # Read the expected result (if it exists)
    my $shouldSuceed = (-e "$jobname.omdoc");
    my $omdoc = read_file("$jobname.omdoc") if $shouldSuceed;
    my $expected = $xml->parse_string($omdoc) if $shouldSuceed;
    my $expectedOutput = stex_clean_xml($expected) if $shouldSuceed;


    # if we have valid omdoc
    if ($shouldSuceed) {

        my $exitcode = $response->{status_code};

        TODO: {
            local $TODO = "Warnings and errors are still present due to locators";
            is($exitcode, 0, "$jobname conversion should succeed");
        }
        
        is_strings([split(/^/m, $actualResponse)], [split(/^/m, $expectedOutput)], "$jobname should generate omdoc");
    } else {
        is($response->{status_code},3,"$jobname conversion should fail");
        is($response->{result},undef,"$jobname should not generate omdoc");
    }

    
}

# Reads in a test case
sub read_stex_file {
    my ($jobname) = @_;
    my $content = "";

    # Read the preamble if it exists
    my $preamble = ($jobname =~ s/[^\/]*$/pre/r) . ".tex";
    if (-e $preamble) {
        $content .= read_file($preamble);
    }

    # Read the tex file
    my $texfile = "$jobname.tex";
    $content .= read_file($texfile);

    # Read the postamble if it exists
    my $postamble = ($jobname =~ s/[^\/]*$/post/r) . ".tex";
    if (-e $postamble) {
        $content .= read_file($postamble);
    }
        
    # Return the content
    return $content;
}

# Convert content inside a string using latexml-plugin-stex
# Converts 
sub stex_convert {
    my ($tex_input) = @_;
    my $stexstydir = $ENV{'STEXSTYDIR'} || "../sTeX/sty/etc"; # TODO: Do we really need this?
    my $config = LaTeXML::Common::Config->new(paths=>["$stexstydir"]);
    my $converter = LaTeXML->get_converter($config);
    return $converter->convert("literal:$tex_input");
}

# Cleans up an XML::LibXML::Document instance
# and removes all non-tested STeX attributes
# returns a string that can be compared
sub stex_clean_xml {
    my ($xml) = @_;

    # processing-instruction("latexml")[starts-with(., "searchpaths=")]
    my @searchpaths = $xml->findnodes('processing-instruction("latexml")[starts-with(., "searchpaths=")]');
    foreach my $node (@searchpaths) {
        $node->parentNode->removeChild($node);
    }

    # HACK: While locators are broken, we want to remove stex:srcref
    my @nodes = $xml->findnodes('descendant-or-self::*');
    foreach my $node (@nodes) {
        $node->removeAttributeNS("http://kwarc.info/ns/sTeX", "srcref");
    }
    
    return $xml->toString(1);
}

#
# Test Utilities
#

# $strings1 is the currently generated material
# $strings2 is the stored expected result.
sub is_strings {
  my ($strings1, $strings2, $name) = @_;
  my $max = $#$strings1 > $#$strings2 ? $#$strings1 : $#$strings2;
  my $ok = 1;
  for (my $i = 0 ; $i <= $max ; $i++) {
    my $string1 = $$strings1[$i];
    my $string2 = $$strings2[$i];
    if (defined $string1) {
      chomp($string1); }
    else {
      $ok = 0; $string1 = ""; }
    if (defined $string2) {
      chomp($string2); }
    else {
      $ok = 0; $string2 = ""; }
    if (!$ok || ($string1 ne $string2)) {
      return do_fail($name,
        "Difference at line " . ($i + 1) . " for $name\n"
          . "      got : '$string1'\n"
          . " expected : '$string2'\n"); } }
  return ok(1, $name); }

sub do_fail {
  my ($name, $diag) = @_;
  my $ok = ok(0, $name);
  diag($diag);
  return $ok; }

#
# General Utility functions 
#

# Check if $haystack begins with $needle
sub begins_with {
    return substr($_[0], 0, length($_[1])) eq $_[1];
}

# Reads a file and returns a string of the content
sub read_file {
    my ($filename) = @_;
    my $fh;

    open($fh, "<", $filename) or die "Can't open file $filename: $!";
    return do { local $/; <$fh> };
}

1;