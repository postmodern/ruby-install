NAME=ruby-install
VERSION=0.4.3
AUTHOR=postmodern
URL=https://github.com/$(AUTHOR)/$(NAME)

DIRS=bin share
INSTALL_DIRS=`find $(DIRS) -type d`
INSTALL_FILES=`find $(DIRS) -type f`
DOC_FILES=*.md *.txt

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

PREFIX?=/usr/local
DOC_DIR=$(PREFIX)/share/doc/$(PKG_NAME)

pkg:
	mkdir $(PKG_DIR)

share/man/man1/ruby-install.1: doc/man/ruby-install.1.md
	kramdown-man doc/man/ruby-install.1.md > share/man/man1/ruby-install.1

man: doc/man/ruby-install.1.md share/man/man1/ruby-install.1
	git commit doc/man/ruby-install.1.md share/man/man1/ruby-install.1

download: pkg
	wget -O $(PKG) $(URL)/archive/v$(VERSION).tar.gz

build: pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

sign: $(PKG)
	gpg --sign --detach-sign --armor $(PKG)
	git add $(PKG).asc
	git commit $(PKG).asc -m "Added PGP signature for v$(VERSION)"
	git push origin master

verify: $(PKG) $(SIG)
	gpg --verify $(SIG) $(PKG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

test:
	./test/runner

tag:
	git push
	git tag -s -m "Releasing $(VERSION)" v$(VERSION)
	git push --tags

release: tag download sign

rpm:
	rpmdev-setuptree
	spectool -g -R rpm/ruby-install.spec
	rpmbuild -ba rpm/ruby-install.spec

install:
	for dir in $(INSTALL_DIRS); do mkdir -p $(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(PREFIX)/$$file; done
	mkdir -p $(DOC_DIR)
	cp -r $(DOC_FILES) $(DOC_DIR)/

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(PREFIX)/$$file; done
	rm -rf $(DOC_DIR)

.PHONY: build man download sign verify clean test tag release rpm install uninstall all
