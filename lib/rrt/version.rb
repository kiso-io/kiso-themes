module RRT
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__))

  THEMES = ['Orion', 'Carbon']

  module Orion
    COLORS = ['blue', 'purple'].freeze
  end

  module Carbon
    COLORS = ["black"]
  end
end
