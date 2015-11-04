COMMONFORM=node_modules/.bin/commonform
TARGET=goldplate.docx

all: $(TARGET)

pdf: $(TARGET:docx=pdf)

.SECONDARY: node_modules

$(COMMONFORM):
	npm i

%.docx: %.commonform %.json $(COMMONFORM)
	$(COMMONFORM) render \
		--blanks $*.json \
		--format docx \
		--number outline \
		< $< \
		> $@

%.pdf: %.docx
	doc2pdf $<

.PHONY: lint critique

lint: $(COMMONFORM)
	cat definitions.commonform $(TARGET:docx=commonform) | $(COMMONFORM) lint

critique: $(COMMONFORM)
	$(COMMONFORM) critique < $(TARGET:docx=commonform)

clean:
	rm -rf *.docx *.pdf node_modules
