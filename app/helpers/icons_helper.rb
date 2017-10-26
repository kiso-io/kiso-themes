module IconsHelper
  # Icon from FontAwesome. Use the name without the 'icon-' prefix.
  # Eg.:
  #
  #   <%= fa_icon_tag "remove" %>
  #
  def fa_icon_tag(name, opts={})
    content_tag(:i, nil, class: "fa fa-#{name} #{opts[:class]}")
  end

  # Icon from Glyphicon Icons. Use the name without the 'glyphicon glyphicon-' prefix.
  # Eg.:
  #
  #   <%= glyphicon_tag "cloud-download" %>
  #
  def glyphicon_tag(name, opts={})
    content_tag(:i, nil, class: "glyphicon glyphicon-#{name} #{opts[:class]}")
  end

  # Icon from Ionicons. Use the name without the 'icon ion-' prefix.
  # Eg.:
  #
  #   <%= ionicon_icon_tag "remove" %>
  #
  def ionicon_icon_tag(name, opts={})
    content_tag(:i, nil, class: "icon ion-#{name} #{opts[:class]}")
  end

  # Icon from Material Design Icons.
  # Eg.:
  #
  #   <%= mdi_icon_tag "mdi-action-account-box" %>
  #
  def mdi_icon_tag(name, opts={})
    content_tag(:i, name, class: "material-icons #{opts[:class]}")
  end

  # Icon from Themify Icon set.
  # Eg.:
  #
  #   <%= themify_icon_tag "alert" %>
  #
  def themify_icon_tag(name, opts={})
    content_tag(:i, nil, class: "ti-#{name} #{opts[:class]}")
  end

  # Provides a layer of indirection between the template
  # and the actual Icon set being used.
  # Eg.:
  #
  #   <%= theme_icon_tag "mdi-action-account-box" %>
  #
  def theme_icon_tag(name, opts={})
    themify_icon_tag(name, opts)
  end
end
