module ApplicationHelper
  def app_name
    "My App"
  end

  def current_style
    cookies[:style] || 'blue'
  end
end
