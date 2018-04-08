module Locomotive
  module Concerns
    module ContentEntry

      module IndexContent

        def content_to_index
          self.custom_fields_basic_attributes.map do |(_, value)|
            next unless value.is_a?(String)
            ::ActionController::Base.helpers.strip_tags(value)
          end.compact.join(' ')
        end

        def data_to_index
          self.custom_fields_basic_attributes.dup.merge(
            '_content_type' => self.content_type.slug,
            '_slug'         => self._slug
          )
        end

        private

        def index_content
          Locomotive::SearchIndexContentEntryJob.perform_later(
            self._id.to_s,
            ::Mongoid::Fields::I18n.locale.to_s
          )
        end

        def unindex_content
          Locomotive::SearchDeleteContentEntryIndexJob.perform_later(
            self._id.to_s,
            ::Mongoid::Fields::I18n.locale.to_s
          )
        end

      end

    end
  end
end

