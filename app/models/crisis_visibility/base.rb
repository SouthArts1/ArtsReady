module CrisisVisibility
  class Base
    attr_accessor :organization

    def initialize(options = {})
      self.organization = options[:organization]
    end
  end
end
