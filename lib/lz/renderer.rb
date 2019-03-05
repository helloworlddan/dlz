require 'erb'
require 'lz/config'
require 'lz/interface'

# Module to render cloudformation templates
module Renderer
  def self.render_lz
    cfg = Config.load
    Dir.glob("#{Config.lz_template_path}/*.erb") do |path|
      template = IO.read(path)
      render = ERB.new(template).result(binding)
      bare_filename = File.basename(path, File.extname(path))
      new_path = "#{Config.local_lz_template_path}/#{bare_filename}.yaml"
      File.open(new_path, 'w') do |file|
        file.write(render)
      end
    end
  end

  def self.render_local
    Interface.error(message: 'I am not implemented yet!') # TODO: implement me
  end
end
