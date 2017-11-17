module RRT
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__))

  THEMES = ['Orion', 'Gemini', 'Auriga', 'Lyra']

  module Orion
    COLORS = ['blue', 'purple'].freeze
  end

  module Gemini
    COLORS = ["blue"]
  end

  module Auriga
    COLORS = ["black"]
  end

  module Lyra
    COLORS = ["charcoal"]
  end
end
