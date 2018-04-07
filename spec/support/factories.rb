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

end
