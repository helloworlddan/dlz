require 'awesome_print'
require 'dlz/config'
require 'dlz/interface'
require 'dlz/drivers/organizations'

# Module to create the organization and organizational units
module Organization
  def self.deploy
    return Interface.error(message: 'no credentials found.') unless Config.auth?

    # OrganizationsDriver.create_root unless OrganizationsDriver.root_available?
    # TODO: continue
    Interface.error(message: 'I am not implemented yet!')
  end

  def self.destroy
    return Interface.error(message: 'no credentials found.') unless Config.auth?
    unless OrganizationsDriver.root_available?
      return Interface.error(message: 'org unavailable.')
    end

    # TODO: implement me
    Interface.error(message: 'I am not implemented yet!')
  end

  def self.query
    return Interface.error(message: 'no credentials found.') unless Config.auth?
    unless OrganizationsDriver.root_available?
      return Interface.error(message: 'org unavailable.')
    end

    ap OrganizationsDriver.describe
  end

  def self.units
    return Interface.error(message: 'no credentials found.') unless Config.auth?
    unless OrganizationsDriver.root_available?
      return Interface.error(message: 'org unavailable.')
    end

    ap OrganizationsDriver.tree
  end
end
