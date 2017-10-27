module Dresssed
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__))

  THEMES = ['Now', 'Carbon']

  module Now
    COLORS = ['blue', 'purple'].freeze
  end

  module Carbon
    COLORS = ["black"]
  end
end
