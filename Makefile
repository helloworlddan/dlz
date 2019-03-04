run:
	bin/lz

docs:
	rdoc
	open doc/index.html

lint:
	rubocop

clean:
	rm -rf doc lz-*.gem

package:
	gem build lz.gemspec

install: package
	gem install lz-*.gem