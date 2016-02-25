COMMONFORM=node_modules/.bin/commonform
CFTEMPLATE=node_modules/.bin/cftemplate
SECTIONS=$(wildcard sections/*.cform)
TARGET=goldplate.docx

all: $(TARGET)

pdf: $(TARGET:docx=pdf)

.SECONDARY: node_modules

$(COMMONFORM) $(CFTEMPLATE):
	npm i

$(TARGET): goldplate.cform $(SECTIONS) goldplate.json $(COMMONFORM)
	$(COMMONFORM) render \
		--blanks goldplate.json \
		--format docx \
		--number outline \
		< $< \
		> $@

%.pdf: %.docx
	doc2pdf $<

%.cform: %.cftemplate $(CFTEMPLATE)
	$(CFTEMPLATE) $< > $@

.PHONY: lint critique clean share

lint: goldplate.cform $(COMMONFORM)
	cat definitions.cform $< | $(COMMONFORM) lint

critique: goldplate.cform $(COMMONFORM)
	$(COMMONFORM) critique < $<

clean:
	rm -rf *.docx *.pdf

share: $(COMMONFORM)
	for cform in $(SECTIONS); do \
		$(COMMONFORM) share $$cform ; \
	done
