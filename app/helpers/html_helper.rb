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

  def random_avatar size=64, css_class
    value = (rand() * 4 + 1).to_i
    image_tag "rrt/stock/#{value}.jpg", class: css_class, width: size, height: size, 'data-turbolinks-permanent': true
  end

  def random_landscape width='100%', css_class=''
    image_tag random_landscape_name, class: css_class, width: width
  end

  def random_landscape_name
    value = (rand() * 10 + 1).to_i
    "rrt/stock/landscape_#{value}.jpg"
  end

  def code_block(&block)
    code = capture(&block)
    indent = code.scan(/^ +/).first.size

    code.gsub!(/^ {#{indent}}/, "")
    code.chomp!

    content_tag :pre, code, :class => "prettyprint linenums"
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade show", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }, 'aria-label' => "Close" ) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
        end)
        case
        when bootstrap_class_for(msg_type) == "alert-success"
          concat content_tag(:span, '<i class="fa fa-check-circle"></i>'.html_safe, 'aria-hidden' => true)
        when bootstrap_class_for(msg_type) == ("alert-danger" || "alert-warning")
          concat content_tag(:span, '<i class="fa fa-times-circle"></i>'.html_safe, 'aria-hidden' => true)
        else
          concat content_tag(:span, '<i class="fa fa-info-circle"></i>'.html_safe, 'aria-hidden' => true)
        end
        concat " " + message
      end)
    end
    nil
  end
end
