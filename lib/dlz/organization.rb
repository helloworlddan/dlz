require 'awesome_print'
require 'dlz/config'
require 'dlz/interface'
require 'dlz/drivers/organizations'

# Module to create the organization and organizational units
module Organization
  include OrganizationsDriver
  def self.deploy
    return Interface.error(message: 'no credentials found.') unless Config.auth?

    # create_root unless root_available?
    # TODO: continue
  end

  def self.destroy
    return Interface.error(message: 'no credentials found.') unless Config.auth?
    return Interface.error(message: 'org unavailable.') unless root_available?

    # TODO: implement me
    Interface.error(message: 'I am not implemented yet!')
  end

  def self.query
    return Interface.error(message: 'no credentials found.') unless Config.auth?
    return Interface.error(message: 'org unavailable.') unless root_available?

    ap describe
  end

  def self.units
    return Interface.error(message: 'no credentials found.') unless Config.auth?
    return Interface.error(message: 'org unavailable.') unless root_available?

    ap tree
  end
end
