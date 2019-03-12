require 'awesome_print'
require 'aws-sdk-organizations'
require 'dlz/config'
require 'dlz/interface'

# Module to create the organization and organizational units
module Organization
  def self.deploy
    return Interface.warn(message: 'no credentials found.') unless Config.auth?

    create_root unless root_available?
    # TODO: continue
  end

  def self.destroy
    return Interface.warn(message: 'no credentials found.') unless Config.auth?

    # TODO: implement me
    Interface.error(message: 'I am not implemented yet!')
  end

  def self.query
    return Interface.warn(message: 'no credentials found.') unless Config.auth?
    return Interface.info(message: 'no org root found.') unless root_available?

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = client.describe_organization.to_h[:organization]
    ap data
  end

  def self.units
    return Interface.warn(message: 'no credentials found.') unless Config.auth?
    return Interface.info(message: 'no org root found.') unless root_available?

    ap tree
  end

  def self.tree
    return nil unless Config.auth?
    return nil unless root_available?

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    root_id = client.list_roots.to_h[:roots].first[:id]
    # tree = {}
    # tree[:org_tree] = children(parent: root_id)[:children]
    # tree
    children(parent: root_id)
  end

  def self.children(parent:)
    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = client.list_children(
      child_type: 'ORGANIZATIONAL_UNIT',
      parent_id: parent
    ).to_h

    data[:children].each do |child|
      meta = client.describe_organizational_unit(
        organizational_unit_id: child[:id]
      ).to_h[:organizational_unit]
      child[:name] = meta[:name]
      child[:arn] = meta[:arn]
      children = children(parent: child[:id])
      child[:children] = children unless children.empty?
    end
  end

  def self.root_available?
    return nil unless Config.auth?

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = {}
    begin
      data = client.describe_organization.to_h[:organization]
    rescue Aws::Organizations::Errors::AWSOrganizationsNotInUseException
      return false
    end
    # Check if current org root, configured org root and calling account are all
    # the same.
    if data[:master_account_id].to_i == Config.load[:root_account_id].to_i &&
       data[:master_account_id].to_i == Config.caller[:account].to_i
      return true # All conditions met!
    else
      Interface.panic(
        message: 'org_root or caller different from `dlz` configuration!'
      )
    end

    false # Organizations in use, but misconfigured
  end

  def self.create_root
    return nil unless Config.auth?

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = {}
    begin
      data = client.create_organization(feature_set: 'ALL').to_h[:organization]
    rescue Aws::Organizations::Errors::ServiceError
      Interface.panic(message: 'failed to create org root!')
    end
    Interface.info(message: "created root at #{Config.load[:root_account_id]}.")
    data[:id]
  end
end
