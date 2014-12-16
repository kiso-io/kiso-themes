module IconsHelper
  # Icon from FontAwesome. Use the name without the 'icon-' prefix.
  # Eg.:
  #
  #   <%= icon_tag "remove" %>
  #
  def icon_tag(name)
    content_tag(:i, nil, :class => "fa fa-#{name}")
  end
end