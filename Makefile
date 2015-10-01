COMMONFORM=node_modules/.bin/commonform
TARGET=goldplate.docx

all: $(TARGET)

pdf: $(TARGET:docx=pdf)

$(COMMONFORM):
	npm i --save commonform-cli

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
	$(COMMONFORM) lint < $(TARGET:docx=commonform)

critique: $(COMMONFORM)
	$(COMMONFORM) critique < $(TARGET:docx=commonform)

clean:
	rm -rf *.docx *.pdf node_modules
