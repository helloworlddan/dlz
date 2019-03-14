require 'aws-sdk-organizations'
require 'dlz/config'

# Module to drive organizations API calls
module OrganizationsDriver
  def self.root_available?
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
    end

    false # Organizations in use, but misconfigured
  end

  def self.create_root
    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = {}
    begin
      data = client.create_organization(feature_set: 'ALL').to_h[:organization]
    rescue Aws::Organizations::Errors::ServiceError
      return nil
    end
    data[:id]
  end

  def self.describe
    client = Aws::Organizations::Client.new(region: 'us-east-1')
    client.describe_organization.to_h[:organization]
  end

  def self.tree
    client = Aws::Organizations::Client.new(region: 'us-east-1')
    root_id = client.list_roots.to_h[:roots].first[:id]
    tree = {}
    tree[:children] = children(parent: root_id)
    tree
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
end
