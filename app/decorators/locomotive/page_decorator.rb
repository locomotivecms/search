Locomotive::Page.class_eval do
  include Locomotive::Concerns::Search
  include Locomotive::Concerns::Page::IndexContent
end

