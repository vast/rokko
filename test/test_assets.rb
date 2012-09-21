class TestRokkoAssets < Test::Unit::TestCase
  ROKKO_FIXTURE = fixture('filename')

  def setup
    @html = rokkoize(ROKKO_FIXTURE).to_html
  end

  def test_default_stylesheet_links
    assert @html.include?("<link rel=\"stylesheet\" href=\"http://vast.github.com/rokko/assets/v#{::Rokko::VERSION}/docco.css\" />")
    assert @html.include?("<link rel=\"stylesheet\" href=\"http://vast.github.com/rokko/assets/v#{::Rokko::VERSION}/highlight.css\" />")
  end

  def test_highlightjs_initialization
    assert @html.include?("<script>hljs.initHighlightingOnLoad();</script>")
  end

  def test_default_scripts
    assert @html.include?("<script src=\"http://vast.github.com/rokko/assets/v#{::Rokko::VERSION}/highlight.pack.js\"></script>")
  end

  def test_assets_embedding
    contents = rokkoize(ROKKO_FIXTURE, :local => true).to_html

    assert contents.include?(asset_contents('docco.css'))
    assert contents.include?(asset_contents('highlight.css'))
    assert contents.include?(asset_contents('highlight.pack.js'))
  end

  private
  def asset_contents(filename)
    File.read(File.expand_path("../../lib/rokko/assets/#{filename}",__FILE__))
  end
end