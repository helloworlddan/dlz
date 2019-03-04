Gem::Specification.new do |s|
  s.name        = 'lz'
  s.version     = '0.0.1'
  s.date        = '2019-03-04'
  s.summary     = 'LZ is an AWS landing zone bootstrapping tool.'
  s.description = 'LZ is a highly opinonated bootstrapping framework for AWS landing zones. It focuses on 3 main areas: creating and configuring an AWS Organization, creating and attaching accounts to that organization and deploying resources into those accounts.'
  s.authors     = ['Daniel Stamer']
  s.email       = 'dan@hello-world.sh'
  s.executables << 'lz'
  s.files       = %w[lib/config.rb lib/accounts.rb lib/interface.rb lib/organization.rb lib/resources.rb]
  s.homepage    =
    'https://hello-world.sh'
  s.license     = 'MIT'
end