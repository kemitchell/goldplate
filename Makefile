COMMONFORM=node_modules/.bin/commonform
SECTIONS=$(wildcard sections/*.commonform)
TARGET=goldplate.docx

all: $(TARGET)

pdf: $(TARGET:docx=pdf)

.SECONDARY: node_modules

$(COMMONFORM):
	npm i

$(TARGET): goldplate.commonform $(SECTIONS) goldplate.json $(COMMONFORM)
	$(COMMONFORM) render \
		--blanks goldplatejson \
		--format docx \
		--number outline \
		< $< \
		> $@

%.pdf: %.docx
	doc2pdf $<

%.commonform: %.commonform.m4
	m4 < $< > $@

.PHONY: lint critique clean

lint: goldplate.commonform $(COMMONFORM)
	cat definitions.commonform $< | $(COMMONFORM) lint

critique: goldplate.commonform $(COMMONFORM)
	$(COMMONFORM) critique < $<

clean:
	rm -rf *.docx *.pdf node_modules
