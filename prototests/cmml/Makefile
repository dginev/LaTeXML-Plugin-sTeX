#################### directory ###########################
ETCDIR = ../../../sTeX/sty/etc
XSLDIR = ../../lib/LaTeXML/resources/XSLT/omdocpost.xsl
MATHFORMAT = -cmml -pmml
##########################################################

BASE = test

all: $(BASE).xml $(BASE).tomodc

$(BASE).xml: $(BASE).tex
	export STEXSTYDIR=../sty; latexmlc --expire=120 --profile=stexml \
	--preamble=pre.tex --postamble=post.tex $(MATHFORMAT)  $<  \
	--destination=$@ --log=$(BASE).ltxlog

$(BASE).tomodc: $(BASE).xml $(BASE).tex
	xsltproc --stringparam math-format cmml $(XSLDIR) $< > $@
