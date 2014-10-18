NAME=ruby-install
VERSION=0.5.0
AUTHOR=postmodern
URL=https://github.com/$(AUTHOR)/$(NAME)
UPDATE_URL=https://raw.githubusercontent.com/postmodern/ruby-versions/master
UPDATE_FILES={{versions,stable}.txt,checksums.{md5,sha1,sha256,sha512}}

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
	git add doc/man/ruby-install.1.md share/man/man1/ruby-install.1
	git commit

update:
	wget -nv -N -P share/ruby-install/ruby/ $(UPDATE_URL)/ruby/$(UPDATE_FILES)
	wget -nv -N -P share/ruby-install/jruby/ $(UPDATE_URL)/jruby/$(UPDATE_FILES)
	wget -nv -N -P share/ruby-install/rbx/ $(UPDATE_URL)/rubinius/$(UPDATE_FILES)
	git commit share/ruby-install/{ruby,jruby,rbx}/$(UPDATE_FILES) -m "Updated versions/checksums"

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

release: update tag download sign

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

.PHONY: build man update download sign verify clean test tag release rpm install uninstall all
