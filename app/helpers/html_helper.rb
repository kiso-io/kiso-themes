module HtmlHelper
  # paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/
  def html_tag(options={}, &block)
    custom_class = options[:class] ? ' ' + options[:class] : ''
    raw "<!--[if lt IE 7]>" +
          tag(:html, options.merge(:class => "lt-ie9 lt-ie8 lt-ie7#{custom_class}"), true) +
        "<![endif]-->\n" +
        "<!--[if IE 7]>" +
          tag(:html, options.merge(:class => "lt-ie9 lt-ie8#{custom_class}"), true) + "<![endif]-->\n" +
        "<!--[if IE 8]>" +
          tag(:html, options.merge(:class => "lt-ie9#{custom_class}"), true) +
        "<![endif]-->\n" +
        "<!--[if gt IE 8]><!-->" +
          tag(:html, options, true) +
        "<!--<![endif]-->\n" +
          capture(&block) +
        "</html>"
  end
end