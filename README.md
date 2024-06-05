# README

Problem statement can be found [here](https://gist.github.com/dillonwelch/51a59f1b9a68c2c45423f21427f68346).

## Requirements

* Ruby 3.2.2
* Postgres

## Setup

* Create a file called `.env` and add an entry for `BASE_API_URL=YOUR_URL` (see problem statement for this URL)
* `bundle install`
* `bundle exec rails db:create db:migrate`
* `bundle exec rails s`
* Navigate to `http://localhost:3000/`
* Enjoy your videos.
* If you want to fetch fresh results from the API, add `?cache_bust=true` to your URL.

And to run tests:
* `bundle exec rails test && bundle exec rails test:system`

And to check for style errors:
* `bundle exec rubocop`

## Code Documentation

The application is documented using the [YARD](https://yardoc.org/index.html) standard. Documentation can be generated
via the [yard](https://github.com/lsegal/yard) gem. IDEs like RubyMine with YARD support should natively pick it up.

## Coding Notes

I set up caching via the built-in memory caching to keep the installation light for submission. In a real production
environment, I would setup Redis for my cache store. Similarly, I used sqlite3 for the database but would use something 
like Postgres in production.

Rubocop was used to keep the code clean, consistent, and free of obvious performance issues and security flaws.

VCR + webmock were used to make sure that the test suite did not directly make HTTP calls. This allows for the tests
to use consistent responses for consistent results, and also removes the APs being available as a dependency for
running the test suite.

## Scalability 

I wanted to have all of the video data accessible within the application, both to be able to validate videos existed
and to prevent duplicate API calls when navigating through the application. However, the video data is fetched in one 
big loop when there is a cache miss. This would not be a scalable approach for an API with many results. Instead, we
would want to make use of more fine grained API endpoints to be able to search by name or video ID.

## Implementing the Bonus Ideas

For pagination, I would use the [kaminari](https://github.com/kaminari/kaminari) gem. The results from VideoService.get
could be easily paginated as it's just an array, so approaches like `VideoService.get[20..39]` could be used.

For title search, I would add a search field in the middle of my header bar. I would update VideoService to have a 
method that takes in a `title` argument and returns all the videos that match against the title. 

## Additional Ideas
There are probably gems and configuration files that come default with Rails that could be removed.

In `config/application.rb`, we could remove `require 'rails/all'` and only include the pieces we need (we don't need
ActionCable, for instance) to reduce the memory footprint and boot time.

I would want to setup a CI/CD pipeline using Github Actions or similar to automatically run the test suite and deploy
the application.

Do some thorough QA bashing on the drag and drop functionality and ensure functionality on mobile.

Make the design of the playlist entries more pleasing.

Ask a designer for input on potentially more aesthetically pleasing color combinations. 

Run the app through a [WCAG](https://wave.webaim.org/) analyzer. 

Fix the TODO issue in my system tests.

Add a notification for when a video is added to a playlist (was having trouble and ran out of time).

Add a footer of some kind.
