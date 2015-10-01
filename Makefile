COMMONFORM=node_modules/.bin/commonform
TARGETS=goldplate.docx

all: $(TARGETS)

pdf: $(TARGETS:docx=pdf)

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
