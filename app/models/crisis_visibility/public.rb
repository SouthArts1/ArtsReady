module CrisisVisibility
  class Public < Base
    def buddies
      organization.battle_buddies
    end
  end
end
