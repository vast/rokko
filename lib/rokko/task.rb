# ### Rokko Rake task
#
# Usage:
#
#     require 'rokko/task'
#
#     Rokko::Task.new(:rokko, 'docs', # task name, output dir
#                     ['lib/**/*.rb', 'README.md'],
#                     index: true, local: true)
#
# And run with:
#     rake rokko
#
# Available options:
#
# * `:local` -- generate offline-ready documentation.
# * `index: true` -- generate index.html with links (TOC) to all generated HTML files.
# * `index: <file>` -- use `<file>` as index.html.
# * `:stylesheet` -- CSS stylesheet to use instead of default one.

# `Rokko::Task.new` takes a task name, the destination directory,
# a source file pattern or file list
require 'rokko'

module Rokko
  class Task
    include Rake::DSL if defined?(Rake::DSL)

    def initialize(task_name = 'rokko', dest = 'docs/', sources = 'lib/**/*.rb', options = {})
      @name = task_name
      @dest = dest
      @sources = FileList[sources]
      @options = options
      if options[:generate_index] || options[:index].is_a?(TrueClass)
        @options[:generate_index] = true
      end

      define
    end

    # Actually setup the task
    def define
      desc "Generate rokko documentation"
      task @name do
        # Find README file for `index.html` and delete it from `sources`
        if @options[:generate_index]
          readme_source = @sources.detect { |f| File.basename(f) =~ /README(\.(md|text|markdown|mdown|mkd|mkdn)$)?/i }
          readme = readme_source ? File.read(@sources.delete(readme_source)) : ''
        end

        # Run each file through Rokko and write output
        @sources.each do |filename|
          rokko = Rokko.new(filename, @sources, @options)
          out_dest = File.join(@dest, filename.sub(Regexp.new("#{File.extname(filename)}$"), ".html"))
          puts "rokko: #{filename} -> #{out_dest}"
          FileUtils.mkdir_p File.dirname(out_dest)
          File.open(out_dest, 'wb') { |fd| fd.write(rokko.to_html) }
        end

        # Generate index.html if needed
        if @options[:generate_index]
          require 'rokko/index_layout'
          out_dest = File.join(@dest, 'index.html')
          puts "rokko: #{out_dest}"
          File.open(out_dest, 'wb') { |fd| fd.write(IndexLayout.new(@sources, readme, @options).render) }
        end

        # Run specified file through rokko and use it as index
        if @options[:index] && source_index = @sources.find{|s| s == @options[:index]}
          rokko = Rokko.new(source_index, @sources, @options.merge(preserve_urls: true))
          out_dest = File.join(@dest, 'index.html')
          puts "rokko: #{source_index} -> index.html"
          File.open(out_dest, 'wb') { |fd| fd.write(rokko.to_html) }
        end

      end
    end

  end
end
