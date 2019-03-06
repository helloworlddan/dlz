require 'erb'
require 'lz/config'
require 'lz/interface'
require 'pathname'

# Module to render cloudformation templates
module Renderer
  def self.render_lz
    render(source: {
             path: Config.lz_template_path,
             root: Config.lz_path,
             id: :lz
           }, sink: {
             path: Config.local_lz_template_path,
             root: Config.local_path,
             id: :local
           })
  end

  def self.render_local
    render(source: {
             path: Config.local_template_path,
             root: Config.local_path,
             id: :local
           }, sink: {
             path: Config.local_template_path,
             root: Config.local_path,
             id: :local
           })
  end

  def self.render_all
    render_lz
    render_local
  end

  def self.render(source:, sink:)
    cfg = Config.load
    Dir.glob("#{source[:path]}/*.erb") do |path|
      template = IO.read(path)
      render = ERB.new(template).result(binding)
      n_path = "#{sink[:path]}/#{File.basename(path, File.extname(path))}.yaml"
      File.open(n_path, 'w') do |file|
        file.write(render)
      end
      render_result(source: source, sink: sink, path: path, n_path: n_path)
    end
  end

  def self.render_result(source:, sink:, path:, n_path:)
    from = Pathname.new(path).relative_path_from(Pathname.new(source[:root]))
    to = Pathname.new(n_path).relative_path_from(Pathname.new(sink[:root]))

    Interface.info(
      message:
        "RENDER <#{source[:id].to_sym}>/#{from} => <#{sink[:id].to_sym}>/#{to}"
    )
  end
end
