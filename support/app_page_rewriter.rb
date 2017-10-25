require 'fileutils'

class AppPageRewriter
  attr_reader :source

  def initialize(source, page_type)
    @source = source
    @page_type = page_type
  end

  def compile
    @source.gsub(/preview\/elements\/007_app_pages@ti-layout\/#{@page_type}\//, '')
  end

  def >> (file)
    File.open(file, 'w') { |f| f << compile }
  end

  def self.read(file, page_type)
    new(File.read(file), page_type)
  end

  def self.compile(file, page_type)
    read(file, page_type) >> file
  end
end
