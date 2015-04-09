module ApplicationHelper
  def app_name
    "My App"
  end

  def random_avatar size=64, css_class
    value = (rand() * 4 + 1).to_i
    image_tag "#{value}.jpg", class: css_class, width: size, height: size
  end

  def current_style
    cookies[:style] || 'blue'
  end

  def random_dollar_value( min=10, max=2000 )
    random_value = ((max.to_f - min.to_f) * rand() + min).round(0)
    "$#{random_value}"
  end

  def random_percent
    random_value = ((100.0 - 0.0) * rand()).round(0)
    "#{random_value}%"
  end

  def random_number
    random_value = ((320.0 - 0.0) * rand()).round(0)
    "#{random_value}"
  end

  def random_value(type)
    if type == :dollar
      return random_dollar_value
    elsif type == :percent
      return random_percent
    else
      return random_number
    end
  end

  def increase_or_decrease
    types = [:increase, :decrease, :steady]
    selection = types[rand()*types.length]
    selection
  end

  def increase_or_decrease_chevron(direction)
    if direction == :increase
      "fa-chevron-up"
    elsif direction == :decrease
      "fa-chevron-down"
    else
      "fa-chevron-down"
    end
  end

  def increase_or_decrease_class(direction)
    if direction == :increase
      "text-success"
    elsif direction == :decrease
      "text-danger"
    else
      "text-danger"
    end
  end

  def metric_names
    [{ name: 'Bounce Rate', type: :percent}, {name: 'Cancellations', type: :number}, {name: 'Refunds', type: :dollar},
      {name: 'Charges', value: :dollar}, {name: 'Time on Site', type: :time}, {name: 'Average Revenue per Customer', type: :dollar},
      {name: 'LTV', type: :dollar}, {name: 'Churn', type: :percent}, {name: 'Page Hits', type: :number}, {name: 'Support Queries', type: :number}]
  end

  def random_trending_up_data
    data = []
    (0..7).each do |index|
      data << [index, index + rand()]
    end
    data
  end

  def random_trending_down_data
    data = []
    (0..7).each do |index|
      val = index - rand()
      data << [7-index, val < 0 ? 0 : val]
    end
    data
  end

  def random_steady_data
    data = []
    (0..7).each do |index|
      data << [index, 5 + rand()]
    end
    data
  end

  def random_trending_data(direction)
    types = [random_trending_up_data, random_steady_data, random_trending_down_data]
    selection = types[rand*types.length]

    selection
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

    content_tag(:ul, class: klass, :'aria-expanded'=> false) do
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
