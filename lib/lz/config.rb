require 'erb'
require 'fileutils'
require 'lz/interface'
require 'awesome_print'
require 'yaml'

# Configuration singleton for LZ
class Config
  class << self; attr_accessor :data end
  @data = {}

  def self.init
    return Interface.error(message: 'config seems to already exist!') if config?

    FileUtils.mkdir_p("#{Dir.pwd}/templates/")
    FileUtils.cp(
      "#{File.expand_path(File.dirname(__dir__))}/init/lz.yaml",
      "#{Dir.pwd}/lz.yaml"
    )
    Interface.info(message: 'created new default configuration.')
  end

  def self.version
    Interface.info(
      message: "current version is lz-#{Gem.loaded_specs['lz'].version}"
    )
  end

  def self.print
    ap load
  end

  def self.load
    if @data.empty?
      # Load, deserialize and symbolize keys
      @data = YAML.load_file(
        "#{Dir.pwd}/lz.yaml"
      ).each_with_object({}) do |(key, value), obj|
        obj[key.to_sym] = value
      end
    end
    @data
  end

  def self.config?
    return true if File.exist?("#{Dir.pwd}/lz.yaml")
    return true if File.directory?("#{Dir.pwd}/templates/")

    false
  end
end
