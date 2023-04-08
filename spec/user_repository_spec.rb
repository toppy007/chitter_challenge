require 'user_repository'
require 'user'

def reset_users_table
    seed_sql = File.read('spec/seeds/seeds_chitter_challenge_test.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_challenge_test' })
    connection.exec(seed_sql)
end

RSpec.describe UserRepository do

    before(:each) do 
        reset_users_table
    end

    context 'testing the UserRepository class' do
        it 'return all users' do
            repo = UserRepository.new
            user = repo.all

            expect(user.length).to eq 3 
            expect(user[0].id).to eq 1 
            expect(user[0].email).to eq 'chris_@hotmail.com' 
            expect(user[0].password).to eq '1234567890abc'
            expect(user[0].username).to eq 'toppy'
        end

        it 'create a new user' do
            repo = UserRepository.new

            new_user = User.new
            new_user.email = 'andy_@gmail.com'
            new_user.password = '1111abcde'
            new_user.username = 'andy'

            repo.create(new_user)
            added_user = repo.all

            expect(added_user.length).to eq 4
            expect(added_user.last.email).to eq 'andy_@gmail.com'
            expect(added_user.last.password).to eq '1111abcde'
            expect(added_user.last.username).to eq 'andy'
        end
    end
end