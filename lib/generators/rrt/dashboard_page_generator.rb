require "generators/rrt/page_generator"

module RRT
  module Generators
    class DashboardPageGenerator < PageGenerator
      view_name "dashboards","dashboard"

      namespace "rrt:dashboard_page"
    end
  end
end
