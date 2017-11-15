class PreviewController < ApplicationController
  layout :resolve_layout


  ## DEVISE FAKING SHIT ##########################################################
  if respond_to?(:helper_method)
    helpers = %w(resource scope_name resource_name signed_in_resource
                 resource_class resource_params devise_mapping)
    helper_method(*helpers)
  end

  # Gets the actual resource stored in the instance variable
  def resource
    User.new
  end

  # Proxy to devise map name
  def resource_name
    "User"
  end
  alias :scope_name :resource_name

  # Proxy to devise map class
  def resource_class
    "User"
  end

  ## END DEVISE FAKING SHIT ############################################################

  def index
    @body_class = 'theme-container'

    @themes = RRT::THEMES.map do |theme|
      { theme: theme.titlecase,
        colors: Kernel.const_get("RRT::#{theme.titlecase}::COLORS") }
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

    @current_theme = cookies[:theme] || "Orion"
    @current_style = cookies[:style] || Kernel.const_get('RRT::Orion::COLORS')[0]

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

    @resource_name = User.new

    if @current_layout == '_minimal'
      render partial: "minimal"
    elsif @current_layout == '_app_nav'
      render file: "preview/elements/#{@section}", layout: "layouts/_app_nav"
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

  def self.is_fullpage(path)
    !path.match(/minimal|app_nav/).nil?
  end

  def self.find(path, parent_section=nil, name=nil)
    section = path.gsub(File.join(Rails.root, 'app/views/preview/elements/').to_s, '')
    basename = File.basename(path, '.html.erb')

    data = {
      is_header:    basename.to_s.match(/^\d{3}_header/),
      header_title: basename.to_s.match(/^\d{3}_header/) && basename.to_s.match(/^\d{3}_header_[\w\W]+/)[0].gsub(/^\d{3}_header_/, ''),
      section:      section,
      target_name:  basename.to_s,
      is_fullpage:  is_fullpage(path),
      display_name: display_name(File.basename(path, '.html.erb')),
      icon:         path.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "#{path.match(/@([\w+-]*)/)[0][1..-1]}"
    }

    data[:children] = children = []

    Dir.foreach(path).sort_by { |s| s.scan(/\d+/).first.to_i }.each do |entry|
      next if (entry == '..' || entry == '.' || entry == '.DS_Store' || entry[0] == '_')
      full_path = File.join(path, entry)

      if File.directory?(full_path)
        children << find(full_path, section, entry)
      else
        childdata = {
          is_header: !File.basename(entry, '.html.erb').to_s.match(/^\d{3}_header/).nil?,
          header_title: !File.basename(entry, '.html.erb').to_s.match(/^\d{3}_header/).nil? &&
          File.basename(entry, '.html.erb').to_s.match(/^\d{3}_header_[\w\W]+/)[0].gsub(/^\d{3}_header_/, '').gsub(/_/, ' '),
          section:          section + '/' + File.basename(entry, '.html.erb').to_s,
          target_name:      File.basename(entry, '.html.erb').to_s,
          is_fullpage:      is_fullpage(File.basename(entry, '.html.erb')),
          display_name:     display_name(File.basename(entry, '.html.erb')),
          icon:             entry.match(/@([\w+-]*)/).nil? ? 'fa-gift' : "#{entry.match(/@([\w+-]*)/)[0][1..-1]}"
        }
        children << childdata
      end
    end

    return data
  end
end
