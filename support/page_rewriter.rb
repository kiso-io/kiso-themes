require 'fileutils'

class PageRewriter
  attr_reader :source

  def initialize(source, regexp, replacement='')
    @source = source
    @regexp = regexp
    @replacement = replacement
  end

  def compile
    @source.gsub(@regexp, @replacement)
  end

  def >> (file)
    File.open(file, 'w') { |f| f << compile }
  end

  def self.read(file, regexp, replacement)
    new(File.read(file), regexp, replacement)
  end

  def self.compile(file, regexp, replacement)
    read(file, regexp, replacement) >> file
  end
end
