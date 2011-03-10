# ##Rokko -- fat-free [Rocco](http://rtomayko.github.com/rocco/)
require 'rdiscount'
require 'rokko/version'

module Rokko
  class Rokko
    attr_reader :file
    attr_reader :sections
    attr_reader :sources
    attr_reader :options
    
    @@comment_pattern = /^\s*#(?!\{)\s?/
    @@block_comment_start = /^\s*=begin\s*$/
    @@block_comment_end = /^\s*=end\s*$/
    
    def initialize(filename, sources = [], options = {}, &block)
      @file = filename
      @sources = sources
      @options = options
      
      @data = if block_given?
        yield
      else
        File.read(filename)
      end
      
      @sections = prettify(split(parse(@data)))
    end
    
    def parse(data)
      sections = []
      docs, code = [], []
      lines = data.split("\n")
      
      # Skip shebang and encoding information
      lines.shift if lines[0] =~ /^\#\!/
      lines.shift if lines[0] =~ /coding[:=]\s*[-\w.]+/
      
      in_comment_block = false
      lines.each do |line|
        # If we're currently in a comment block, check whether the line matches
        # the _end_ of a comment block
        if in_comment_block
          if line.match(@@block_comment_end)
            in_comment_block = false
          else
            docs << line
          end
        # Otherwise, check whether the line matches the beginning of a block, or
        # a single-line comment all on it's lonesome. In either case, if there's
        # code, start a new section  
        else
          if line.match(@@block_comment_start)
            in_comment_block = true
            if code.any?
              sections << [docs, code]
              docs, code = [], []
            end
          elsif line.match(@@comment_pattern)
            if code.any?
              sections << [docs, code]
              docs, code = [], []
            end
            docs << line.sub(@@comment_pattern, '')
          else
            code << line
          end
        end
      end
      
      sections << [docs, code] if docs.any? || code.any?
      normalize_leading_spaces(sections)
    end
    
    # Normalizes documentation whitespace by checking for leading whitespace,
    # removing it, and then removing the same amount of whitespace from each
    # succeeding line
    def normalize_leading_spaces(sections)
      sections.map do |section|
        if section.any? && section[0].any?
          leading_space = section[0][0].match("^\s+")
          if leading_space
            section[0] = section[0].map{|line| line.sub(/^#{leading_space.to_s}/, '')}
          end
        end
        section
      end
    end
    
    # Take the list of paired *sections* two-tuples and split into two
    # separate lists: one holding the comments with leaders removed and
    # one with the code blocks
    def split(sections)
      docs_blocks, code_blocks = [], []
      sections.each do |docs,code|
        docs_blocks << docs.join("\n")
        code_blocks << code.map do |line|
          tabs = line.match(/^(\t+)/)
          tabs ? line.sub(/^\t+/, '  ' * tabs.captures[0].length) : line
        end.join("\n")
      end
      [docs_blocks, code_blocks]
    end
    
    # Take the result of `split` and apply Markdown formatting to comments
    def prettify(blocks)
      docs_blocks, code_blocks = blocks
      
      # Combine all docs blocks into a single big markdown document with section
      # dividers and run through the Markdown processor. Then split it back out
      # into separate sections
      markdown = docs_blocks.join("\n\n##### DIVIDER\n\n")
      docs_html = Markdown.new(markdown, :smart).to_html.split(/\n*<h5>DIVIDER<\/h5>\n*/m)
      
      docs_html.zip(code_blocks)
    end
    
    
    def to_html
      require 'mustache'
      $:.unshift(File.dirname(__FILE__))
      require 'rokko/layout'
      
      ::Rokko::Layout.new(self).render
    end

  end
end
