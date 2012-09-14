def rokkoize(contents, options = {})
  options = {:filename => 'filename.rb'}.merge(options)
  Rokko::Rokko.new(options[:filename], [options[:filename]], options) do
    contents
  end
end

def fixture(filename)
  File.read(File.expand_path("../fixtures/#{filename}.rb", __FILE__))
end