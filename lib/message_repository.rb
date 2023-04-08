require_relative 'message'

class MessageRepository
    def all
        messages = []
    
        # Send the SQL query and get the result set.
        sql = 'SELECT id, title, content, tags, user_id, created_at FROM messages;'
        result = DatabaseConnection.exec_params(sql,[])
        
        # The result set is an array of hashes.
        # Loop through it to create a model
        # object for each message data hash.
        result.each do |message_data|
    
            # Create a new model object
            # with the message_data.
            message = Message.new
            message.id = message_data['id'].to_i
            message.title = message_data['title']
            message.content = message_data['content']
            message.tags = message_data['tags']
            message.user_id = message_data['user_id'].to_i
            message.created_at = message_data['created_at']

            messages << message
        end
        return messages
    end

    def create(message)
        sql = 'INSERT INTO messages (title, content, tags, user_id) VALUES ($1, $2, $3, $4);'
        params = [message.title, message.content, message.tags, message.user_id]
        result = DatabaseConnection.exec_params(sql, params)
    end
end