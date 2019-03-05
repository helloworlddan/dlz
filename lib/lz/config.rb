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

    FileUtils.mkdir_p(local_lz_template_path)
    FileUtils.cp(
      "#{lz_init_path}/lz.yaml",
      "#{local_path}/lz.yaml"
    )
    render_templates
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
        "#{local_path}/lz.yaml"
      ).each_with_object({}) do |(key, value), obj|
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

  def self.render_templates
    cfg = Config.load
    Dir.glob("#{lz_template_path}/*.erb") do |path|
      template = IO.read(path)
      render = ERB.new(template).result(binding)
      bare_filename = File.basename(path, File.extname(path))
      new_path = "#{local_lz_template_path}/#{bare_filename}.yaml"
      File.open(new_path, 'w') do |file|
        file.write(render)
      end
    end
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
