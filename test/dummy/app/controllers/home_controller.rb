class HomeController < ApplicationController

  layout :resolve_layout

  def index
    @body_class = 'landing'
  end

  def kitchen_sink
  end

  def css
  end

  def components
  end

  def javascript
  end

  private

  def resolve_layout
    case action_name
    when 'index'
      "home"
    else
      "application"
    end
  end
end
