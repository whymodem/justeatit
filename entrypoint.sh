#!/bin/bash
# Docker entrypoint script.
set -e

# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

echo "$(date) - running app ecto setup"

/app/bin/just_eat_it eval "JustEatIt.Release.setup()"

# if you want to run the steps manually, uncomment /app/bin/ callsand do the following below
# be sure to commend the call to setup above as well
# we could use && and make this a bit more robust, but this will do for now
# mix is not available in a release, so we must use our release module to do mix-like tasks
# create the database
#/app/bin/just_eat_it eval "JustEatIt.Release.create_app_db()"
# run migrations
#/app/bin/just_eat_it eval "JustEatIt.Release.migrate()"
# run seeds
#/app/bin/just_eat_it eval "JustEatIt.Release.seed()"
# run sever

echo "$(date) - starting app server..."

/app/bin/server
