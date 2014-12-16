require "generators/dresssed/page_generator"

module Dresssed
  module Generators
    class HomeGenerator < PageGenerator
      view_name "home"
      
      def copy_image
        copy_file "featured_shot.png", "app/assets/images/featured_shot.png"
      end
    end
  end
end
