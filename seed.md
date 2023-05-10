# Seeding Data

Seed data is often useful both for testing and properly launching an application into production. Users for instance do not want to be greeted typically by an empty application. As another example, it is every common for existing data to be imported or otherwise connected to an application.

Consequently, this application uses open data to seed the database with some food truck information. Per requirements, this data must come from San Francisco's food truck open dataset.

As such, data was obtained by using the following command:

```bash
curl "https://data.sfgov.org/resource/rqzj-sfat.json" -o foodtrucks.json
```

This data was then transformed accordingly for use in the application.

There is also a CSV version available, however CSV notoriously can have escaping and other issues. As such, we elected to use the JSON version that was readily provided for a smoother import process, though there is little heavy lifting required for either. It should be noted that it is possible to trim this data other ways and hit other end-points, but it was elected not to do so in case this violates any requirements.

See the following URLs:


In summary, the primary reasoning for seeding the data the way that it was done here are as follows:

* Ensure that someone opening the application for the first time has data
* Make it easy to produce reproducible tests, which always benefit from real data, though fakers can also be useful still
* Prevent a situation where the application cannot be seeded and deployed because of an external service/call
    * This is similar to the idea of downloading and pinning dependencies in advance so that something like github downtime does not take down your service.
    * We want to avoid hitting an endpoint more than we need to as a good netizen
* Simplify deployment so there are less moving parts like additional web requests
* Seeding in this way integrates well within Elixir, Phoenix, and Ecto, the primary backend technologies
    * Seeding can be done via command line
    * Seeding has a predictable and familiar structure to someone new looking at the code with reasonable knowledge of the ecosystem
