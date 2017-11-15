module ApplicationHelper
  def app_name
    'PYRMID'
  end

  def current_style
    cookies[:style] || Kernel.const_get('RRT::Orion::COLORS')[0]
  end

  def current_theme
    cookies[:theme] || 'Orion'
  end

  def random_dollar_value(min = 10, max = 2000)
    random_value = ((max.to_f - min.to_f) * rand + min).round(0)
    "$#{random_value}"
  end

  def random_percent
    random_value = ((100.0 - 0.0) * rand).round(0)
    "#{random_value}%"
  end

  def random_number
    random_value = ((320.0 - 0.0) * rand).round(0)
    random_value.to_s
  end

  def random_value(type)
    if type == :dollar
      random_dollar_value
    elsif type == :percent
      random_percent
    else
      random_number
    end
  end

  def increase_or_decrease
    types = %i[increase decrease steady]
    selection = types[rand * types.length]
    selection
  end

  def increase_or_decrease_chevron(direction)
    if direction == :increase
      'fa-chevron-up'
    elsif direction == :decrease
      'fa-chevron-down'
    else
      'fa-chevron-down'
    end
  end

  def increase_or_decrease_class(direction)
    if direction == :increase
      'text-success'
    elsif direction == :decrease
      'text-danger'
    else
      'text-danger'
    end
  end

  def metric_names
    [{ name: 'Bounce Rate', type: :percent }, { name: 'Cancellations', type: :number }, { name: 'Refunds', type: :dollar },
     { name: 'Charges', value: :dollar }, { name: 'Time on Site', type: :time }, { name: 'Average Revenue per Customer', type: :dollar },
     { name: 'LTV', type: :dollar }, { name: 'Churn', type: :percent }, { name: 'Page Hits', type: :number }, { name: 'Support Queries', type: :number }]
  end

  def random_trending_up_data
    data = []
    (0..7).each do |index|
      data << [index, index + rand]
    end
    data
  end

  def random_trending_down_data
    data = []
    (0..7).each do |index|
      val = index - rand
      data << [7 - index, val < 0 ? 0 : val]
    end
    data
  end

  def random_steady_data
    data = []
    (0..7).each do |index|
      data << [index, 5 + rand]
    end
    data
  end

  def random_trending_data(_direction)
    types = [random_trending_up_data, random_steady_data, random_trending_down_data]
    selection = types[rand * types.length]

    selection
  end

  def render_children(attributes, level = 1)
    level_class = ''

    level_class = case level
                  when 1
                    'nav-second-level'
                  when 2
                    'nav-third-level'
                  when 3
                    'nav-fourth-level'
                  else
                    'nav-fourth-level'
                  end

    is_active = attributes.map { |attr| attr[:section].downcase }.select { |i| @section.downcase.include?(i) }.any?

    klass     = "nav-item #{level_class} #{is_active ? 'nav-direct' : ''} collapse"
    klass     = "#{klass} in" if is_active

    content_tag(:ul, class: klass, :'aria-expanded' => klass.include?('in') || klass.include?('direct')) do
      attributes.each do |attribute|
        if !attribute[:children].nil?
          parent_is_active = @section.downcase.include?(attribute[:section].downcase)
          concat(content_tag(:li, raw(attribute[:display_name]), class: parent_is_active ? 'nav-item active' : 'nav-item') do
            concat(content_tag(:a, '#', class: 'nav-link') do
              concat(content_tag(:span, attribute[:display_name].chomp))
              concat(content_tag(:span, nil, class: 'fa arrow'))
            end)
            concat(render_children(attribute[:children], level + 1))
          end)
        else
          opts = {
            class: 'nav-item'
          }

          concat(
            activatable_li_tag_with_link(
              content_tag(:span, attribute[:display_name].chomp),
              element_path(File.join(attribute[:section])),
              opts
            )
          )
        end
      end
    end
  end
end
