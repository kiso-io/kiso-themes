module IconsHelper
  # Icon from FontAwesome. Use the name without the 'icon-' prefix.
  # Eg.:
  #
  #   <%= icon_tag "remove" %>
  #
  def fa_icon_tag(name)
    content_tag(:i, nil, class: "fa fa-#{name}")
  end

  def ionicon_icon_tag(name)
    content_tag(:i, nil, class: "icon ion-#{name}")
  end
end