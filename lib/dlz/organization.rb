require 'awesome_print'
require 'aws-sdk-organizations'
require 'dlz/config'
require 'dlz/interface'

# Module to create the organization and organizational units
module Organization
  def self.deploy
    return nil unless Config.auth?

    create_root unless root_available?
    # TODO: continue
  end

  def self.destroy
    return nil unless Config.auth?

    # TODO: implement me
    Interface.error(message: 'I am not implemented yet!')
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

  def self.root_available?
    return nil unless Config.auth?

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = {}
    begin
      data = client.describe_organization.to_h[:organization]
    rescue Aws::Organizations::Errors::AWSOrganizationsNotInUseException
      return false # Organizations not in use
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

  def self.query
    return nil unless Config.auth?
    return nil unless root_available?

    client = Aws::Organizations::Client.new(region: 'us-east-1')
    data = client.describe_organization.to_h[:organization]
    ap data
  end
end
