# Mirah Ruby Integration Library

This gem provides convenience methods to allow EHRs and other systems of record to access and update a variety of Mirah endpoints. It is intended for use in the following circumstances

## Getting Started

This gem is intended for use for existing Mirah customers only. To get started, ask your account representative for a technical contact, who will provide you with the following for both staging and production:

 - An `API_USER_ID` which is your unique user. This is provided at the system level and does not correspond to an individual.
 - An `API_KEY` as a secret key.
 - An `API_HOST` which is the URL of the API.

There are different endpoints for production and staging. They will be configured below as part of installation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mirah-ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install mirah-ruby

Configure your environments so that you use the correct credentials for each environment. For example, in rails you can edit `db/secrets.yml`:

    production:
      mirah_api_host: <%= ENV["MIRAH_API_HOST"] %>
      mirah_api_user_id: <%= ENV["MIRAH_API_USER_ID"] %>
      mirah_api_token: <%= ENV["MIRAH_API_KEY"] %>

Finally, ensure `MIRAH_API_HOST`, `MIRAH_API_USER_ID` and `MIRAH_API_KEY` are present in environment variables to be used.

## Supported Ruby Versions

This library supports the following Ruby implementations:

 * Ruby 2.4
 * Ruby 2.5
 * Ruby 2.6
 * Ruby 2.7

## Usage

To begin, let's instantiate our client:

    # Or otherwise provided by your secrets. Do not store these credentials in source code.
    host = Rails.application.secrets.mirah_api_host
    user_id = Rails.application.secrets.mirah_api_user_id
    token = Rails.application.secrets.mirah_api_key
    client = Mirah::Client.new(host: host, user_id: user_id, access_token: token) # => #<Mirah::Client:0x00007fdf9d698d70....>

There are three kinds of end points in this library:

 * 'Push' methods for sending new or updated data to Mirah - e.g. 'push_patient'.
 * 'Find' methods for single items
 * 'Query' methods for multiple items - e.g. `query_patients`. These can support filters and will paginate.

Let's start by creating a new patient:

    result = client.push_patient(external_id: 'mrn001', given_name: 'Henry', family_name: 'Jones', birth_date: Date.parse('1983-03-20')) # => #<Mirah::PushResult:... @given_name="Henry", @family_name="Jones", @birth_date=#<Date: 1983-03-20>

You should get an object with the newly created patient:

    result.status # => "CREATED"
    result.result # => #<Mirah::Data::Patient ... @given_name="Henry", @family_name="Jones" ... >

If you send the same message back, you'll notice the status is 'UPDATED'.

    result = client.push_patient(external_id: 'mrn001', given_name: 'Henry', family_name: 'Jones', birth_date: Date.parse('1983-03-20')) # => #<Mirah::PushResult:... @given_name="Henry", @family_name="Jones", @birth_date=#<Date: 1983-03-20>
    result.status # => "UPDATED"

You can even do a partial update:

    partial = client.push_patient(external_id: 'mrn001', phone_number: '555-555-5555') # => #<Mirah::PushResult:... @given_name="Henry", @family_name="Jones", @birth_date=#<Date: 1983-03-20>

Now let's move onto querying.

    patient_collection = client.query_patients #  => #<Mirah::Collection:0x00007fc4b8943480 @results=[...] >

You can read more about each below, but for now, we can examine the first page of the patient results:

    patient_collection.results.length # => 10
    patient_collection.results.first # => #<Mirah::Data::Patient:0x00007fc4b6aa2850 @id="3046af39-0560-4add-9881-2e004ecdb042", @given_name="Test", @family_name="Patient", @birth_date=#<Date: 1991-01-01)>>

Let's pluck out the first result's id, and then fetch the data directly:

    patient_id = patient_collection.results.first.id # => "3046af39-0560-4add-9881-2e004ecdb042"
    patient = client.find_patient(patient_id) # => #<Mirah::Data::Patient ....>

You may also fetch directly by your own identifier:

    my_patient = client.find_patient_by_external_id('mrn0001') # => #<Mirah::Data::Patient ....>

If you want to find more than one record at a time, you may do so by specifying a filter as part of a normal patient query:

    matching_patients = client.query_patients(external_ids: ['mrn0001', 'mrn0002']) # => #<Mirah::Collection:0x00007fc4b8943480 @results=[...] >

To see the full documentation, see documentation for {Mirah::Client}


### Find methods

 - e.g. {Mirah::Client#find_patient}, {Mirah::Client#find_patient_by_external_id}. These are used to get a single record and do not support pagination or filtering. You must know the identifier (either Mirah or your own) of the record in order to access it.


## Use of identifiers

This API mixes resources where it is likely that users are the system of record (e.g. Patient information), with records where Mirah is the originator (e.g. assessment records). All items in this API contain an `id` field, which corresponds to the Mirah internal identifier.

Some classes also contain an extra `identifiers` field that describes the rest of the identifiers that Mirah knows about. This includes:

 - An `assigner` which corresponds to which system assigned the identifier. In most circumstances where you are the only system of record, this will be `default`.
 - A `value` which is the actual record identifier.

## Error Handling

All errors raised will be a subclass of {Mirah::Error}. You can rescue from these as follows to maintain safe code:

    begin
      client.query_patients
    rescue Mirah::Error => e
      # 
    end

The expected kinds of errors will vary on the basis of whether you are using query methods or updating data. Unexpected errors - connectivity, etc, will be raised as a {Mirah::Errors::ClientError}.

### Query methods

The most common errors will come from supply invalid data to queries. For example, {Mirah::Filters::AppointmentFilters} allows you to supply a `status` variable which needs to be of the correct type.

    client.query_appointments(status: 'INVALID') # => Mirah::Errors::ServerError: Unknown error from Mirah server: Variable $status of type [AppointmentStatus!] was provided invalid value for 0 (Expected "INVALID" to be one of: PROPOSED, PENDING, BOOKED, ARRIVED, FULFILLED, CANCELED, NOSHOW)

### Push methods

Push methods wrap their errors into an error type. You should always inspect the result for success:

    result = client.push_appointment(external_id: 'mynewappointment', status: 'NOTVALIDSTATUS', external_patient_id: 'doesnotexist')
    if result.status == 'ERROR'
      result.errors.map { |e| e['message'] } # ["Variable $input of type CreateOrUpdateAppointmentInput! was provided invalid value for status (Expected \"BOOKEDS\" to be one of: PROPOSED, PENDING, BOOKED, ARRIVED, FULFILLED, CANCELED, NOSHOW)"]
    else
      # SUCCESS
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Documentation

To run the documentation server locally:

    bundle exec yard server --reload

## Testing

To run the test suite:

    bundle exec rake spec

We use VCR to supply real API responses during internal testing. To set this up in `mirah_server`, you may run a convenience task to make a specially configured site with exactly the same data:

    bundle exec rake integration:create_gem_institute # in mirah_server

By default, any requests from the API which cause a request which has not been recorded will cause an error. To enable fetching of real request data, you must supply environment variables:

    VCR_HOST=http://localhost:3000 VCR_USER_ID=ABC VCR_TOKEN=XYZ bundle exec rake spec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mirah_tech/mirah-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mirah_tech/mirah-ruby/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mirah_tech/mirah-ruby/blob/master/CODE_OF_CONDUCT.md).
