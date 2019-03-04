run:
	bin/lz

docs:
	rdoc

lint:
	rubocop

clean:
	rm -rf doc lz-*.gem

package:
	gem build lz.gemspec

install: package
	gem install lz-*.gem