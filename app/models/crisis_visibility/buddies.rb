module CrisisVisibility
  class Buddies < Base
    def buddies
      organization.battle_buddies
    end
  end
end
