module CrisisVisibility
  class Public < Base
    def organizations_for_declaration
      Organization.approved
    end
  end
end
