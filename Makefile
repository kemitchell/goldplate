COMMONFORM=node_modules/.bin/commonform
TARGET=goldplate

all: $(TARGET:=.commonform)

pdf: $(TARGET:=.pdf)

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
