# -*- CPERL -*-
#**********************************************************************
# Test cases for LaTeXML-Plugin-sTeX
#**********************************************************************
use strict;
use warnings;
use XML::LibXML;

use Test::More tests => 103;

my $eval_return = eval {
  use LaTeXML;
  use LaTeXML::Common::Config;
  1;
};

ok($eval_return && !$@, 'LaTeXML modules loaded successfully.');

my $tex_input = <<'EOQ';
\documentclass{smglom}
\begin{document}
\begin{module}[id=mathapp]
\begin{omtext}
$$ \nappa{f}{a_1, a_2, a_3}
\nappe{f}{a_1}{a_n}
\nappli{f}a1n
\nappui{f}a1n $$
\end{omtext}
\end{module}
\end{document}
EOQ

my $config = LaTeXML::Common::Config->new(local=>1, paths=>['./lib/LaTeXML/Package','./lib/LaTeXML/resources/RelaxNG','./lib/LaTeXML/resources/Profiles','./lib/LaTeXML/resources/XSLT']);
my $converter = LaTeXML->get_converter($config);
my $response = $converter->convert("literal:$tex_input");
my $target_xml = <<'EOQ';
<?xml version="1.0" encoding="UTF-8"?>
<?latexml class="smglom"?>
<?latexml RelaxNGSchema="omdoc+ltxml"?>
<omdoc xmlns="http://omdoc.org/ns" xmlns:stex="http://kwarc.info/ns/sTeX" about="#omdoc1" stex:srcref="anonymous_string#textrange(from=2;0,to=0;0)" xml:id="omdoc1">
  <theory about="#mathapp" stex:srcref="anonymous_string#textrange(from=3;0,to=10;12)" xml:id="mathapp">
    <omtext about="#mathapp.omtext1" stex:srcref="anonymous_string#textrange(from=4;1,to=9;12)" xml:id="mathapp.omtext1">
      <CMP about="#mathapp.omtext1.CMP1" stex:srcref="anonymous_string#textrange(from=4;25,to=8;16)" xml:id="mathapp.omtext1.CMP1">
        <equation xmlns="http://dlmf.nist.gov/LaTeXML" font="italic" xml:id="S0.Ex1">
          <Math about="#S0.Ex1.m1" mode="display" stex:srcref="anonymous_string#textrange(from=4;25,to=8;16)" tex="\nappa{f}{a_{1},a_{2},a_{3}}\@napp@seq[]{f}{a_{1}}{a_{n}}\@napp@seq[]{f}{a_{1}%&#10;}{a_{n}}\@napp@seq[]{f}{a^{1}}{a^{n}}" text="f@(list@(a _ 1, a _ 2, a _ 3)) * f@(sequence@(a _ 1, sequencefromto, a _ n)) * f@(sequence@(a _ 1, sequencefromto, a _ n)) * f@(sequence@(a ^ 1, sequencefromto, a ^ n))" xml:id="S0.Ex1.m1">
            <XMath>
              <XMApp>
                <XMTok meaning="times" role="MULOP">⁢</XMTok>
                <XMApp>
                  <XMTok mode="math" role="UNKNOWN">f</XMTok>
                  <XMDual>
                    <XMApp>
                      <XMTok meaning="list"/>
                      <XMRef idref="S0.Ex1.m1.1"/>
                      <XMRef idref="S0.Ex1.m1.2"/>
                      <XMRef idref="S0.Ex1.m1.3"/>
                    </XMApp>
                    <XMWrap>
                      <XMApp xml:id="S0.Ex1.m1.1">
                        <XMTok role="SUBSCRIPTOP" scriptpos="post4"/>
                        <XMTok mode="math" role="UNKNOWN">a</XMTok>
                        <XMTok font="upright" fontsize="70%" meaning="1" mode="math" role="NUMBER" rule="Subscript">1</XMTok>
                      </XMApp>
                      <XMTok font="upright" mode="math" role="PUNCT">,</XMTok>
                      <XMApp xml:id="S0.Ex1.m1.2">
                        <XMTok role="SUBSCRIPTOP" scriptpos="post4"/>
                        <XMTok mode="math" role="UNKNOWN">a</XMTok>
                        <XMTok font="upright" fontsize="70%" meaning="2" mode="math" role="NUMBER" rule="Subscript">2</XMTok>
                      </XMApp>
                      <XMTok font="upright" mode="math" role="PUNCT">,</XMTok>
                      <XMApp xml:id="S0.Ex1.m1.3">
                        <XMTok role="SUBSCRIPTOP" scriptpos="post4"/>
                        <XMTok mode="math" role="UNKNOWN">a</XMTok>
                        <XMTok font="upright" fontsize="70%" meaning="3" mode="math" role="NUMBER" rule="Subscript">3</XMTok>
                      </XMApp>
                    </XMWrap>
                  </XMDual>
                </XMApp>
                <XMApp>
                  <XMTok mode="math" role="UNKNOWN">f</XMTok>
                  <XMApp>
                    <XMTok meaning="sequence"/>
                    <XMApp>
                      <XMTok role="SUBSCRIPTOP" scriptpos="post4"/>
                      <XMTok mode="math" role="UNKNOWN">a</XMTok>
                      <XMTok font="upright" fontsize="70%" meaning="1" mode="math" role="NUMBER" rule="Subscript">1</XMTok>
                    </XMApp>
                    <XMTok meaning="sequencefromto"/>
                    <XMApp>
                      <XMTok role="SUBSCRIPTOP" scriptpos="post4"/>
                      <XMTok mode="math" role="UNKNOWN">a</XMTok>
                      <XMTok fontsize="70%" mode="math" role="UNKNOWN" rule="Subscript">n</XMTok>
                    </XMApp>
                  </XMApp>
                </XMApp>
                <XMApp>
                  <XMTok mode="math" role="UNKNOWN">f</XMTok>
                  <XMApp>
                    <XMTok meaning="sequence"/>
                    <XMApp>
                      <XMTok role="SUBSCRIPTOP" scriptpos="post4"/>
                      <XMTok mode="math" role="UNKNOWN">a</XMTok>
                      <XMTok font="upright" fontsize="70%" meaning="1" mode="math" role="NUMBER" rule="Subscript">1</XMTok>
                    </XMApp>
                    <XMTok meaning="sequencefromto"/>
                    <XMApp>
                      <XMTok role="SUBSCRIPTOP" scriptpos="post4"/>
                      <XMTok mode="math" role="UNKNOWN">a</XMTok>
                      <XMTok fontsize="70%" mode="math" role="UNKNOWN" rule="Subscript">n</XMTok>
                    </XMApp>
                  </XMApp>
                </XMApp>
                <XMApp>
                  <XMTok mode="math" role="UNKNOWN">f</XMTok>
                  <XMApp>
                    <XMTok meaning="sequence"/>
                    <XMApp>
                      <XMTok role="SUPERSCRIPTOP" scriptpos="post4"/>
                      <XMTok mode="math" role="UNKNOWN">a</XMTok>
                      <XMTok font="upright" fontsize="70%" meaning="1" mode="math" role="NUMBER" rule="Superscript">1</XMTok>
                    </XMApp>
                    <XMTok meaning="sequencefromto"/>
                    <XMApp>
                      <XMTok role="SUPERSCRIPTOP" scriptpos="post4"/>
                      <XMTok mode="math" role="UNKNOWN">a</XMTok>
                      <XMTok fontsize="70%" mode="math" role="UNKNOWN" rule="Superscript">n</XMTok>
                    </XMApp>
                  </XMApp>
                </XMApp>
              </XMApp>
            </XMath>
          </Math>
        </equation>
      </CMP>
    </omtext>
  </theory>
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
