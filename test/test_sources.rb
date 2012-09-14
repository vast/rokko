class RokkoSourcesTest < Test::Unit::TestCase
  def test_flat_source_list
    r = Rokko::Rokko.new('filename.rb', ['a.rb', 'b.rb']) do
      "# comment\n puts 'code'"
    end
    html = r.to_html

    assert html.include?('<a class="source" href="./a.html">a.rb</a>')
    assert html.include?('<a class="source" href="./b.html">b.rb</a>')
  end

  def test_heiarachical_sourcelist
    r = Rokko::Rokko.new('filename.rb', ['a/a.rb', 'c/b.rb', '../d.rb']) do
      "# comment\n puts 'code'"
    end
    html = r.to_html

    assert html.include?('<a class="source" href="a/a.html">a.rb</a>')
    assert html.include?('<a class="source" href="c/b.html">b.rb</a>')
    assert html.include?('<a class="source" href="../d.html">d.rb</a>')
  end
end