require 'erb'
require 'dlz/config'
require 'dlz/interface'
require 'pathname'

# Module to render cloudformation templates
module Renderer
  def self.render_dlz
    render(source: {
             path: Config.dlz_template_path,
             root: Config.dlz_path,
             id: :dlz
           }, sink: {
             path: Config.local_dlz_template_path,
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
    FileUtils.mkdir_p(Config.local_dlz_template_path)
    render_dlz
    render_local
  end

  def self.render(source:, sink:)
    cfg = Config.load
    Dir.glob("#{source[:path]}/*.erb") do |path|
      template = IO.read(path)
      render = ERB.new(template, nil, '-').result(binding)
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
