class PreviewController < ApplicationController

  layout :resolve_layout

  def index
    @body_class = 'theme-container'
  end

  def main
    @body_class = 'main'

    redirect_to element_path('001_dashboard@fa-dashboard') and return if params[:section].nil?

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

    render template: 'preview/minimal' and return if params[:section] && (params[:section].include?('004_app_pages') || params[:section].include?('fullpage') )
  end

  def styles
    @style = params[:style]

    raise ArgumentError, "Invalid style" unless @style.in?(Dresssed::Ives::COLORS)

    cookies[:style] = @style

    redirect_to element_path('001_dashboard@fa-dashboard') and return unless params[:demo_frame].present?
    redirect_to root_path
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
      section: path.gsub(File.join(Rails.root, 'app/views/preview/elements/').to_s, ''),
      target_name:      File.basename(path, '.html.erb').to_s,
      display_name:     File.basename(path, '.html.erb').to_s.gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').titleize,
      icon:             path.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "fa-fw #{path.match(/@([\w+-]*)/)[0][1..-1]}"
    }

    data[:children] = children = []
    Dir.foreach(path).sort {|el1, el2| el1 <=> el2}.each do |entry|
      next if (entry == '..' || entry == '.' || entry == '.DS_Store')
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        children << find(full_path, entry)
      else
        childdata = {
          section:          data[:section].gsub(File.join(Rails.root, 'app/views/preview/elements/').to_s, ''),
          target_name:      File.basename(entry, '.html.erb').to_s,
          display_name:     File.basename(entry, '.html.erb').to_s.gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').gsub('fullpage', '').titleize,
          icon:             entry.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "fa-fw #{entry.match(/@([\w+-]*)/)[0][1..-1]}"
        }
        children << childdata
      end
    end
    return data
  end
end