module Locomotive
  module Concerns
    module ContentEntry

      module IndexContent

        def content_to_index
          self.custom_fields_basic_attributes.map do |(name, value)|
            _name = name.gsub(/_id$/, '').gsub(/_url$/, '')

            next if !value.is_a?(String) ||
              name == _label_field_name.to_s || # no need to index the label (already searchable)
              name.end_with?('_id') || # don't index attributes like youtube_id, ...etc
              self.file_custom_fields.include?(_name)

            sanitize_search_content(value)
          end.compact.join(' ').strip
        end

        def data_to_index(parent = false)
          data = default_data_to_index

          data.merge!(self.custom_fields_basic_attributes) unless parent

          # we also index the belongs_to relationships but we only keep
          # the most important data: _label, _slug, _content_type and
          # potentially their own belongs_to relationships (recursive)
          self.belongs_to_custom_fields.each do |name|
            data[name] = send(name.to_sym)&.data_to_index(true)
          end

          data
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
            self.site_id.to_s,
            self.content_type.slug,
            self._id.to_s,
            ::Mongoid::Fields::I18n.locale.to_s
          )
        end

        def default_data_to_index
          {
            '_content_type' => self.content_type.slug,
            '_slug'         => self._slug,
            '_label'        => self._label
          }
        end

      end

    end
  end
end

