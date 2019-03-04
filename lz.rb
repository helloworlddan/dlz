#!/usr/bin/env ruby

require 'thor'

require_relative 'lib/config'
require_relative 'lib/organization'
require_relative 'lib/accounts'

# Main Thor class for LZ
class LZ < Thor
  desc 'init', 'create new lz configuration skeleton'
  def init
    Config.new.init_skeleton
  end

  desc 'organization', 'configure organization and organizational units'
  def organization
    Organization.deploy
  end

  desc 'accounts', 'create accounts and attach to organization'
  def accounts
    Accounts.deploy
  end

  desc 'resources', 'deploy resources per account'
  def resources
    Resources.deploy
  end
end

LZ.start(ARGV)
