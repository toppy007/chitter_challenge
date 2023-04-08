require_relative 'user'

class UserRepository
    def all
        users = []
    
        # Send the SQL query and get the result set.
        sql = 'SELECT id, email, password, username FROM users;'
        result = DatabaseConnection.exec_params(sql,[])
        
        # The result set is an array of hashes.
        # Loop through it to create a model
        # object for each user data hash.
        result.each do |user_data|
    
            # Create a new model object
            # with the user_data.
            user = User.new
            user.id = user_data['id'].to_i
            user.email = user_data['email']
            user.password = user_data['password']
            user.username = user_data['username']

            users << user
        end
        return users
    end

    def create(user)
        sql = 'INSERT INTO users (email, password, username) VALUES ($1, $2, $3);'
        params = [user.email, user.password, user.username]
        result = DatabaseConnection.exec_params(sql, params)
    end

end
