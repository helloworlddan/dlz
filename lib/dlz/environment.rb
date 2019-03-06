require 'aws-sdk-sts'
require 'dlz/interface'
require 'awesome_print'

# Module to assess the current environment of `dlz`
module Environment
  def self.print
    ap load
  end

  def self.load
    client = Aws::STS::Client.new
    data = {}
    begin
      data = client.get_caller_identity()
    rescue StandardError # Too generic
      Interface.panic(message: 'could not find live credentials!')
    end
    data
  end
end
