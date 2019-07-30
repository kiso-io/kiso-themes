require "generators/kiso_themes/page_generator"

module KisoThemes
  module Generators
    class PricingPagesGenerator < PageGenerator
      view_name "frontend_pages/pricing_pages", "pricing_page"
      namespace "kiso_themes:pricing_pages"
    end
  end
end
