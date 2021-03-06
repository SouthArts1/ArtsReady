module CrisisVisibility
  class Base
    attr_accessor :organization

    def initialize(options = {})
      self.organization = options[:organization]
    end

    def buddies
      organization.battle_buddies
    end

    def organizations_for_declaration
      buddies.active
    end

    def organizations_for_update
      buddies.active
    end
  end
end
