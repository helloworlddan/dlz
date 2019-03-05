require 'erb'
require 'lz/config'
require 'lz/interface'

# Module to render cloudformation templates
module Renderer
  def self.render_lz
    render(source: Config.lz_template_path, sink: Config.local_lz_template_path)
  end

  def self.render_local
    render(source: Config.local_template_path, sink: Config.local_template_path)
  end

  def self.render_all
    render_lz
    render_local
  end

  def self.render(source:, sink:)
    cfg = Config.load
    Dir.glob("#{source}/*.erb") do |path|
      template = IO.read(path)
      render = ERB.new(template).result(binding)
      bare_filename = File.basename(path, File.extname(path))
      new_path = "#{sink}/#{bare_filename}.yaml"
      File.open(new_path, 'w') do |file|
        file.write(render)
      end
    end
  end
end
