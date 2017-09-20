class PreviewController < ApplicationController

  layout :resolve_layout

  def index
    @body_class = 'theme-container'

    @themes = Dresssed::THEMES.map do |theme|
      {theme: theme.titlecase, colors: Kernel.const_get("Dresssed::#{theme.titlecase}::COLORS")}
    end
  end

  def main
    @body_class = 'main'

    if params[:style]
      cookies[:style] = {
        value: params[:style],
        path: 'preview/main'
      }
    end

    if params[:theme]
      cookies[:theme] = {
        value: params[:theme],
        path: 'preview/main'
      }
    end

    redirect_to element_path('001_dashboard@ti-dashboard') and return if params[:section].nil?

    @section = params[:section]
    index = @section.index('/') || 0
    index = index + 1 if index > 0
    @title = @section[index..@section.length].gsub('_', ' ').gsub(/\d{3} /, '').gsub(/@([\w+-]*)$/, '').gsub(/fullpage/, '').titleize
    @parent = @section[0..index].gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@.*$/, '').titleize

    @breadcrumbs = []
    @breadcrumbs << @parent if @parent != '0'
    @breadcrumbs << @title.split('/').flatten if @title && @parent != '0'
    @breadcrumbs.flatten!

    @elements = ElementFinder.find(File.join(Rails.root, 'app/views/preview/elements/'))
  end

  def resolve_layout
    case action_name
    when 'main'
      "application"
    else
      "application"
    end
  end
end

class ElementFinder
  def initialize(path)
    @path = path
  end

  def self.find(path, parent_section=nil, name=nil)
    section = path.gsub(File.join(Rails.root, 'app/views/preview/elements/').to_s, '')

    data = {
      section: section,
      target_name:      File.basename(path, '.html.erb').to_s,
      display_name:     File.basename(path, '.html.erb').to_s.gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').titleize,
      icon:             path.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "#{path.match(/@([\w+-]*)/)[0][1..-1]}"
    }

    data[:children] = children = []

    Dir.foreach(path).sort {|el1, el2| el1 <=> el2}.each do |entry|
      next if (entry == '..' || entry == '.' || entry == '.DS_Store')
      full_path = File.join(path, entry)

      if File.directory?(full_path)
        children << find(full_path, section, entry)
      else
        childdata = {
          section:          section + '/' + File.basename(entry, '.html.erb').to_s,
          target_name:      File.basename(entry, '.html.erb').to_s,
          display_name:     File.basename(entry, '.html.erb').to_s.gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').gsub('fullpage', '').titleize,
          icon:             entry.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "#{entry.match(/@([\w+-]*)/)[0][1..-1]}"
        }
        children << childdata
      end
    end

    return data
  end
end
