NAME=3tier-app
VERSION=1.0.31
REVISION=0
PREFIX=/app/threetier
TARGET_DIR=.
PACKAGE=$(NAME)_$(VERSION)-$(REVISION)_amd64.deb
POSTINSTALL=postinstall.sh
DEPENDENCIES="gcc,ruby,ruby-dev,libmysqlclient20,libmysqlclient-dev,make,mysql-client"

.PHONY: publish

build:
	@go get github.com/go-sql-driver/mysql
	@go build || true

clean:
	@rm -f $(PACKAGE) || true

test:
	@gem list rspec >/dev/null 2>&1 || gem install rspec --no-ri --no-rdoc 	
	@rspec

package: clean build
	@fpm -s dir -t deb -d $(DEPENDENCIES) -n $(NAME) -v $(VERSION) --iteration $(REVISION) --prefix $(PREFIX) -C $(TARGET_DIR) --after-install $(POSTINSTALL) . 

publish: package
	deb-s3 upload -b debs3test --s3-region=us-east-2 $(PACKAGE)
