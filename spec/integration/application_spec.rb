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
        
            expect(response.body).to include('<h1')
            expect(response.body).to include('Chitter Message Board')
        end

        it 'displays messages from users' do
            response = get('/')
        
            expect(response.status).to eq(200)
            expect(response.body).to include('paired programming')
            expect(response.body).to include('learning to pair program')
            expect(response.body).to include('{2,3}')
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

    context "testing GET/POST /sign_up" do
        it "tests GET '/sign_up' " do
            response = get('/sign_up')
        
            expect(response.status).to eq 200
            expect(response.body).to include('<h1>welcome to the sign up page</h1>')
        end

        it "tests POST '/sign_up' " do
            response = post(
                '/sign_up',
                email: 'chris_top@gmail.com',
                password: 'toppyabcdefg',
                username: 'toppy'
            )
        
            expect(response.status).to eq 200
            expect(response.body).to include('<h1>welcome to the login page</h1>')
        end
    end

    context "testing GET/POST /login" do
        it "tests GET '/login' " do
            response = get('/login')
        
            expect(response.status).to eq 200
            expect(response.body).to include('<h1>welcome to the login page</h1>')
        end

        it "tests POST '/login' with correct password" do
            response = post(
                '/login',
                email: 'chris_top@gmail.com',
                password: 'toppyabcdefg'
            )
            expect(response.status).to eq 200
            expect(response.body).to include('<h1>Logged in</h1>')
        end

        it "tests POST '/login' with incorrect password" do
            response = post(
                '/login',
                email: 'chris_top@gmail.com',
                password: 'andyabcdefg'
            )
            expect(response.status).to eq 200
            expect(response.body).to include('<h1>Login error</h1>')
        end
    end
end