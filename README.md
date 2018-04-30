# Locomotive Search

Locomotive Search is an add-on for Locomotive Engine enhancing it by indexing the content of any site.

For now, only [Algolia](https://www.algolia.com) is supported.

## Installation

Add this line to your Rails app's Gemfile powering Locomotive Engine.

```ruby
gem 'locomotivecms_search'
```

And then execute:
```bash
$ bundle
```

Open your `config/application.rb` file of your Rails app and assign a backend like this:

```ruby
class MyApplication < Rails::Application
  ...
  config.x.locomotive_search_backend = :algolia
  ...
end
```

For a smooth user experience, any modification to a page or a content entry will trigger asynchronously the indexing of the related content. Behind the scene, we use Rails ActiveJob in order to process it asynchronously. Check out the [ActiveJob documentation](http://guides.rubyonrails.org/active_job_basics.html) to set it up.

However, if you don't mind about the performance (or for testing purpose), you can "disable" ActiveJob by adding `config.active_job.queue_adapter = :inline` to your application.rb file.

## Available backends

### Algolia

Each Locomotive site has to set the credentials required to access the Algolia API. This can be done by adding a new metafield namespace named `algolia` in the Wagon source of the site.

In the `config/metafields_schema.yaml` file, add the following lines:

```yaml
algolia:
  label: Algolia settings
  fields:
    application_id:
      type: string
    api_key:
      type: string
    reset:
      type: boolean
      hint: 'If switched on and after pressed the save button, re-index the content of the site '
```

Then, deploy your site and open the back-office of your Locomotive site. Go to the "Settings" section and fill in the `application_id` and `api_key` fields within the Algolia tab.

If you want to force the re-indexing all of the content of the site, toggle on the `reset` field and save the site. This procedure will start by deleting all the existing Algolia indices.

## How to contribute

Locomotive is an open source project, we encourage contributions. If you have found a bug and want to contribute a fix, or have a new feature you would like to add, follow the steps below to get your patch into the project:

- Install ruby, mongoDB
- Clone the project <code>git clone git@github.com:locomotivecms/search.git</code>
- Start mongodb if it is not already running
- Create an Algolia account
- Set the following env variables based on your Algolia account: `ALGOLIA_APPLICATION_ID` and `ALGOLIA_API_KEY` (or add a new file named .env.test at the root of the project)
- Run the tests <code>bundle exec rspec</code>
- Write your failing tests
- Make the tests pass
- [Create a GitHub pull request](http://help.github.com/send-pull-requests)

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
