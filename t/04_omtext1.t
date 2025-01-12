# -*- CPERL -*-
#**********************************************************************
# Test cases for LaTeXML-Plugin-sTeX
#**********************************************************************
use strict;
use warnings;
use XML::LibXML;

use Test::More tests => 20;

my $eval_return = eval {
  use LaTeXML;
  use LaTeXML::Common::Config;
  1;
};

ok($eval_return && !$@, 'LaTeXML modules loaded successfully.');

my $tex_input = <<'EOQ';
\documentclass{omdoc}
\begin{document}
\begin{omtext}[title=newTitle, type=abstract]
 Ni hao me.
\end{omtext}
\end{document}
EOQ
		  
my $config = LaTeXML::Common::Config->new(local=>1, paths=>['./lib/LaTeXML/Package','./lib/LaTeXML/resources/RelaxNG','./lib/LaTeXML/resources/Profiles','./lib/LaTeXML/resources/XSLT']);
my $converter = LaTeXML->get_converter($config);
my $response = $converter->convert("literal:$tex_input");
my $target_xml = <<'EOQ';
<?xml version="1.0" encoding="UTF-8"?>
<?latexml class="smglom"?>
<?latexml RelaxNGSchema="omdoc+ltxml"?>
<omdoc xmlns="http://omdoc.org/ns" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:stex="http://kwarc.info/ns/sTeX" about="#omdoc1" stex:srcref="anonymous_string#textrange(from=2;0,to=0;0)" xml:id="omdoc1">
  <omtext about="#omdoc1.omtext1" stex:srcref="anonymous_string#textrange(from=3;0,to=5;12)" type="abstract" xml:id="omdoc1.omtext1">
    <metadata about="#omdoc1.omtext1.metadata1" stex:srcref="anonymous_string#textrange(from=3;0,to=5;12)" xml:id="omdoc1.omtext1.metadata1">
      <dc:title about="#omdoc1.omtext1.metadata1.title1" stex:srcref="anonymous_string#textrange(from=3;0,to=5;12)" xml:id="omdoc1.omtext1.metadata1.title1">newTitle</dc:title>
    </metadata>
    <CMP about="#omdoc1.omtext1.CMP2" stex:srcref="anonymous_string#textrange(from=3;9,to=4;2)" xml:id="omdoc1.omtext1.CMP2">
      <p xmlns="http://dlmf.nist.gov/LaTeXML" about="#omdoc1.omtext1.CMP2.p1" stex:srcref="anonymous_string#textrange(from=3;9,to=4;2)" xml:id="omdoc1.omtext1.CMP2.p1">Ni hao me.</p>
    </CMP>
  </omtext>
</omdoc>
EOQ

# Remove searchpaths tag
my $xml = XML::LibXML->new;
my $myResponse = $xml->parse_string($response->{result});
$myResponse->removeChild(($myResponse->childNodes())[0]);

is($response->{status_code},0,'Conversion was problem-free.');
my @got_lines = split("\n", $myResponse->toString(1));
my @expected_lines = split("\n", $target_xml);
my $index = 0;
while (@got_lines) {
  $index++;
  my $got_line = shift @got_lines;
  my $expected_line = shift @expected_lines;
  is($got_line, $expected_line,"Compared line $index of XML output.");
}
