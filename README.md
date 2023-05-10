# Just Eat It

Just Eat it is an application for solving the simple question, "What should we eat?" In the age of opinions, fellow humans (for now), and AI, Just Eat It preps you for a future where machines will decide or if you are quite lucky, advise you where to eat. No longer shall you struggle with making informed, rational, or purposeful choices.

Just Eat It works by creating a database of food options and picking one for you, without regard (currently) for your meager, irrelevant preferences. It also provides an API with the ability to create, read, update, and delete the currently available food data.

Fear not, the randomizer can also be tamed if you like, making it easier to share or perhaps rig random food choices when using it with your friends. This fabulous functionality is achieved via the optional use of random seeds. You can use a seed as a convenient way of sharing a randomly chosen place to eat and to predictably generate further choices. Seeds also work with the API via the `/api/v1/food_facilities/random` URI.

See below for more information about both the API and seeds.

The future intention is that evolve into a meal planner, platform to save/share choices, and more including in-app map integrations with distance and other filtering.

# Getting Started

Deploy the app and a Postgres server to host the data. Once you do that, you can browse to the index and play around.

Browse to your server, replacing the server name and port accordingly - http://localhost:4000. Press "Let's Eat Something Else" to get new random data. 

By default, a random seed is used each time that is generated by the chosen random algorithm. You can instead provide your own seed. For now, this is done via the URL by adding the `seed` parameter to the query string. This facilitates easy sharing of randomly generated data. You can also control the amount of results returned via the `count` parameter.

Browsing to http://localhost:4000/?seed=cheese

![Just Eat It Cheese As Seed](docs/assets/cheese-seed.jpg)


Changing the count to 5 via http://localhost:4000/?seed=cheese&count=5

![Just Eat It Cheese As Seed](docs/assets/cheese-seed-count.jpg)


As you can see, increasing the count produces different results, however because the same seed is used, the sequence of data generated is the constant, even if you reload. In other words, if you generated 12 results, the first 5 would be the same as above, followed by 7 new ones. You can generate as many results as there are locations that fit your current criteria. Fortunately for you, the criteria is currently limited to all active food locations in the SF area.

Note that repeatedly pressing the "Let's Eat Something Else" button will continue to use the same seed. That is, the results will change but the sequence they are generated in is constant. You can therefore start over and re-generate results by reloading. Note that sharing URLs will currently start at the first page of sequence generation, however in the future we will add support to track your progress using the generator to make this more seamless.

See the "Deployment" section for more information about getting the server up and running.

# What's Included?

* Display a random place to eat, accompanied by a boring or sassy phrase
  * Show available data for each location (if available) including: name, address, menu description, and an address linked to its position on a map via lat/long.
  * Provide an optional seed to share/control randomness/reload data
  * Provide an optional count of places to show
* API for managing (create, read, update, delete) food location data
* API for generating random places to eat
* Production deployment conveniences

## Tech stuff

* Full-source for a [Phoenix Framework](https://www.phoenixframework.org/) application using
[Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html).
* Docker and Docker Compose files with build scripts for slightly less painful deployment
* Basic set of tests
* Data stored in a Postgres database
* Transformations for importing SF [San Francisco's food truck open dataset](https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data), including as seeds for a Phoenix production database.
  * Data is only the "active" permit holders, as no one wants to eat at places that no longer exist, generally.
  * The data has been cleaned up in very minor ways and should be easy to expand upon that methodology in the future since it is de-coupled from the app itself and self-contained. 
* Production deployment aids for a [Phoenix Release](https://hexdocs.pm/phoenix/releases.html)

# Goals

Just Eat It is in its early stage and as such, has a very simple set of goals and scope.

The overall goal was to produce something of value in about 2 hours, though a bit more was of course spent documenting it all. As the saying goes, I'm 99% done 1% of it.

## Current Goals

* Purpose
  * Do something interesting with food truck data that can be explained in 1 sentence -show me random places to eat.
  * Only the appearance of randomness
* Data source
  * Must come from [San Francisco's food truck open dataset](https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data), but is not 100% limited to as such in the future.
* Ownership
  * The data locally to establish ownership, predictable performance, availability, etc. As they say, nothing on the internet lasts forever, though it may be partially and incorrectly scraped, copied, or archived.
  * A future goal is to augment the data, which requires at least owning some piece
* Scope
  * Create a simple, limited in-scope example of an [Elixir](https://elixir-lang.org/) web application using the [Phoenix Framework](https://www.phoenixframework.org/).
* Time and Resources
  * Do not do anything that requires 3rd party registrations/payments/soul selling and time for the end-user as much as possible, ex: Google Maps keys, hosting, etc.
  * Minimize runtime reliance on 3rd parties, for instance querying 3rd party live APIs directly (see notes).
* Implement a poor man's skeleton of a [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html) app.  
* Deployment
  * Provide some basic deployment aids.
* Tech
  * Demonstrate basic understanding of REST, Phoenix, etc.
  * Use a database
  * Dabble in some tech that demonstrates understanding of Elixir ecosystem

## Non-Goals

There are many non-goals, but a few that might be of interest to skeptics and shruggers include the following:

* Filtering
  * No distance or other significant filtering is provided as it is out-of-scope given the requirements.
  * Distance checks via Postgres types, Haversine calculations, and more accurate methods was considered but deemed to be out-of-scope for this iteration
* Deployment
  * Comprehensive and generic deployment functionality and aids would be great, but that is a project in itself (ex: fully-fledged mix substitutes for releases).
  * Deploying to services like Fly.io, AWS, etc. requires time and even money from the user
* Business Cases
  * All encompassing food location management
  * Maps - would be great to show a map, but we wanted to minimize moving parts.
  * Worrying about permit data from the SF food truck open data set. It would be interesting to do something with it like show the next great food truck, but the quality and scope of the data did not support most of the interesting uses of permit data without significant more investment in other data sources and time.
* Randomness
  * PCRG is a broad topic, but for this a simple generator is required
  * Only interested in the appearance of randomness
* API
  * Fully featured API
  * Rate limiting - IMO a must for public APIs, but out-of-scope
  * A GraphQL API would be nice but is overkill for a simple use-case. 
  * Adding lots of parameters, pagination, and other functionality
  * Authentication and authorization
    * A must for internet facing apps, but registering for a bunch of APIs keys to other services, dealing Okta, SASL, SAML, certificates, etc. is a bit much for a simple app.
    * Leave it to the user to put things behind a reverse proxy if they care about securing it
* Tests
  * 100% coverage would be great but time is limited, however this is an obvious future goal
  * Integration, smoke testing, etc. would be great, but again time is limited.

# API

A basic RESTful API is provided for working with food facilities. A food facility is simply a place to eat - a food truck, cart, restaurant (future), stand (future), etc. 

The API accepts and returns JSON. 

Currently, the API can be accessed via the relative path of `api/v1/food_facilities`, for example `http://localhost:4000/api/v1/food_facilities`.

The following routes are provided:

| Method 	| Route                       	| Description                  	|
|--------	|-----------------------------	|------------------------------	|
| GET    	| /api/v1/food_facilities/random 	| List random food facilities  	|
| GET    	| /api/v1/food_facilities        	| List food facilities         	|
| GET    	| /api/v1/food_facilities/:id    	| Get a food facility by id    	|
| POST   	| /api/v1/food_facilities        	| Create a new new facility    	|
| PATCH  	| /api/v1/food_facilities/:id    	| Update a food facility       	|
| PUT    	| /api/v1/food_facilities/:id    	| Update a food facility       	|
| DELETE 	| /api/v1/food_facilities/:id    	| Delete a food facility by id 	|

The API currently only returns food facility data with the following fields at most:


      "address": "50 QUINT ST",
      "facility_type": "truck",
      "id": 48,
      "latitude": "37.746470506647114",
      "longitude": "-122.38899080865444",
      "menu_description": "Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks",
      "name": "Natan's Catering"

## API Limitations

### Authentication and Authorization

If you need to secure the API, it is recommended to put a reverse proxy. Both authentication and authorization are in the future plans, but for now, revel in the idea that food wants to be freely shared and perhaps permanently erased, overwritten with better food, or other data. You are warned.

In the future, user information could be used to save and audit data, generate per-user meal plans/food schedules, etc.

### Rate Limiting

There is no rate limiting in place. If you need this, do not expose this to the internet or put it behind a proxy that can manage this for you.

## Random

The random endpoint is intended to generate a random list of 1 or more places to eat. The amount of items picked and how they are generated can be controlled. This way, you can give yourself and perhaps, if lucky, friends the option to debate if you don't want a single choice.

The result of the food facilities `api/v1/food/food_facilities/random` will be randomly generated by default. 

Example:

```bash
$ curl -X GET "http://localhost:4000/api/v1/food_facilities/random"
```

``` json
{
  "data": [
    {
      "address": "50 QUINT ST",
      "facility_type": "truck",
      "id": 48,
      "latitude": "37.746470506647114",
      "longitude": "-122.38899080865444",
      "menu_description": "Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks",
      "name": "Natan's Catering"
    },
    {
      "address": "Assessors Block 4103/Lot023A",
      "facility_type": "truck",
      "id": 59,
      "latitude": "37.758303395642486",
      "longitude": "-122.39351405481675",
      "menu_description": "Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks",
      "name": "Natan's Catering"
    },
    {
      "address": "401 CALIFORNIA ST",
      "facility_type": "truck",
      "id": 87,
      "latitude": "37.79279574157871",
      "longitude": "-122.40135328093122",
      "menu_description": "Hot coffee, iced coffee, hot chocolate, tea, pastries",
      "name": "Philz Coffee Truck"
    },
    {
      "address": "233 GEARY ST",
      "facility_type": "push_cart",
      "id": 115,
      "latitude": "37.787242602596706",
      "longitude": "-122.40687973821338",
      "menu_description": "Hot dogs, condiments, soft pretzels, soft drinks, coffee, cold beverages, pastries, bakery goods, cookies, ice cream, candy, soups, churros, chestnuts, nuts, fresh fruit, fruit juices, desserts, potato chips and popcorn.",
      "name": "San Francisco Carts & Concessions, Inc. DBA Stanley's Steamers Hot Dogs"
    },
    {
      "address": "66 POTRERO AVE",
      "facility_type": "truck",
      "id": 27,
      "latitude": "37.76854328902419",
      "longitude": "-122.40849289243862",
      "menu_description": "Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks",
      "name": "Natan's Catering"
    }
  ]
}
```

A repeated call will typically yield completely different results:

```bash
$ curl -X GET "http://localhost:4000/api/v1/food_facilities/random"
```

```json
{
  "data": [
    {
      "address": "1580 BURKE AVE",
      "facility_type": "truck",
      "id": 52,
      "latitude": "37.74475219161639",
      "longitude": "-122.38567924872147",
      "menu_description": "Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks",
      "name": "Natan's Catering"
    },
    ...snip
  ]
}
```

You can also control the amount of items returned by adding the `count` parameter to the GET request:

```bash
$ curl -X GET "http://localhost:4000/api/v1/food_facilities/random?count=2"
```

```json
{
  "data": [
    {
      "address": "401 23RD ST",
      "facility_type": "truck",
      "id": 2,
      "latitude": "37.755030726766726",
      "longitude": "-122.38453073422282",
      "menu_description": "Cold Truck, Breakfast, Sandwiches, Salads, Pre-Packaged Snacks, Beverages",
      "name": "BH & MT LLC"
    },
    {
      "address": "60 SPEAR ST",
      "facility_type": "truck",
      "id": 96,
      "latitude": "37.792535988431084",
      "longitude": "-122.39459319923499",
      "menu_description": "Mexican; Burritos, Burrito Bowls, Salads",
      "name": "Papalote Inc."
    }
  ]
}
```
## Create

Create a food location:

```bash
curl localhost:4000/api/v1/food_facilities -X POST \
-H "Content-Type: application/json" \
-d '{"food_facility":{"name":"My Little Trucky", "facility_type":"truck", "menu_description": "Wild amounts of salads", "address": "123 Green Ln", "latitude":"37.78991386713444", "longitude":"-122.40523289252366"}}'
```

```json
{"data":{"address":"123 Green Ln","facility_type":"truck","id":157,"latitude":"37.78991386713444","longitude":"-122.40523289252366","menu_description":"Wild amounts of salads","name":"My Little Trucky"}}
```

## Get a Food Location

```bash
curl -X GET "http://localhost:4000/api/v1/food_facilities/39"
```

```json
{"data":{"address":"Assessors Block 4241/Lot002","facility_type":"truck","id":39,"latitude":"37.75334000118106","longitude":"-122.38412838423727","menu_description":"Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks","name":"Natan's Catering"}}
```

## List all Food Locations

```bash
curl -X GET "http://localhost:4000/api/v1/food_facilities/"
```

## Update a Food Location

Assuming an existing food location with id of 159, this will update its name field:

```bash
curl localhost:4000/api/v1/food_facilities/159 -X PUT \
-H "Content-Type: application/json" \
-d '{"food_facility":{"name":"My Slightly More Verbose Trucky"}}'
```

```json
{"data":{"address":"123 Green Ln","facility_type":"truck","id":159,"latitude":"37.78991386713444","longitude":"-122.40523289252366","menu_description":"Wild amounts of salads","name":"My Slightly More Verbose Trucky"}}
```

# Seeds

What are seeds? In simple terms, seeds help us control how to initialize random number generation. In simple terms, it lets us add predictability to randomness.

At first, controlling randomness seems counter-intuitive. Seeds in fact help us create a better user experience when working with randomness.

The benefits of seeds in Just Eat It are as follows:

* Shareable
  * Share a URL with your randomly generated results and have it load the correct data without storing it at all.
  * Cheat your friends and rig the choice
* Storage and memory
  * Per above, prevent wasteful use of disk space and memory
* Maintainability and Debugging
  * Easier testing and traceability
  * Without seeds, if something goes wrong with random generation, it can be very hard to figure out what happened and why
* Fun to try new seeds

Note: Your results may be different between servers as seeding info will depend on your actual data stored.

*We refer to seeding data elsewhere, which means simply initial data, not to be confused.*

## Randomness in Elixir

The careful naysayer might ask, why didn't you use a stronger PRNG? The answer is simply we do not need one. One thing of note that is often brought up in this conversation is people espousing the use of the `:crypto` module in Erlang. While this can be useful, since the introduction of many changes such as better statistical distributions to the `:rand` module, this has become less useful. The `:crypto` module is more useful in the context of security, and in parts, can be dependent on things like OpenSSL which has its own set of issues.

Simply put, using the `:rand` module is more appropriate. If we truly wanted a better implementation, using a NIF that called a battle-tested lib like http://www.pcg-random.org/ might be a better option.

You may take your tacos seriously, but `:rand` is good enough for picking a food truck for now.

Lastly, the careful eye might notice that we would be perhaps better passing seed values to Postgres using either the "between IDs" method or by using sampling. While these approaches are valid, we wanted to keep things simpler and not have to rely on more complex Ecto queries. In the future, perhaps this would be an improvement so we can select rows randomly. We do randomization in-memory to support in-memory sources easily and to make it easier to do very complex future randomization checks. Finally, we wanted to demonstrate something in Elixir rather than postgres. 

Make it work, make it work better is our philosophy, and we are keenly aware of alternatives, is the gist. Time and simplicity were the priorities in this project.

# Deployment
## Requirements

* Elixir 1.14.0+ (tested on 1.14.0)
* Postgres SQL 15+ (tested on 15.2)
* Docker Compose (optional)
## Docker

Docker files are provided for use with Docker compose, see `docker-compose.yml` and `DockerFile`. An entry point script is required for Docker to properly setup the application server, which can be found in `entrypoint.sh`.

You will need to create a `docker.env` files or otherwise modify the docker scripts to provide the appropriate env files. A sample file is provided, however you will need to replace the values with ones appropriate to your environment, namely the postgres credentials and Phoenix app secret key.

## Docker Compose Basics

The most important steps are to setup your environment variables in docker.env. You will need to generate a secret key for the app to use and include it with your environment variables.

An example docker deployment from this repo is as follows:

```bash
# clone this repo
git clone https://github.com/whymodem/justeatit

# enter the project directory
cd justeatit

# create a new docker.env file, edit it accordingly
cp docker.env.example docker.env

mix deps.get --only prod

# paste this value into docker.env under the SECRET_KEY_BASE value or pipe + edit using sed
MIX_ENV=prod mix phx.gen.secret

# also ensure you set your database URL accordingly if desired in docker.env
# edit docker.env per your environment, pasting in the above secret long key generated

# finally run docker compose, recommended to use -d for detached mode
docker compose up
```

Your DATABASE_URL should look similar to the following, adjusting for your environment:

`DATABASE_URL=ecto://postgres:postgres@db/just_eat_it`

Running `docker-compose up` will start the app sever with defaults once you have edited your `docker.env` file accordingly and an instance of Postgres.

Once both the database server and app server start, you can now visit [`localhost:4000`](http://localhost:4000) from your browser.

Ensure you keep all these values securely, they are meant to prevent the app, docker, and other moving parts from having to hard-code this information.

## Docker Compose Environment Variables

The following environment variables need to be defined for the app deployment to function properly, but will vary depending on your existing infrastructure and environment:

| Variable          	| Description                                                       	| Example                                                            	|
|-------------------	|-------------------------------------------------------------------	|--------------------------------------------------------------------	|
| SECRET_KEY_BASE   	| Generate using `MIX_ENV=PROD mix phx.gen.secret`                  	| `VbVMDYf/vXL3dnT0Tz` 	|
| DATABASE_HOST     	| Depends on your docker environment                                	| `db`, the name in our docker compose file                          	|
| DATABASE_URL      	| Used by Phoenix and Ecto to connect to your Postgres instance     	| `ecto://postgres:postgres@db/just_eat_it`                          	|
| PGUSER            	| Postgres user                                                     	| `postgres`                                                         	|
| PGPORT            	| Postgres port                                                     	| `5432`                                                             	|
| PGHOST            	| Postgres host name                                                	| `db`                                                               	|
| PGDATABASE        	| Name of the database that is created                              	| `just_eat_it`                                                      	|
| HOSTNAME          	| HOSTNAME for use by our app, for example to check request origins 	| `localhost`                                                        	|
| POSTGRES_PASSWORD 	| Postgres password for our provided user                           	| `postgres`                                                         	|

## Manual

To deploy your app locally for production:

  * Ensure you have an instance of Postgres running.
  * Ensure you have set the `DATABASE_URL` environment variable per your Postgres credentials.
  * Run `mix deps.get --only prod` to get your production dependencies.
  * Run `MIX_ENV=prod mix phx.gen.secret` to generate your `SECRET_KEY_BASE` environment variable and set it accordingly.
  * Run `MIX_ENV=prod mix assets.deploy` to deploy all your assets like scripts and images.
  * Run `MIX_ENV=prod mix setup` to setup the database, run migrations, and seed it with values.
  * Start Phoenix endpoint with `PORT=4000 MIX_ENV=prod mix phx.server` on a given port number.

Example shell session:

```bash
# get our deps
$ mix deps.get --only prod

# generate an app secret, do not share with anyone
$ MIX_ENV=prod mix phx.gen.secret
REALLY_LONG_SECRET
# paste the above into the SECRET_KEY_BASE environment variable below
$ export SECRET_KEY_BASE=REALLY_LONG_SECRET
$ export DATABASE_URL=ecto://postgres:postgres@localhost/just_eat_it

$ MIX_ENV=prod mix assets.deploy

$ MIX_ENV=prod mix setup

# launch the server on the specified port
$ PORT=4000 MIX_ENV=prod mix phx.server
```

# Assumptions

* Assume the app is deployed internally, can be put behind a reverse proxy with security, or otherwise limited in its time on the internet.
* The user does not want to continually refresh the seeded SF data in the background
* User deploying the app is at least remotely familiar with Phoenix, Elixir, and/or Docker
* We aren't feature complete

# Other Concerns

Generally, for this initial release, we aimed to keep things as minimal as possible while still being novel. For instance, we could add more parameters to enhance the seed features such as storing the position in the sequence, but the goal was simplicity and completeness over features per the brief.

Further, we did not want to depend on 3rd party libs, APIs, extensions, or other moving parts as much as possible for the Geo elements that would be valuable going forward. For instance, a quick scan of some Elixir geo libraries and Ecto add-ons reveals many are unmaintained or have critical issues that could have cost us time. We therefore elected caution for this simple release given constraints of two hours.

The major changes going forward we would make are:

* Use Elixir Geo/GIS libraries after extensive testing
  * Geocoding, Geo types, Ecto support for Postgres
    * Concerning issues in the ecto support libs
  * Google Maps
* Google Maps w/ LiveView
  * Prototyped this briefly, but elected to remove for one less moving part
  * Did not want to bother with API key, limits, etc. interfering with an MVP
* Postgres GIS extensions
  * If support is not required/desired for other databases like SQLite
* Expanded use of live view features like refreshing random data at intervals on a map

# Future

The following functionality is proposed but not binding for a possible roadmap:

* Automated way to refresh SF Mobile Food Location Permits data in the background
  * For now, the data is a snapshot, intentionally so that the app can be demo'd easily
* Authentication
* Authorization
* API rate limiting
* Overflow handling via circuit breakers, load shedding, etc.
* Vendor management
  * Food trucks often have the same name but are actually owned by the same person
  * Vendor functionality would allow better tracking of who owns what and would allow limiting random generation to control aspects of how many and how many consecutive locations are returned from the same vendor
* Food schedule/Meal plan generation
* Google Maps integration
* Increased tests and test coverage
* Geo Querying
  * Distance filtering (ex: via Postgres extensions)
  * Limit the number of results to a specific distance from a provided location
* Auto-generated and interactive API docs
  * Open API Spex implementation
* More Elixir Doc tests
* Project Organization
  * Decide on a better hierarchy and folder structure as the amount of files grows.
* GeoCode and lookup information from Google Maps and other sources from lat/long or address
  * Current seeded data has addresses that are incomplete due to lack of geocoding lat/long.
* Storage and types
  * Use GIS extension and libraries for proper storage, filtering, search, etc. of lat/long w/ srid
 * Stabilize seeds more as data changes by storing extra info about size, options, etc.