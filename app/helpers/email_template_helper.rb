module EmailTemplateHelper
  extend ActiveSupport::Concern

  def email_message_spacer( count=1 )
    (1..count).each do
      return capture do
        concat content_tag(:br)
      end
    end
  end

  def email_message_body_text &block
    content_tag(:span, capture(&block), style: "font-family: Avenir, 'Helvetica Neue', Helvetica, sans-serif; font-size:28px; color:#444444;")
  end

  def email_message_small_text &block
    content_tag(:span, capture(&block), style: "font-family: Avenir, 'Helvetica Neue', Helvetica, sans-serif; font-size:22px; color:#444444;")
  end

  def email_message_button &block
    content_tag(:table, border: 0, cellpadding: 0, cellspacing: 0, width: "50%", style: "background-color:#16A086;") do
      content_tag(:tr) do
        concat(email_message_spacer(4))
        concat( content_tag(:td, nil, style: "padding: 18px 20px 18px 20px; font-family:  Avenir, 'Helvetica Neue', Helvetica, sans-serif, sans-serif; color: #ffffff; font-size: 18px; text-align: center;") do
          content_tag(:span, capture(&block), style: "text-decoration: none; color: #ffffff;")
        end)
      end
    end
  end

  def email_message_section &block
    content_tag(:tr) do
      content_tag(:td) do
        content_tag(:table, border: 0, cellpadding: 0, cellspacing: 0, width: "100%") do
          content_tag(:tr) do
            content_tag(:td, align: "center", valign: "top") do
              content_tag(:table, border: 0, cellpadding: 10, cellspacing: 0, width: "100%") do
                content_tag(:tr) do
                  content_tag(:td, capture(&block), align: "center", valign: "top")
                end
              end
            end
          end
        end
      end
    end
  end
end
