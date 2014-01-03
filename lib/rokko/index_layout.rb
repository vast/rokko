# Layout containing README file and "Table of Contents" with links
# to all generated HTML files
class Rokko::IndexLayout < Rokko::Layout
  self.template_file = File.join(File.dirname(__FILE__), 'index_layout.mustache')

  def initialize(sources, readme = '', options = {})
    @sources = sources
    @readme = readme
    @options = options
  end

  def title
    "Table of Contents"
  end

  def readme
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true).render(@readme)
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
