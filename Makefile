# Directories which contains markdown content for resumes
# and reference pages
RESUMES_MD_DIR = md/resumes
REFERENCES_MD_DIR = md/references

# File extension for markdown to be converted to html, then pdf
MD_EXT = md

# Pandoc templates for resumes and reference pages
RESUME_TEMPLATE = templates/resume-template.html
REFERENCES_TEMPLATE = templates/references-template.html

# Destination directores for generated html resumes
# and reference pages
RESUMES_HTML_DIR = html/resumes
REFERENCES_HTML_DIR = html/references
# Destination directory for generated pdf resumes
# and reference pages
RESUMES_PDF_DIR = pdf/resumes
REFERENCES_PDF_DIR = pdf/references

# Construct list of markdown sources
RESUMES_MD_SOURCES := $(wildcard $(RESUMES_MD_DIR)/*.$(MD_EXT))
REFERENCES_MD_SOURCES := $(wildcard $(REFERENCES_MD_DIR)/*.$(MD_EXT))

# Construct list of resume and reference page html intermediates
RESUMES_HTML_TARGETS = $(patsubst $(RESUMES_MD_DIR)/%, $(RESUMES_HTML_DIR)/%, $(RESUMES_MD_SOURCES:.$(MD_EXT)=.html))
REFERENCES_HTML_TARGETS = $(patsubst $(REFERENCES_MD_DIR)/%, $(REFERENCES_HTML_DIR)/%, $(REFERENCES_MD_SOURCES:.$(MD_EXT)=.html))

# Construct list of resume and reference page pdfs which should have been built
RESUMES_PDF_TARGETS = $(patsubst $(RESUMES_MD_DIR)/%, $(RESUMES_PDF_DIR)/%, $(RESUMES_MD_SOURCES:.$(MD_EXT)=.pdf))
REFERENCES_PDF_TARGETS = $(patsubst $(REFERENCES_MD_DIR)/%, $(REFERENCES_PDF_DIR)/%, $(REFERENCES_MD_SOURCES:.$(MD_EXT)=.pdf))

# Formatting for the html to pdf conversion
PAGE_SIZE = Letter
MARGIN_TOP_BOTTOM = 0.9in
MARGIN_LEFT_RIGHT = 0.9in

all: $(RESUMES_PDF_TARGETS) $(REFERENCES_PDF_TARGETS)

html: $(RESUMES_HTML_TARGETS) $(REFERENCES_HTML_TARGETS)

# Create pdf directory if it doesn't exist
# Convert html to pdf
$(RESUMES_PDF_DIR)/%.pdf: $(RESUMES_HTML_DIR)/%.html
	mkdir -p $(RESUMES_PDF_DIR)
	wkhtmltopdf --page-size $(PAGE_SIZE) --margin-top $(MARGIN_TOP_BOTTOM) --margin-bottom $(MARGIN_TOP_BOTTOM) --margin-left $(MARGIN_LEFT_RIGHT) --margin-right $(MARGIN_LEFT_RIGHT) $< $@

# Do the same for references
$(REFERENCES_PDF_DIR)/%.pdf: $(REFERENCES_HTML_DIR)/%.html
	mkdir -p $(REFERENCES_PDF_DIR)
	wkhtmltopdf --page-size $(PAGE_SIZE) --margin-top $(MARGIN_TOP_BOTTOM) --margin-bottom $(MARGIN_TOP_BOTTOM) --margin-left $(MARGIN_LEFT_RIGHT) --margin-right $(MARGIN_LEFT_RIGHT) $< $@

# Use pandoc to convert markdown content to html
# Use $(RESUME_TEMPLATE) as a template (see pandoc templates)
# Save the result as $(RESUME_HTML)
$(RESUMES_HTML_DIR)/%.html: $(RESUMES_MD_DIR)/%.$(MD_EXT)
	mkdir -p $(RESUMES_HTML_DIR)
	pandoc --template $(RESUME_TEMPLATE) $< --from markdown --to html -o $@

# Do the same for references
$(REFERENCES_HTML_DIR)/%.html: $(REFERENCES_MD_DIR)/%.$(MD_EXT)
	mkdir -p $(REFERENCES_HTML_DIR)
	pandoc --template $(REFERENCES_TEMPLATE) $< --from markdown --to html -o $@


.PHONY: clean
clean:
	-rm -r $(RESUMES_HTML_DIR)
	-rm -r $(RESUMES_PDF_DIR)
	-rm -r $(REFERENCES_HTML_DIR)
	-rm -r $(REFERENCES_PDF_DIR)
