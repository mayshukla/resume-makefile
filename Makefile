# Markdown source and html, pdf destination directories
MD_DIR = md
HTML_DIR = html
PDF_DIR = pdf

# Subdirectories for resumes and references (inside the above dirs)
RESUMES_SUBDIR = resumes
REFERENCES_SUBDIR = references

# File extension for markdown to be converted to html, then pdf
MD_EXT = md

# Pandoc templates for resumes and reference pages
RESUME_TEMPLATE = templates/resume-template.html
REFERENCES_TEMPLATE = templates/references-template.html

# Formatting for the html to pdf conversion
PAGE_SIZE = Letter
MARGIN_TOP_BOTTOM = 0.9in
MARGIN_LEFT_RIGHT = 0.9in


# Construct list of markdown sources
MD_SOURCES := $(wildcard $(MD_DIR)/*/*.$(MD_EXT))

# Construct list of html intermediates
HTML_TARGETS = $(MD_SOURCES:$(MD_DIR)/%.$(MD_EXT)=$(HTML_DIR)/%.html)

# Construct list of final pdfs
PDF_TARGETS = $(MD_SOURCES:$(MD_DIR)/%.$(MD_EXT)=$(PDF_DIR)/%.pdf)

all: $(PDF_TARGETS)

html: $(HTML_TARGETS)

# Convert html to pdf
$(PDF_DIR)/%.pdf: $(HTML_DIR)/%.html
	mkdir -p $(@D)
	wkhtmltopdf --page-size $(PAGE_SIZE) \
		--margin-top $(MARGIN_TOP_BOTTOM) --margin-bottom $(MARGIN_TOP_BOTTOM) \
		--margin-left $(MARGIN_LEFT_RIGHT) --margin-right $(MARGIN_LEFT_RIGHT) \
		$< $@

# Use pandoc to convert markdown content to html
# Use $(RESUME_TEMPLATE) as a template (see pandoc templates)
$(HTML_DIR)/$(RESUMES_SUBDIR)/%.html: $(MD_DIR)/$(RESUMES_SUBDIR)/%.$(MD_EXT)
	mkdir -p $(@D)
	pandoc --template $(RESUMES_TEMPLATE) $< --from markdown --to html -o $@

# Do the same for references
$(HTML_DIR)/$(REFERENCES_SUBDIR)/%.html: $(MD_DIR)/$(REFERENCES_SUBDIR)/%.$(MD_EXT)
	mkdir -p $(@D)
	pandoc --template $(REFERENCES_TEMPLATE) $< --from markdown --to html -o $@


.PHONY: clean
clean:
	-rm -rf $(HTML_DIR)/*
	-rm -rf $(PDF_DIR)/*
