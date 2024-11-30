# Green Quest API

The Green Quest API is the backend for Green Quest. The bulk of it's business
logic consists of generating many relational records based on the data returned
from the [IGDB API](https://api-docs.igdb.com/?ruby#getting-started).

## Installation

First you'll need to install the Ruby version listed in the `.ruby-version`
file, and I recommend using [rbenv](https://github.com/rbenv/rbenv). You'll also
need the Node version listed in the .node-version file and you can install it
using [nvm](https://github.com/nvm-sh/nvm).

Once you've installed both Node and Ruby and have ensured you're running the
proper versions of each, you can run the following commands:

```
bundle && npm i
```

Copy the `.env.example` file into your own `.env` file. The `RAILS_MASTER_KEY`
variable is mainly for deployments.

## Usage

To run the app locally, you'll need to install Postgres using
[Homebrew](https://formulae.brew.sh/formula/postgresql@14). Once you've
installed Postgres, run the following command to start Postgres:

```
brew services start postgresql
```

Once Postgres is running, then you can run the app with the following commands:

```
rails db:prepare && rails s
```

## Usage With Docker

First you'll need to install [Docker](https://www.docker.com/). You'll also need
[Docker Compose](https://docs.docker.com/compose/install/). Once both are
installed and Docker is running in the background, you can run the following
command to build and run the app with Docker Compose:

```
docker compose up --build
```

You might need to run migrations from another terminal window once Docker
Compose is running the app:

```
docker compose run web bin/rails db:migrate
```

## Authentication

- Devise: https://github.com/heartcombo/devise
- Devise JWT: https://github.com/waiting-for-dev/devise-jwt

Here is a helpful article that outlines the basics:
https://sdrmike.medium.com/rails-7-api-only-app-with-devise-and-jwt-for-authentication-1397211fb97c

This app doesn't deviate too much from that pattern. You'll need to install
[Mailcatcher](https://mailcatcher.me/) to test any outgoing mail from Devise.
There's a comment on line 59 of the `config/environments/development.rb` file
explaining how to switch to mailcatcher when using Docker.

## System dependencies

- [Prettier Plugin Ruby](https://github.com/prettier/plugin-ruby): Must open the
  project with `code .` from terminal for VSCode Ruby Prettier to work as
  expected. This is a known problem with the library at the moment and there isn't
  a better workaround.
- [Pundit](https://github.com/varvet/pundit) handles authorization for each
  endpoint that requires it.
- [Bullet Warnings](https://github.com/flyerhzm/bullet) is installed to help
  avoid N+1 queries.
- [JSON Matchers](https://github.com/thoughtbot/json_matchers) is the library
  used to ensure the API always sending the JSON payloads the frontend expects.
- JSON is camelCased and rendered using
  [Jbuilder](https://github.com/rails/jbuilder).

## JSON Schemas

JSON schemas for every endpoint can be found within `test/support/api/schemas/`.

## Testing

This app uses [Minitest](https://github.com/minitest/minitest) for all unit
tests. To run the test suite run the following command:

```
rails test
```

### Test Helpers

Most models have a matching `support/model_name_create_test_helper.rb` file that
gets imported in the `GameCreateTestHelper` module and used in any other tests
related to the model to stub IGDB successes or failures. There are several
methods defined in the `GameCreateTestHelper` from before the test helper
modules pattern was introduced.

## Spellcheck

Spellcheck is part of the CI pipeline and there is a script to run it locally to
check your work before pushing:

```
npm run spellcheck
```

## Deployments

The app is automatically deployed via [Railway](https://railway.app/) when a PR
is merged to the `main` branch.

## Facade Run-through

There are several facade patterns in place to support fetching data for one
game, and populating said game with many different kinds of relationships when a
POST request is made to /games.

### TwitchOauthFacade

This facade is used during the initial Game creation to fetch a bearer token
needed for making requests to the IGDB API.

### IGDB Facades

There are several patterns based specifically around the IGDB API.

#### IgdbCreateFacade

This is a generic facade that is used for a lot of the basic relationships that
get added to a game like Genres or Themes. It takes a fields facade that should
match the given model, and a set of ids that usually come from the game itself
during the game creation. This facade also ensures any errors from any requests
are returned in a hash.

#### Custom Create Facades

Some relationships like `InvolvedCompanies` require their own create facade to
perform deeper tasks like first finding or creating a `Company` before adding it
to the `involved_companies` table. These facades typically work similarly to the
`IgdbCreateFacade` in most ways with specifics for the tasks at hand. They also
ensure that errors from any dependents of the record being generated are
returned in a hash. Example: a Platform has PlatformLogos and generates them
during the game create request. Any PlatformLogo request could return an error
or success just like the Platform. Both errors will be returned in the hash.

#### IgdbRequestFacade

This facade is used to make requests for any endpoint offered by IGDB after the
game has made the initial request to the Twitch Oauth endpoint to request a
token. The token is then passed into this facade in many different parent
facades like the `Api::PlatformsCreateFacade` or the `IgdbCreateFacade`.

#### IgdbApiFacade

This facade is mostly used by the `IgdbRequestFacade`. The game request facade
still uses it, but this one could probably be replaced by the generic facade
too.

#### Fields Facades

Most models have a matching `IgdbFieldsFacade` that is used to populate the
fields of the generated record using the fetched data from IGDB for each record.

## Game Facades

Within the `app/facades/api/games/` directory there are matching
`model_game_create_facade.rb` files for most models. These either call an
`IgdbCreateFacade` or a custom facade for a given model. They're responsible for
not only creating game related records, but also ensuring that any and all
errors from any generated records are passed into the `@game.errors` array
prompting the controller to return a 207 response.
