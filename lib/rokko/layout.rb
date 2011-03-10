require 'pathname'
module Rokko
  class Layout < Mustache
    self.template_path = File.dirname(__FILE__)
    
    def initialize(doc)
      @doc = doc
      @options = @doc.options
    end
    
    def title
      File.basename(@doc.file)
    end
    
    def styles
      if @options[:local]
        docco = File.read(File.join(File.dirname(__FILE__), 'assets', 'docco.css'))
        highlight = File.read(File.join(File.dirname(__FILE__), 'assets', 'highlight.css'))

        "<style type=\"text/css\" media=\"screen, projection\">#{docco}\n#{highlight}</style>"
      else
        "<link rel=\"stylesheet\" href=\"http://github.com/vast/rokko/raw/v#{::Rokko::VERSION}/lib/rokko/assets/docco.css\" />
         <link rel=\"stylesheet\" href=\"http://github.com/vast/rokko/raw/v#{::Rokko::VERSION}/lib/rokko/assets/highlight.css\" />"
      end
    end
    
    def highlight_js
      js = if @options[:local]
        "<script>#{File.read(File.join(File.dirname(__FILE__), 'assets', 'highlight.pack.js'))}</script>"
      else
        "<script src=\"http://github.com/vast/rokko/raw/v#{::Rokko::VERSION}/lib/rokko/assets/highlight.pack.js\"></script>"
      end
      
      js + "\n" + "<script>hljs.initHighlightingOnLoad();</script>\n"
    end
    
    def sections
      num = 0
      @doc.sections.map do |docs,code|
        {
          :docs => docs,
          :code => code,
          :num => (num += 1)
        }
      end
    end
    
    def sources?
      @doc.sources.length > 1
    end
    
    def sources
      @doc.sources.sort.map do |source|
        {
          :path => source,
          :basename => File.basename(source),
          :url => relative_url(source)
        }
      end
    end
    
    private
    def relative_url(source)
      if(@doc.options[:preserve_urls])
        source.sub(Regexp.new("#{File.extname(source)}$"), ".html")
      else
        relative_path = Pathname.new(File.dirname(source)).relative_path_from(Pathname(File.dirname(@doc.file))).to_s
        "#{relative_path}/#{File.basename(source).sub(Regexp.new("#{File.extname(source)}$"), ".html")}"
      end
    end

  end
end
