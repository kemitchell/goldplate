COMMONFORM=node_modules/.bin/commonform

all: goldplate.docx

$(COMMONFORM):
	npm i --save commonform-cli

%.docx: %.commonform %.json $(COMMONFORM)
	$(COMMONFORM) render \
		--blanks $*.json \
		--format docx \
		--number outline \
		< $< \
		> $@
