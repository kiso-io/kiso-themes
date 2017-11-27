require "generators/rrt/page_generator"

module RRT
  module Generators
    class PricingPagesGenerator < PageGenerator
      view_name "frontend_pages/pricing_pages", "pricing_page"
      namespace "rrt:pricing_pages"
    end
  end
end
