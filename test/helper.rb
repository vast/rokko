def rokkoize(contents, options = {})
  options = {:filename => 'filename.rb'}.merge(options)
  Rokko::Rokko.new(options[:filename], [options[:filename]], options) do
    contents
  end
end