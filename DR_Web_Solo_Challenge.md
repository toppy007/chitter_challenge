# My web application design recipe

## Project setup

```bash
rvm get stable
rvm use ruby --latest --install --default
gem install bundler
bundle init
bundle add rspec
rspec --init
mkdir lib

# Add the sinatra library, the webrick gem, and rack-test
bundle add sinatra sinatra-contrib webrick rack-test

# Create the main application file
touch app.rb

# Create the app_spec.rb integration tests file
mkdir spec/integration
touch spec/integration/app_spec.rb

# Create the config.ru file
touch config.ru
```

## Setup app.rb file.

```ruby
require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end
end
```

## Setup config.ru

```ru
# file: config.ru
require './app'
run Application
```

## Starting the server.

```bash rackup ```

viewable in the web browser at the following address ```bash http://localhost:9292 ```

## Sinatra application

Here is an example of a minimal Sinatra application, configuring a single route:

```ruby
# file: app.rb
require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  # Declares a route that responds to a request with:
  #  - a GET method
  #  - the path /
  get '/' do
    # The code here is executed when a request is received and we need to 
    # send a response. 

    # We can return a string which will be used as the response content.
    # Unless specified, the response status code will be 200 (OK).
    return 'Some response data'
  end
end
```
## "route" or "route block".

The Ruby block between the do and end associated with a method and path is called a "route" or "route block". The code in this block is executed only is the received request matches the method and path.

```ruby
# Let's look at an example where Flask receives this request:
# GET /

# There are a number of routes. We'll look through each one in turn and see if
# it matches.

class Application < Sinatra::Base 
  # ...

  post '/' do
    # This route is not executed (the method doesn't match).
  end

  get '/hello' do
    # This route is not executed (the path doesn't match).    
  end

  get '/' do
    # This route matches! The code inside the block will be executed now.
  end

  get '/' do
    # This route matches too, but will not be executed.
    # Only the first one matching (above) is.
  end
end
```

## Demo GET & POST request

```ruby

# http://localhost:9292/hello?name=chris

  get '/hello' do
    name = params[:name] # The value is 'David'
  
    # Do something with `name`...
    return "Hello #{name}"
  end

# http://localhost:9292/submit

  post '/submit' do
    name = params[:name] # The value is 'David'
    message = params[:message]
    # Do something with `name`...
    return "Hello #{name} you just sent the message #{message}"
  end
```

## RSpec writen exaples

-- Request:

GET /names?name=Chris

-- Expected response:

Response for 404 Not Found
body = Hello Chris

## Test-Drive a GET & POST request.

We can create integration tests for our routes using RSpec. Here's an example:

```ruby
# file: spec/integration/application_spec.rb

require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET to /" do
    it "returns 200 OK with the right content" do
      # Send a GET request to /
      # and returns a response object we can test.
      response = get("/")

      # Assert the response status code and body.
      expect(response.status).to eq(200)
      expect(response.body).to eq("Some response data")
    end
  end

  context "POST to /submit" do
    it "returns 200 OK with the right content" do
      # Send a POST request to /submit
      # with some body parameters
      # and returns a response object we can test.
      response = post("/submit", name: "Dana", some_other_param: 12)

      # Assert the response status code and body.
      expect(response.status).to eq(200)
      expect(response.body).to eq("Hello Dana")
    end
  end
end
```