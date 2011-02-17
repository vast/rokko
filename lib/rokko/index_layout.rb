class Rokko::IndexLayout < Rokko::Layout
  self.template_path = File.dirname(__FILE__)

  def initialize(sources, readme = '')
    @sources = sources
    @readme = readme
  end

  def title
    "Table of Contents"
  end

  def readme
    Markdown.new(@readme, :smart).to_html
  end

  def readme?
    @readme != ""
  end

  def sources
    @sources.sort.map do |source|
      {
        :path => source,
        :basename => File.basename(source),
        :url => source.sub(Regexp.new("#{File.extname(source)}$"), ".html")
      }
    end
  end

  # Groupped sources by dirname
  def dirs
    sources.inject(Hash.new{|hsh, key| hsh[key] = []}) do |c, source|
      c[File.dirname(source[:path])].push(source)
      c
    end.sort.collect {|k, v| {:dir => k, :files => v}}
  end

end