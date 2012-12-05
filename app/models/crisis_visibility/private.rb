module CrisisVisibility
  class Private < Base
    attr_accessor :buddy_list

    def initialize(options = {})
      super
      self.buddy_list = options[:buddy_list]
    end

    def buddies
      Organization.where(:id => buddy_list.split(',').map(&:to_i))
    end
  end
end
