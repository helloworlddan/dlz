init:
	gem install bundler
	bundle install

docs:
	rdoc
	open doc/index.html

lint:
	rubocop

clean:
	rm -rf doc dlz-*.gem

package:
	gem build dlz.gemspec

install: package
	gem install dlz-*.gem

publish: package
	gem push dlz-*.gem