module ApplicationHelper
  def app_name
    "My App"
  end

  def current_style
    cookies[:style] || 'blue'
  end

  def render_children attributes, level=1
    level_class = 'nav-second-level'

    case level
    when 1
      level_class = 'nav-second-level'
    when 2
      level_class = 'nav-third-level'
    end

    klass     = "nav #{level_class} collapse"
    is_parent_active = @section.downcase.include?(attributes[0][:parent_file_name].downcase ) || @section.downcase.include?(attributes[0][:target_name].downcase )
    is_active = is_parent_active || @section.downcase.include?(attributes[1][:parent_file_name].downcase ) || @section.downcase.include?(attributes[1][:target_name].downcase )
    klass     = "#{klass} in direct" if is_active

    content_tag :ul, class: klass, 'aria-expanded': false do
      attributes.each do |attribute|
        if !attribute[:children].nil?
          level = level + 1
          concat(content_tag(:li, attribute[:display_name], class: is_parent_active ? 'active' : '') do
            concat(content_tag(:a, '#') do
              concat( attribute[:display_name] )
              concat(content_tag(:span, nil, class: 'fa arrow'))
            end)
            concat(render_children(attribute[:children], level))
          end)
        else
          concat(activatable_li_tag_with_link attribute[:display_name], element_path(File.join(attribute[:parent_file_name],attribute[:target_name])))
        end
      end
    end
  end
end
