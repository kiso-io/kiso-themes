module RRT
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__))

  THEMES = ['Orion', 'Gemini', 'Auriga', 'Lyra']

  module Orion
    COLORS = [
              'blue',
              'purple',
              'orange',
              'green'
             ].freeze
  end

  module Gemini
    COLORS = [
      "blue",
      "ocean",
      "amber",
      "granite"
    ]
  end

  module Auriga
    COLORS = [
      "blue",
      "green",
      "red",
      "yellow"
    ]
  end

  module Lyra
    COLORS = ["charcoal"]
  end
end
