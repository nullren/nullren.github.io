default: build

build:
	@jekyll build
	@echo built.

clean:
	@rm -rf _site
	@echo cleaned.

install: clean build
	@rsync -ra _site/ princess:/srv/http/omgren.com/www/blog/
	@echo installed html files.

NAME:=$(shell cut -d' ' -f1-6 <<< "$(title)" | tr -d '[:cntrl:][:punct:]' | tr -c '[:alnum:]' '[-*]' | tr A-Z a-z)
DATE:=$(shell date +%Y-%m-%d)
FILENAME:=_posts/$(DATE)-$(NAME).md
TEMPFILE:=$(shell mktemp)

post:
# check we were given a title
ifeq ($(title),)
	@echo no title given! && false
endif

# check for file
	@if [ -f "$(FILENAME)" ]; then echo file "$(FILENAME)" already exists! && false; fi

# load it with defaults
	@echo ---                > "$(TEMPFILE)"
	@echo title: "$(title)" >> "$(TEMPFILE)"
	@echo ---               >> "$(TEMPFILE)"

# edit it
	@vim "$(FILENAME)" "+:r $(TEMPFILE)"
