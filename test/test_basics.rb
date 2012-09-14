class RokkoBasicTests < Test::Unit::TestCase
  ROKKO_FIXTURE = File.read(File.expand_path('../fixtures/filename.rb', __FILE__))

  def test_rokko_exists_and_is_instancable
    assert_nothing_raised do
      r = rokkoize(ROKKO_FIXTURE)
    end
  end

  def test_filename
    assert_equal "filename.rb", rokkoize(ROKKO_FIXTURE).file
  end

  def test_sources
    assert_equal ["filename.rb"], rokkoize(ROKKO_FIXTURE).sources
  end

  def test_sections
    r = rokkoize(ROKKO_FIXTURE)
    assert_equal 1, r.sections.length
    assert_equal 2, r.sections[0].length # docs + code
    assert_equal "<p>filename.rb perfecto!</p>\n", r.sections[0][0] # docs
    assert_equal "\ndef perfecto\n  true\nend", r.sections[0][1] # code
  end

  def test_to_html
    r = rokkoize(ROKKO_FIXTURE)
    assert_nothing_raised do
      html = r.to_html
    end
  end

  def test_to_html_generates_proper_html
    html = rokkoize(ROKKO_FIXTURE).to_html
    assert html.include?('<h1>filename.rb</h1>')
    assert html.include?('<p>filename.rb perfecto!</p>')
    assert html.include?('def perfecto')
  end
end