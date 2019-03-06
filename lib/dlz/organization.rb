require 'awesome_print'
require 'aws-sdk-organizations'
require 'dlz/interface'

# Module to create the organization and organizational units
module Organization
  def self.deploy(config:)
    create_root(config: config) unless root_exists?(config: config)
    # TODO: continue
  end

  def self.destroy(*)
    Interface.error(message: 'I am not implemented yet!') # TODO: implement me
  end

  def self.create_root(config:)
    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = {}
    begin
      data = client.create_organization(feature_set: 'ALL').to_h[:organization]
    rescue StandardError # Too generic
      Interface.panic(message: 'failed to create org root!')
    end
    Interface.info(message: "created org root at #{config[:root_account_id]}.")
    data[:id]
  end

  def self.root_exists?(config:)
    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = {}
    begin
      data = client.describe_organization.to_h[:organization]
    rescue Aws::Organizations::Errors::AWSOrganizationsNotInUseException
      return false
    end
    # ALSO CHECK FOR EQUALITY WITH CURRENT CALLER
    return true if data[:master_account_id] == config[:root_account_id].to_s

    # ALSO CHECK FOR EQUALITY WITH CURRENT CALLER

    if data[:master_account_id] != config[:root_account_id]
      Interface.warn(message: 'org root different from `dlz` configuration!')
    end
    false
  end

  def self.query(config:)
    unless root_exists?(config: config)
      return Interface.panic(message: 'organization unusable')
    end

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = client.describe_organization.to_h[:organization]
    ap data
  end
end
