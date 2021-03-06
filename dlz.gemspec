Gem::Specification.new do |s|
  s.name        = 'dlz'
  s.version     = '0.0.1'
  s.date        = '2019-03-04'
  s.summary     = 'dlz is an AWS landing zone bootstrapping tool.'
  s.description = <<-DESC
  dlz is a highly-opinionated bootstrapping framework for AWS landing zones.
  It focuses on 3 main areas: creating and configuring an AWS Organization,
  creating and attaching accounts to that organization and deploying resources
  into those accounts.'
  DESC
  s.authors     = ['Daniel Stamer']
  s.email       = 'dan@hello-world.sh'
  s.executables << 'dlz'
  s.files = Dir.glob('{bin,lib}/**/*') + %w[LICENSE README.md]
  s.homepage    =
    'https://hello-world.sh'
  s.license     = 'MIT'
end
