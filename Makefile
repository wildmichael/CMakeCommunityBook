
# CONFIGURATION
A2X ?= a2x
PDF_BACKEND ?= fop
OUTDIR ?= output
RM := rm -rf
MKDIR := mkdir -p

# DO NOT EDIT BELOW THIS LINE!

# useful variables
A2X_FLAGS := --doctype=book --destination=$(OUTDIR) --icons \
             --icons-dir=./images --resource-dir=./images --resource-dir=./css
targets := chunked docbook dvi epub htmlhelp pdf ps tex text xhtml
clean_targets := $(addprefix clean-, $(targets))
main_file := text/CMakeCommunityBook.txt
main_base := $(notdir $(basename $(main_file)))
sources := $(main_file) $(wildcard text/[0-9]*.txt) $(lastword $(MAKEFILE_LIST))
define do_a2x
test -d $(OUTDIR) || $(MKDIR) $(OUTDIR)
$(A2X) $(A2X_FLAGS) -f $(format) $(main_file)
endef

# output files
output_chunked  := $(OUTDIR)/$(main_base).chunked/index.html \
                   $(OUTDIR)/$(main_base).chunked
output_docbook  := $(OUTDIR)/$(main_base).xml
output_dvi      := $(OUTDIR)/$(main_base).dvi
output_epub     := $(OUTDIR)/$(main_base).epub
output_htmlhelp := $(OUTDIR)/$(main_base).hhc                \
                   $(OUTDIR)/$(main_base).hhp                \
                   $(OUTDIR)/$(main_base).htmlhelp
output_pdf      := $(OUTDIR)/$(main_base).pdf
output_ps       := $(OUTDIR)/$(main_base).ps
output_tex      := $(OUTDIR)/$(main_base).tex
output_text     := $(OUTDIR)/$(main_base).text
output_xhtml    := $(OUTDIR)/$(main_base).html

# output specific variables
$(output_chunked):  format := chunked
$(output_docbook):  format := docbook
$(output_dvi):      format := dvi
$(output_epub):     format := epub
$(output_htmlhelp): format := htmlhelp
$(output_pdf):      format := pdf
$(output_pdf):      A2X_FLAGS += --$(PDF_BACKEND)
$(output_ps):       format := ps
$(output_tex):      format := tex
$(output_text):     format := text
$(output_xhmtl):    format := xhmtl

# default and phony targets definitions
.DEFAULT: all
.PHONY: $(targets) clean $(clean_targets) $(create_targets)

# GNU Make configuration
.SUFFIXES:
SUFFIXES=

# dependencies
all: chunked pdf
$(main_file): $(subst $(main_file),,$(sources))
clean: $(clean_targets)

chunked:   $(output_chunked)
docbook:   $(output_docbook)
dvi:       $(output_dvi)
epub:      $(output_epub)
htmlhelp:  $(output_htmlhelp)
pdf:       $(output_pdf)
ps:        $(output_ps)
tex:       $(output_tex)
text:      $(output_text)
xhtml:     $(output_xhtml)

# rules
$(output_chunked) $(output_docbook) $(output_dvi) $(output_epub) \
$(output_htmlhelp) $(output_pdf) $(output_ps) $(output_tex)      \
$(output_text) $(output_xhtml): $(sources)
	$(do_a2x)

$(clean_targets):
	$(RM) $(output_$(subst clean-,,$@))
