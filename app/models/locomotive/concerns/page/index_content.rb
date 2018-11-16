module Locomotive
  module Concerns
    module Page

      module IndexContent

        def content_to_index
          # index the editable elements (legacy)
          content = editable_elements_to_index

          # index the sections, rely on the definitions to know which settings to index
          definitions = self.site.sections.pluck(:slug, :definition).to_h

          # static sections
          content += sections_content_to_index(definitions)

          # sections dropzone
          content += sections_dropzone_content_to_index(definitions)

          content.join(' ').strip
        end

        def data_to_index
          {
            title:      self.title,
            slug:       self.slug,
            fullpath:   self.fullpath
          }
        end

        private

        def index_content
          # don't index the 404 error page and the templatized page
          return if self.not_found? || self.templatized? || self.redirect?

          # don't block the server app
          Locomotive::SearchIndexPageJob.perform_later(
            self._id.to_s,
            ::Mongoid::Fields::I18n.locale.to_s
          )
        end

        def unindex_content
          # don't index the 404 error page
          return if self.not_found?

          # don't block the server app
          Locomotive::SearchDeletePageIndexJob.perform_later(
            self.site_id.to_s,
            self._id.to_s,
            ::Mongoid::Fields::I18n.locale.to_s
          )
        end

        def editable_elements_to_index
          self.editable_elements.where(_type: 'Locomotive::EditableText').map do |element|
            sanitize_search_content(element.content)
          end
        end

        def sections_content_to_index(definitions)
          (self.sections_content || {}).map do |type, section|
            section['type'] ||= type
            section_content_to_index(section, definitions)
          end.compact
        end

        def sections_dropzone_content_to_index(definitions)
          (self.sections_dropzone_content || []).map do |section|
            section_content_to_index(section, definitions)
          end.compact
        end

        def section_content_to_index(section, definitions)
          return nil if section.blank?

          definition = definitions[section['type']]

          return nil if definition.blank?

          # main settings
          content = definition['settings'].map do |setting|
            next unless setting['type'] == 'text'

            sanitize_search_content(section['settings'][setting['id']])
          end

          # block settings
          (section['blocks'] || []).each do |block|
            _definition = definition['blocks'].find { |block_definition| block_definition['type'] == block['type'] }

            next if _definition.blank?

            _definition['settings'].each do |_setting|
              next unless _setting['type'] == 'text'

              content << sanitize_search_content(block['settings'][_setting['id']])
            end
          end

          content.compact.join(' ').strip
        end

      end

    end
  end
end

