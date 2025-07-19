ActsAsTaggableOn.remove_unused_tags = true

# monkey patched to allow ransack searches
module ActsAsTaggableOn
  class Tagging < ActsAsTaggableOn.base_class.constantize
    def self.ransackable_associations(auth_object = nil)
      ['tags']
    end

    def self.ransackable_attributes(auth_object = nil)
      ['context']
    end
  end

  class Tag < ActsAsTaggableOn.base_class.constantize
    include Discard::Model

    def self.ransackable_associations(auth_object = nil)
      ['taggings']
    end

    def self.ransackable_attributes(auth_object = nil)
      ['name']
    end

    def to_combobox_display
      name
    end

    def style_ids
        tagging = ActsAsTaggableOn::Tagging.find_or_initialize_by(
          taggable_type: Style,
          tag_id: id,
          context: :genres
        ).pluck(:taggable_id)
    end


    def style_ids=(joined_ids)
      style_ids = ActsAsTaggableOn.default_parser.new(joined_ids).parse
      assign_added_styles(style_ids: style_ids)
      unassign_removed_styles(style_ids: style_ids)
    end

    private

    def assign_added_styles(style_ids:)
      Style.where(id: style_ids).each do |style|
        # manually creating taggable instead of #genre_list.add for performance reasons
        tagging = ActsAsTaggableOn::Tagging.find_or_initialize_by(
          taggable: style,
          tag_id: id,
          context: :genres
        )
        tagging.save

        Event.tagged_with(name, on: :genres).find_each do |tagged_event|
          tagged_event.style_list.add(style.name)
          tagged_event.save
        end
      end
    end

    def unassign_removed_styles(style_ids:)
      removed_taggings = ActsAsTaggableOn::Tagging.where(tag_id: id, context: :genres, taggable_type: Style.name).where.not(taggable_id: style_ids)
      removed_taggings.each do |removed_tagging|
        Event.tagged_with(removed_tagging.taggable.name, on: :styles).find_each do |tagged_event|
          tagged_event.style_list.remove(removed_tagging.taggable.name)
          tagged_event.save
        end
      end
      removed_taggings.destroy_all
    end
  end
end
