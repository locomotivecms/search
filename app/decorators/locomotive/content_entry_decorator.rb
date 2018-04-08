Locomotive::ContentEntry.class_eval do
  include Locomotive::Concerns::Search
  include Locomotive::Concerns::ContentEntry::IndexContent
end

