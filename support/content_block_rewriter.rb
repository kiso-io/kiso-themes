require 'fileutils'

class ContentBlockRewriter
  attr_reader :source

  def initialize(source)
    @source = source
  end

  def compile
    @source.gsub(/preview.+\/_content_block_(.+)\/(\d+)/, 'content_blocks/\1/\2')
  end

  def >> (file)
    File.open(file, 'w') { |f| f << compile }
  end

  def self.read(file)
    new(File.read(file))
  end

  def self.compile(file)
    read(file) >> file
  end
end
