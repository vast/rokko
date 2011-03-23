Rokko -- fat-free [Rocco](http://rtomayko.github.com/rocco/)
=============================================================

Rokko is an else one Ruby port of [Docco](http://jashkenas.github.com/docco/),
the quick-and-dirty, hundred-line-long, literate-programming-style documentation generator.

Rokko reads Ruby source files and produces annotated source documentation in HTML format.
Comments are formatted with Markdown and presented alongside syntax highlighted code so as to give an annotation effect.

##Why Rokko?

* Rokko supports only Ruby source files (consider using [Rocco](http://rtomayko.github.com/rocco/)
  if you need more languages).
* Rokko uses awesome [highlight.js](http://softwaremaniacs.org/soft/highlight/en/) library for syntax highlighting.
* Rokko can generate offline-ready documentation (all assets are bundled).
* Rokko can generate an index file with links to everything (like Table of Contents).

##Installation

Install with Rubygems:

    sudo gem install rokko

##Usage

`rokko` command can be used to generate documentation for a set of Ruby source files:

    rokko -o docs lib/*.rb

It is also possible to use Rokko as a Rake task:

    require 'rokko/task'

    Rokko::Task.new(:rokko, 'docs', ['lib/**/*.rb', 'README.md'], {:index => true, :local => true})

And run:

    rake rokko

##Options and configuration

* `-i`, `--index=<file>` -- generate an index with links to HTML files or use `<file>` as index.
* `-l`, `--local` -- generate offline-ready documentation.
* `-o`, `--output=<dir>` -- directory where generated HTML files are written.

###Rake task

Usage:

    Rokko::Task.new(:task_name, output_dir, filelist, opts)

Available options:

* `:local` -- generate offline-ready documentation.
* `:index` -- if value is a file name, then it will be used as an index. If value is `true` then
  an index file with table of contents will be generated.

