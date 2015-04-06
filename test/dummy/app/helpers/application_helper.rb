module ApplicationHelper
  def app_name
    "My App"
  end

  def current_style
    cookies[:style] || 'blue'
  end

  def render_children attributes, level=1
    level_class = ''

    case level
    when 1
      level_class = 'nav-second-level'
    when 2
      level_class = 'nav-third-level'
    when 3
      level_class = 'nav-fourth-level'
    else
      level_class = 'nav-fourth-level'
    end

    klass     = "nav #{level_class} collapse"

    is_active = @section.downcase.include?(attributes[0][:section].downcase )
    klass     = "#{klass} in direct" if is_active

    content_tag :ul, class: klass, 'aria-expanded': false do
      attributes.each do |attribute|
        if !attribute[:children].nil?
          parent_is_active = @section.include?(attribute[:section])
          concat(content_tag(:li, raw(attribute[:display_name]), class: parent_is_active ? 'active' : '') do
            concat(content_tag(:a, '#') do
              concat( raw(attribute[:display_name]) )
              concat(content_tag(:span, nil, class: 'fa arrow'))
            end)
            concat(render_children(attribute[:children], level+1))
          end)
        else
          concat(activatable_li_tag_with_link raw(attribute[:display_name]), element_path(File.join(attribute[:section],attribute[:target_name])))
        end
      end
    end
  end
end
