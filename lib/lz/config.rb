require 'fileutils'
require 'lz/interface'
require 'awesome_print'
require 'yaml'

# Configuration singleton for LZ
class Config
  class << self; attr_accessor :data end
  @data = {}

  def self.init
    return Interface.panic(message: 'config seems to already exist!') if config?

    FileUtils.mkdir_p(local_lz_template_path)
    FileUtils.cp(
      "#{lz_init_path}/lz.yaml",
      "#{local_path}/lz.yaml"
    )
    Interface.info(message: 'created new default configuration.')
  end

  def self.version
    Interface.info(
      message: "current version is 'lz-#{Gem.loaded_specs['lz'].version}'"
    )
  end

  def self.print
    ap load
  end

  def self.load
    unless File.exist?("#{local_path}/lz.yaml")
      return Interface.panic(message: 'no config file found. try `lz init`.')
    end

    if @data.empty?
      # Load, deserialize and symbolize keys
      @data = YAML.load_file("#{local_path}/lz.yaml")
                  .each_with_object({}) do |(key, value), obj|
        obj[key.to_sym] = value
      end
    end
    @data
  end

  def self.config?
    return true if File.exist?("#{local_path}/lz.yaml")
    return true if File.directory?(local_template_path)

    false
  end

  def self.lz_init_path
    "#{File.expand_path(File.dirname(__dir__))}/init"
  end

  def self.lz_template_path
    "#{File.expand_path(File.dirname(__dir__))}/templates"
  end

  def self.local_path
    Dir.pwd
  end

  def self.local_template_path
    "#{local_path}/templates"
  end

  def self.local_lz_template_path
    "#{local_path}/templates/lz"
  end
end
