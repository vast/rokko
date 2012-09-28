Rokko -- fat-free [Rocco](http://rtomayko.github.com/rocco/)
=============================================================

Rokko is an else one Ruby port of [Docco](http://jashkenas.github.com/docco/),
the quick-and-dirty, hundred-line-long, literate-programming-style documentation generator.

Rokko reads Ruby source files and produces annotated source documentation in HTML format.
Comments are formatted with Markdown and presented alongside syntax highlighted code so as to give an annotation effect.

## Why Rokko?

* Rokko supports only Ruby source files (consider using [Rocco](http://rtomayko.github.com/rocco/)
  if you need more languages).
* Rokko uses awesome [highlight.js](http://softwaremaniacs.org/soft/highlight/en/) library for syntax highlighting.
* Rokko can generate offline-ready documentation (all assets are bundled).
* Rokko can generate an index file with links to everything (like Table of Contents).

## Installation

Install with Rubygems:

    sudo gem install rokko

or Bundler:

    gem 'rokko'

## Usage

`rokko` command can be used to generate documentation for a set of Ruby source files:

    rokko -o docs lib/*.rb

It is also possible to use Rokko as a Rake task:

    require 'rokko/task'

    Rokko::Task.new(:rokko, 'docs', # task name, output directory
                    ['lib/**/*.rb', 'README.md'],
                    {:index => true, :local => true})

And run:

    rake rokko

## Options and configuration

* `-l`, `--local` -- generate offline-ready documentation.
* `-i`, `--index` -- generate index.html with links (TOC) to all generated HTML files.
* `-i <file>`, `--index=<file>` -- use `<file>` as index.html.
* `-o`, `--output=<dir>` -- directory where generated HTML files are written.
* `-s`, `--stylesheet=<url>` -- CSS stylesheet to use instead of default one.

### Rake task

Usage:

    Rokko::Task.new(:task_name, output_dir, filelist, opts)

Available options:

* `:local` -- generate offline-ready documentation.
* `:index => true` -- generate index.html with links (TOC) to all generated HTML files.
* `:index => <file>` -- use `<file>` as index.html.
* `:stylesheet` -- CSS stylesheet to use instead of default one.

