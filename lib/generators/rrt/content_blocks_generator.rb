require "generators/rrt/handler_support"
require_relative "../../../support/page_rewriter"

module RRT
  module Generators
    class ContentBlocksGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/views', __FILE__)

      namespace "rrt:content_blocks"

      desc "Copies the bundled content blocks into your views directory."

      def copy_content_blocks
        directory 'content_blocks', Rails.root.join('app/views/content_blocks'), recursive:true
      end
    end
  end
end
