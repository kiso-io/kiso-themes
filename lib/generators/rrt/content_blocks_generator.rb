require 'pathname'
require "generators/rrt/handler_support"
require_relative "../../../support/page_rewriter"

module RRT
  module Generators
    class ContentBlocksGenerator < Rails::Generators::Base
      include HandlerSupport

      desc "Copies the bundled content blocks into your views directory."
      source_root File.expand_path('../../../../app/views', __FILE__)
      namespace "rrt:content_blocks"

      def copy_content_blocks
        layouts_path = "app/views/content_blocks"
        source_path = "../../../../app/views/content_blocks"
        target_full_base_path = Pathname.new(File.expand_path(source_path, __FILE__))
        layouts = Dir.glob(File.expand_path("#{source_path}/**/*", __FILE__)).select { |lf|
          lf.end_with? handler
        }.map { |lf|
          Pathname.new(lf).relative_path_from(target_full_base_path).to_s
        }

        layouts.each do |name|
          copy_file File.join(source_path, name), "#{layouts_path}/#{name}"
        end
      end
    end
  end
end
