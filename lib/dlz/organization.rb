require 'awesome_print'
require 'aws-sdk-organizations'
require 'dlz/interface'

# Module to create the organization and organizational units
module Organization
  def self.deploy
    create_root unless root_exists?
    # TODO: continue
  end

  def self.destroy
    # TODO: implement me
    Interface.error(message: 'I am not implemented yet!')
  end

  def self.create_root
    config = Config.load
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

  def self.root_exists?
    config = Config.load
    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = {}
    begin
      data = client.describe_organization.to_h[:organization]
    rescue Aws::Organizations::Errors::AWSOrganizationsNotInUseException
      return false
    end
    # Check if current org root, configured org root and calling account are all
    # the same.
    if data[:master_account_id].to_i == config[:root_account_id]
      AND data[:master_account_id].to_i == environment[:account]
      return true
    else
      Interface.warn(
        message: 'org_root or account different from `dlz` configuration!'
      )
    end
    false
  end

  def self.query
    return Interface.panic(message: 'organization unusable') unless root_exists?

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = client.describe_organization.to_h[:organization]
    ap data
  end
end
