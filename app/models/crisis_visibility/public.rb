module CrisisVisibility
  class Public < Base
    def organizations_for_declaration
      Organization.active
    end
  end
end
