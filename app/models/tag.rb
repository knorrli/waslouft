# monkey patched to allow ransack searches
module ActsAsTaggableOn
  class Tag < ActsAsTaggableOn.base_class.constantize
    def self.ransackable_associations(auth_object = nil)
      ['taggings']
    end

    def self.ransackable_attributes(auth_object = nil)
      ['name']
    end
  end
end
