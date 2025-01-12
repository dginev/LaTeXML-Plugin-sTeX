# -*- CPERL -*-
#**********************************************************************
# Test cases for LaTeXML-Plugin-sTeX
#**********************************************************************
use strict;
use warnings;
use XML::LibXML;

use Test::More tests => 3;

my $eval_return = eval {
  use LaTeXML;
  use LaTeXML::Common::Config;
  1;
};

ok($eval_return && !$@, 'LaTeXML modules loaded successfully.');

my $tex_input = <<'EOQ';
\documentclass{omdoc}
\begin{document}
\begin{module}[id=foo]
\importmodule{newMod}
  \symdef[name=new]{helloOp}{HELLO}
  \symvariant{helloOp}{help}{NONONONON}
   This is going to be fun $ \helloOp $
   Maybe again $ \helloOp{help} $
\end{module}

\begin{module}[id=newMod]
\importmodule{foo}
 Try something new $ \helloOp$.
\end{module}

\begin{omtext}
  \usemodule{foo}
   We $ \helloOp $ believesefasd.
\end{omtext}
\end{document}
EOQ
		  
my $config = LaTeXML::Common::Config->new(local=>1, paths=>['./lib/LaTeXML/Package','./lib/LaTeXML/resources/RelaxNG','./lib/LaTeXML/resources/Profiles','./lib/LaTeXML/resources/XSLT']);
my $converter = LaTeXML->get_converter($config);
my $response = $converter->convert("literal:$tex_input");

# Remove searchpaths tag
my $xml = XML::LibXML->new;
my $myResponse = $xml->parse_string($response->{result}) unless $xml;
$myResponse->removeChild(($myResponse->childNodes())[0]) unless $xml;

# The conversion should fail as there is a import cycle
is($response->{status_code},3,'Conversion should fail.');
is($myResponse,undef,'Content query should be empty');
