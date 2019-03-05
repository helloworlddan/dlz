init:
	gem install bundler
	bundle install

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

publish: package
	gem push lz-*.gem