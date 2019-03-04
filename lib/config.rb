require_relative './interface'

# Configuration module for LZ
class Config
  attr_reader :data

  def initialize
    @data = {}
  end

  def init_skeleton
    Interface.error(message: 'config seems to already exist!') if config_exists?
  end

  def load_config
    puts 'load_config' # TODO: Load config into data, use metaprogrammiong to create interfaces?
  end

  def config_exists?
    true # TODO: check presence of config
  end
end
