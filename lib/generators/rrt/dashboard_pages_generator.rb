require "generators/rrt/page_generator"

module RRT
  module Generators
    class DashboardPagesGenerator < PageGenerator
      view_name "dashboards","dashboard"

      namespace "rrt:dashboard_pages"
    end
  end
end
