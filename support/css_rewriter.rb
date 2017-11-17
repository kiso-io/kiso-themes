require 'fileutils'

# Rewrite CSS files to make asset paths relative.
class CssRewriter
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def compile
    source = @source.gsub(/url\("?\/assets\/([^\)]+?)"?\)/, 'url(<%= asset_path "\1" %>)')

    # Remove the asset hash fingerprint
    source.gsub(/-([0-9a-f]{5,})/, "")
  end

  def >>(file)
    File.open(file, 'w') { |f| f << compile }
  end

  def self.read(file)
    new(File.read(file))
  end

  def self.compile(file, dir)
    FileUtils.mkdir_p(dir)
    dest = File.join(dir, File.basename(file) + ".erb")
    read(file) >> dest
  end
end

if __FILE__ == $PROGRAM_NAME
  require "test/unit"

  class CssRewriterTest < Test::Unit::TestCase
    FIXTURE_FILE = File.expand_path("../../test/fixtures/test.css", __FILE__)

    def test_compile
      assert_equal 'background: url(<%= asset_path "image.png" %>)',
                   compile('background: url(/assets/image.png)')
      assert_equal 'background: url(<%= asset_path "image.png" %>)',
                   compile('background: url("/assets/image.png")')
    end

    def test_read
      assert_not_nil CssRewriter.read(FIXTURE_FILE).source
    end

    def test_compile_to_file
      CssRewriter.new("body {}") >> "test.css.erb"
      assert File.exist?("test.css.erb")
      assert_equal compile("body {}"), File.read("test.css.erb")
    ensure
      File.delete("test.css.erb")
    end

    def test_case_name
      CssRewriter.compile(FIXTURE_FILE, ".")
      assert File.exist?("test.css.erb")
    ensure
      File.delete("test.css.erb")
    end

  private
    def compile(source)
      CssRewriter.new(source).compile
    end
  end
end
