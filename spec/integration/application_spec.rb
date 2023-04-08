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
        it 'contains a h1 title' do
            response = get('/')
        
            expect(response.body).to include('<h1 style="font-family:helvetica">Welcome to Chitter</h1>')
            expect(response.body).to include('Welcome to Chitter')
        end

        it 'displays messages from users' do
            response = get('/')
        
            expect(response.status).to eq(200)
            expect(response.body).to include('title: paired programming')
            expect(response.body).to include('content: learning to pair program')
            expect(response.body).to include('tags: {2,3}')
        end
    end

    context "POST /" do
        it 'returns a new chitter message' do
          response = post(
            '/',
            title: 'Learing HTML',
            content: 'its a easy to get muddled up',
            tags: '{2,3}',
            user_id: 1
          )

          expect(response.status).to eq(302)
          expect(response.body).to include('')
        end
      
        it 'responds with 400 status if parameters are invalid' do
            response = post(
                '/',
                title: '',
                content: '',
                tags: '',
                user_id: ''
              )
            expect(response.status).to eq(400)
        end
    end
end