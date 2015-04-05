class PreviewController < ApplicationController

  layout :resolve_layout

  def index
    @body_class = 'theme-container'
  end

  def main
    @body_class = 'main'
    @section = params[:section] || '001_dashboard@fa-dashboard'
    index = @section.index('/') || 0
    index = index + 1 if index > 0
    @title = @section[index..@section.length].gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').gsub(/fullpage/, '').titleize
    @parent = @section[0..index].gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@.*$/, '').titleize

    @breadcrumbs = []
    @breadcrumbs << @parent if @parent != '0'
    @breadcrumbs << @title if @title && @parent != '0'

    @elements = ElementFinder.find(File.join(Rails.root, 'app/views/preview/elements/'))

    render template: 'preview/minimal' and return if params[:section] && (params[:section].include?('004_app_pages') || params[:section].include?('fullpage') )
  end

  def styles
    @style = params[:style]

    raise ArgumentError, "Invalid style" unless @style.in?(Dresssed::Ives::COLORS)

    cookies[:style] = @style

    redirect_to element_path('001_dashboard@fa-dashboard')
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

  def self.find(path, name=nil)
    data = {
      parent_file_name: path,
      parent_name:      File.basename(path, '.html.erb').to_s,
      target_name:      File.basename(path, '.html.erb').to_s.gsub(/@([\w+-]*)$/, ''),
      display_name:     File.basename(path, '.html.erb').to_s.gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').titleize,
      icon:             path.match(/@([\w+-]*)/).nil? ? 'fa-gift' : path.match(/@([\w+-]*)/)[0][1..-1],
    }

    data[:children] = children = []
    Dir.foreach(path).sort {|el1, el2| el1 <=> el2}.each do |entry|
      next if (entry == '..' || entry == '.' || entry == '.DS_Store')
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        children << find(full_path, entry)
      else
        childdata = {
          parent_file_name: data[:parent_file_name].gsub(File.join(Rails.root, 'app/views/preview/elements/').to_s, ''),
          parent_name:      File.basename(entry, '.html.erb').to_s,
          target_name:      File.basename(entry, '.html.erb').to_s.gsub(/@([\w+-]*)$/, ''),
          display_name:     File.basename(entry, '.html.erb').to_s.gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').gsub('fullpage', '').titleize,
          icon:             entry.match(/@([\w+-]*)/).nil? ? 'fa-gift' : entry.match(/@([\w+-]*)/)[0][1..-1],
        }
        children << childdata
      end
    end
    return data
  end
end