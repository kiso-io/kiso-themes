module Dresssed
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__))

  THEMES = ['Now']

  # module Ives
  #   COLORS = ['blue', 'amber', 'black', 'white'].freeze
  # end
  #
  # module Gimlet
  #   COLORS = ['blue', 'amber', 'black'].freeze
  # end

  module Now
    COLORS = ['orange'].freeze
  end
end
