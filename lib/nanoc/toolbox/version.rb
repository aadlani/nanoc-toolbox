module Nanoc
  module Toolbox
    # Holds information about library version.
    module Version
      MAJOR = 0
      MINOR = 0
      PATCH = 6
      BUILD = nil

      STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join(".")
    end

    # The current library version.
    VERSION = Version::STRING
  end
end
