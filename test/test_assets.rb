class TestRokkoAssets < Test::Unit::TestCase
  ROKKO_FIXTURE = fixture('filename')

  def setup
    @html = rokkoize(ROKKO_FIXTURE).to_html
  end

  def test_default_stylesheet_links
    assert @html.include?(%(<link rel="stylesheet" href="http://vast.github.io/rokko/assets/v#{::Rokko::VERSION}/docco.css" />))
    assert @html.include?(%(<link rel="stylesheet" href="http://yandex.st/highlightjs/7.5/styles/github.min.css" />))
  end

  def test_highlightjs_initialization
    assert @html.include?("<script>hljs.initHighlightingOnLoad();</script>")
  end

  def test_default_scripts
    assert @html.include?(%(<script src="http://yandex.st/highlightjs/7.5/highlight.min.js"></script>))
  end

  def test_assets_embedding
    contents = rokkoize(ROKKO_FIXTURE, :local => true).to_html

    assert contents.include?(asset_contents('docco.css'))
    assert contents.include?(asset_contents('github.min.css'))
    assert contents.include?(asset_contents('highlight.min.js'))
  end

  def test_custom_stylesheet
    contents = rokkoize(ROKKO_FIXTURE, :stylesheet => 'http://ya.ru/base.css').to_html

    assert contents.include?('<link rel="stylesheet" href="http://ya.ru/base.css" />')
  end

  private
  def asset_contents(filename)
    File.read(File.expand_path("../../lib/rokko/assets/#{filename}",__FILE__))
  end
end
