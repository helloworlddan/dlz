require 'awesome_print'
require 'aws-sdk-core'
require 'dlz/interface'
require 'fileutils'
require 'yaml'

# Configuration singleton for `dlz`
class Config
  class << self; attr_accessor :data end
  @data = {}
  @caller = {}

  def self.init
    return Interface.panic(message: 'config seems to already exist!') if config?

    FileUtils.mkdir_p(local_dlz_template_path)
    FileUtils.cp(
      "#{dlz_init_path}/dlz.yaml",
      "#{local_path}/dlz.yaml"
    )
    Interface.info(message: 'created new default configuration.')
  end

  def self.load
    unless File.exist?("#{local_path}/dlz.yaml")
      return Interface.panic(message: 'no config file found. try `dlz init`.')
    end

    if @data.empty?
      # Load, deserialize and symbolize keys
      @data = symbolize_deep(YAML.load_file("#{local_path}/dlz.yaml"))
    end
    @data
  end

  def self.auth?
    !caller.empty?
  end

  def self.version
    Interface.info(
      message: "current version is 'dlz-#{Gem.loaded_specs['dlz'].version}'"
    )
  end

  def self.caller
    client = Aws::STS::Client.new
    if @caller.empty?
      begin
        @caller = client.get_caller_identity.to_h
      rescue Aws::Errors::MissingCredentialsError
        return Interface.panic(message: 'no active credentials found.')
      rescue Aws::STS::Errors::ExpiredToken
        return Interface.panic(message: 'credentials have expired.')
      end
    end
    @caller
  end

  def self.whoami
    ap caller
  end

  def self.query
    ap load
  end

  def self.config?
    return true if File.exist?("#{local_path}/dlz.yaml")

    false
  end

  def self.dlz_path
    File.expand_path(File.dirname(__dir__))
  end

  def self.dlz_init_path
    "#{dlz_path}/#{dlz_init_path_trailing}"
  end

  def self.dlz_init_path_trailing
    'init'
  end

  def self.dlz_template_path
    "#{dlz_path}/#{dlz_template_path_trailing}"
  end

  def self.dlz_template_path_trailing
    'templates'
  end

  def self.local_path
    Dir.pwd
  end

  def self.local_template_path
    "#{local_path}/#{local_template_path_trailing}"
  end

  def self.local_template_path_trailing
    'templates'
  end

  def self.local_dlz_template_path
    "#{local_path}/#{local_dlz_template_path_trailing}"
  end

  def self.local_dlz_template_path_trailing
    'templates/dlz'
  end

  def self.symbolize_deep(hash)
    hash.each_with_object({}) do |(k, v), h|
      h[k.to_sym] = v.is_a?(Hash) ? symbolize_deep(v) : v
    end
  end
end
