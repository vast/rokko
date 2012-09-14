class RokkoParsingTest < Test::Unit::TestCase
  def test_shebang_first_line
    html = rokkoize(fixture('shebang')).to_html
    assert !html.include?('env ruby')
  end

  def test_block_comments
    sections = rokkoize(fixture('block_comments')).sections
    assert_equal "<p>ruby block comment</p>\n", sections[0][0]
  end

  def test_ruby_encoding
    html = rokkoize(fixture('encoding')).to_html
    assert !html.include?('encoding')
  end

  def test_normalizing
    r = Rokko::Rokko.new('test.rb', ['test.rb'], {}) {""}
    sections = r.parse(fixture('normalizing'))
    assert_equal "save it", sections[1][0][0]
  end
end