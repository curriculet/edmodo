# Edmodo
A ruby wrapper for the edmodo API.
The current version only covers the most commonly used calls: users, groups, members and launchRequest.
We are working on other calls. Feel free to send me your contribution pull-requests

## Installation

Add this line to your application's Gemfile:

    gem 'edmodo'

And then execute:

    $ bundle install

## Usage

Configure Edmodo to use your Edmodo App API key:

    Edmodo.configure do |config|
           c.api_key     = <MY-API-KEY>
           c.api_version = 'v1.1'
           c.endpoint    = 'https://appsapi.edmodobox.com'
           c.timeout     = '10' #seconds
           c.testing     = true
    end


Use Edmodo in your ruby app:
```
    # Get all group members
    launch_as_user = Edmodo.users.find_by_launch_key( freshly_received_launch_key )

    # Launch your application
    group_members  = Edmodo.users.find_all_by_group_ids( [ id1, id2, id3 ], <YOUR-ACCESS-TOKEN> )
```
## Documentation

http://rdoc.info/github/alvarezm50/edmodo/master/frames


## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
