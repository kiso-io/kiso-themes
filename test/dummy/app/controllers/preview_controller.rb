class PreviewController < ApplicationController

  layout :resolve_layout

  def index
    @body_class = 'theme-container'
  end

  def main
    @body_class = 'main'
    @section = params[:section] || "001_dashboard@fa-dashboard"
    index = @section.index('/') || 0
    index = index + 1 if index > 0
    @title = @section[index..@section.length].gsub(/^\d{3}_/, '').gsub(/@\w+-\w+$/, '')

    @elements = ElementFinder.new('app/views/preview/elements/*').find
  end

  def switch_style
    @style = params[:style]

    raise ArgumentError, "Invalid style" unless @style.in?(Dresssed::Ives::COLORS)

    cookies[:style] = @style

    redirect_to :back
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

  def find()
    top_level_elements = Dir.glob(@path)
    results = []

    top_level_elements.sort {|el1, el2| el1 <=> el2}.each do |el|
      parent = {
        parent_file_name: el,
        parent_name:      File.basename(el, '.html.erb').to_s,
        target_name:      File.basename(el, '.html.erb').to_s.gsub(/@\w+-\w+$/, ''),
        display_name:     File.basename(el, '.html.erb').to_s.gsub('_', ' ').gsub(/^\d{3} /, '').gsub(/@\w+-\w+$/, '').titleize,
        icon:             el.match(/@\w+-\w+/).nil? ? 'fa-gift' : el.match(/@\w+-\w+/)[0][1..-1],
        children:         []
      }

      if File.directory?(el)
        Dir.glob(@path.gsub('*',"#{Pathname.new(el).basename}/*")).each do |child|
          parent[:children] << {
            child_file_name: child,
            child_name:   File.basename(child, '.html.erb').to_s,
            display_name: File.basename(child, '.html.erb').to_s.gsub('_', ' ').titleize,
            icon:         child.match(/@\w+-\w+$/).nil? ? 'fa-cogs' : child.match(/@\w+-\w+$/)[0][1..-1],
          }
        end
      end

      results << parent
    end
    results
  end
end