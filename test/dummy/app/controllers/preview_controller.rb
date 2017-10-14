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

    redirect_to element_path('001_dashboards@ti-dashboard/001_dashboard_1') and return if params[:section].nil?

    @section = params[:section]
    index = @section.index('/') || 0
    index = index + 1 if index > 0
    @title = @section[index..@section.length].gsub('_', ' ').gsub(/\$.\w+/, '').gsub(/\d{3} /, '').gsub(/@([\w+-]*)$/, '').gsub(/fullpage/, '').titleize
    @parent = @section[0..index].gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@.*$/, '').titleize

    @current_layout = @section.match(/\$.\w+/) && @section.match(/\$.\w+/)[0].gsub(/\$/, '_')

    @breadcrumbs = []
    @breadcrumbs << @parent if @parent != '0'
    @breadcrumbs << @title.split('/').flatten if @title && @parent != '0'
    @breadcrumbs.flatten!

    @elements = ElementFinder.find(File.join(Rails.root, 'app/views/preview/elements/'))

    if @current_layout == '_minimal'
      render partial: "minimal"
    elsif @current_layout == '_app_nav'
      render partial: "app_nav"
    else
      @body_class = ' with-sidebar show-sidebar'
    end
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

  def self.display_name(path)
    path.to_s.gsub(/\$.\w+/, '').gsub(/\$app_nav/, '').gsub(/minimal|fullpage/, '').gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@([\w+-]*)$/, '').gsub(/$.[\w_]+/, '').titleize
  end

  def self.find(path, parent_section=nil, name=nil)
    section = path.gsub(File.join(Rails.root, 'app/views/preview/elements/').to_s, '')

    data = {
      is_header: File.basename(path, '.html.erb').to_s.match(/header/),
      header_title: File.basename(path, '.html.erb').to_s.match(/header/) && File.basename(path, '.html.erb').to_s.match(/header_\w+/)[0].gsub(/header_/, ''),
      section: section,
      target_name:      File.basename(path, '.html.erb').to_s,
      display_name:     display_name(File.basename(path, '.html.erb')),
      icon:             path.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "#{path.match(/@([\w+-]*)/)[0][1..-1]}"
    }

    data[:children] = children = []

    Dir.foreach(path).sort {|el1, el2| el1 <=> el2}.each do |entry|
      next if (entry == '..' || entry == '.' || entry == '.DS_Store' || entry[0] == '_')
      full_path = File.join(path, entry)

      if File.directory?(full_path)
        children << find(full_path, section, entry)
      else
        childdata = {
          is_header: !File.basename(entry, '.html.erb').to_s.match(/header/).nil?,
          header_title: !File.basename(entry, '.html.erb').to_s.match(/header/).nil? &&
          File.basename(entry, '.html.erb').to_s.match(/header_\w+/)[0].gsub(/header_/, '').gsub(/_/, ' '),
          section:          section + '/' + File.basename(entry, '.html.erb').to_s,
          target_name:      File.basename(entry, '.html.erb').to_s,
          display_name:     display_name(File.basename(entry, '.html.erb')),
          icon:             entry.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "#{entry.match(/@([\w+-]*)/)[0][1..-1]}"
        }
        children << childdata
      end
    end

    return data
  end
end
