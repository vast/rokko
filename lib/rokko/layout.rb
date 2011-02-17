require 'pathname'
module Rokko
  class Layout < Mustache
    self.template_path = File.dirname(__FILE__)
    
    def initialize(doc)
      @doc = doc
    end
    
    def title
      File.basename(@doc.file)
    end
    
    def styles
      docco = File.read(File.join(File.dirname(__FILE__), 'assets', 'docco.css'))
      highlight = File.read(File.join(File.dirname(__FILE__), 'assets', 'highlight.css'))
      
      docco + "\n" + highlight
    end
    
    def highlight_js
      js = File.read(File.join(File.dirname(__FILE__), 'assets', 'highlight.pack.js'))
      
      js + "\nhljs.initHighlightingOnLoad();\n"
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
