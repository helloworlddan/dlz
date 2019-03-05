require 'lz/interface'
require 'yaml'
require 'fileutils'

# Configuration class for LZ
class Config
  class << self; attr_accessor :data end
  @data = {}

  def self.init
    return Interface.error(message: 'config seems to already exist!') if config?

    FileUtils.mkdir_p("#{Dir.pwd}/config/")
    FileUtils.mkdir_p("#{Dir.pwd}/templates/")
    FileUtils.cp(
      "#{File.expand_path(File.dirname(__dir__))}/init/lz.yaml",
      "#{Dir.pwd}/config/lz.yaml"
    )
    Interface.info(message: 'created new default configuration.')
  end

  def self.version
    Interface.info(
      message: "current version is lz-#{Gem.loaded_specs['lz'].version}"
    )
  end

  def self.load
    @data = YAML.load_file("#{Dir.pwd}/config/lz.yaml") if @data.empty?
    @data
  end

  def self.config?
    return true if File.directory?("#{Dir.pwd}/config/")
    return true if File.directory?("#{Dir.pwd}/templates/")

    false
  end
end
