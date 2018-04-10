FactoryBot.define do

  factory :site, class: 'Locomotive::Site' do
    name            'Acme Website'
    handle          'acme'
    created_at      Time.now

    trait :algolia do
      metafields { { 'algolia' => { 'application_id' => ENV['ALGOLIA_APPLICATION_ID'], 'api_key' => ENV['ALGOLIA_API_KEY'] } } }
    end

    after(:build) do |site_test|
      site_test.created_by = create(:account)
      site_test.memberships.build account: Locomotive::Account.where(name: 'Joe MacMillan').first || create(:account), role: 'admin'
    end
  end

  factory :account, class: 'Locomotive::Account' do
    name                    'Joe MacMillan'
    email                   'joe@cardiff-electric.com'
    password                'easyone'
    password_confirmation   'easyone'
  end

  factory :page, class: 'Locomotive::Page' do
    title 'A simple page'
    slug 'simple'
    published true
    site { Locomotive::Site.where(handle: 'acme').first || create(:site) }

    after(:build) do |page, _|
      page.editable_elements << build(:editable_element_text)
      page.editable_elements << build(:editable_element_file)
      page.editable_elements << build(:editable_element_text, slug: 'ee-3', content: "Hello world. <p>The search <string>feature</string> is awesome</p>")
      page.raw_template = '<html><body>Page goes here</body></html>'
      page.save
    end

    trait :indexed do
      site { create(:site, :algolia) }
    end

    trait :page_not_found do
      slug '404'
    end
  end

  factory :editable_element_text, class: Locomotive::EditableText do
    slug 'ee-1'
    block 'main'
    hint 'hint'
    content 'Lorem ipsum - foo - <a href="#">bar</a>'
    priority 0
    disabled false
  end

  factory :editable_element_file, class: Locomotive::EditableFile do
    slug 'ee-2'
    block 'main'
    hint 'hint'
    priority 0
    disabled false
  end

  factory :content_type, class: Locomotive::ContentType do

    name 'My articles'
    slug 'articles'
    description 'The list of my articles'
    site { Locomotive::Site.where(handle: 'acme').first || create(:site) }

    after(:build) do |content_type, _|
      related_content_type = create(:related_content_type, site: content_type.site)

      content_type.entries_custom_fields.build label: 'Title', type: 'string'
      content_type.entries_custom_fields.build label: 'Short Description', type: 'text'
      content_type.entries_custom_fields.build label: 'Description', type: 'text'
      content_type.entries_custom_fields.build label: 'Visible ?', type: 'boolean', name: 'visible'
      content_type.entries_custom_fields.build label: 'File', type: 'file'
      content_type.entries_custom_fields.build label: 'Published at', type: 'date'
      content_type.entries_custom_fields.build label: 'Author', type: 'belongs_to', class_name: related_content_type.entries_class_name
      content_type.valid?
      content_type.send(:set_label_field)
    end

    trait :indexed do
      site { create(:site, :algolia) }
    end

  end

  factory :related_content_type, class: Locomotive::ContentType do

    name 'Authors'
    slug 'authors'
    description 'The list of my authors'
    site { Locomotive::Site.where(handle: 'acme').first || create(:site) }

    after(:build) do |content_type, _|
      content_type.entries_custom_fields.build label: 'Name', type: 'string'
      content_type.entries_custom_fields.build label: 'Bio', type: 'text'
      content_type.valid?
      content_type.send(:set_label_field)
    end

    trait :indexed do
      site { create(:site, :algolia) }
    end

  end

  factory :content_entry, class: Locomotive::ContentEntry do

    trait :article_attributes do
      _slug             'my-first-article'
      title             'My first article'
      short_description '<span>Short description here</span>'
      description       "<p>That's <strong>good!</strong> <a href='#'>Click here!</a></p>"
      visible           true
      published_at      Date.parse('2015/09/26')
      author_id         {
        author_type = Locomotive::ContentType.where(slug: 'authors').first
        author = author_type.entries.create(attributes_for(:content_entry, :author_attributes))
        author._id
      }
    end

    trait :with_file do
      file File.open(File.join(File.dirname(__FILE__), '..', 'fixtures', 'apple.png'))
    end

    trait :author_attributes do
      _slug 'john'
      name  'John Doe'
      bio   'Born in 1979'
    end

  end

end
