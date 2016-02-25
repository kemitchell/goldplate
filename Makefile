COMMONFORM=node_modules/.bin/commonform
SECTIONS=$(wildcard sections/*.cform)
TARGET=goldplate.docx

all: $(TARGET)

pdf: $(TARGET:docx=pdf)

.SECONDARY: node_modules

$(COMMONFORM):
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

%.cform: %.cform.m4
	m4 < $< > $@

.PHONY: lint critique clean

lint: goldplate.cform $(COMMONFORM)
	cat definitions.cform $< | $(COMMONFORM) lint

critique: goldplate.cform $(COMMONFORM)
	$(COMMONFORM) critique < $<

clean:
	rm -rf *.docx *.pdf node_modules
