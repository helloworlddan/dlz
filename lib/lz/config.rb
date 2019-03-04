require 'lz/interface'

# Configuration class for LZ
class Config
  class << self; attr_accessor :data end
  @data = {}

  def init
    Interface.error(message: 'config seems to already exist!') if config_exists?
  end

  def version
    Interface.info(message: "current version is lz-#{Gem.loaded_specs['lz'].version}")
  end

  def load
    puts 'load_config' # TODO: Load config into data, use metaprogramming to create interfaces?
  end

  private

  def config_exists?
    true # TODO: check presence of config
  end
end
