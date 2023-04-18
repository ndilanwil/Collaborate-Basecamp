require 'sqlite3'
require_relative 'database.rb'

$tablename = 'user'

class User 
    attr_accessor :id, :userName, :email, :password

    def initialize(array)
        @id = array[0]
        @userName = array[1]
        @email = array[2]
        @password = array[3]
    end

    def to_hash
        {id: @id, userName: @userName, email: @email, password: @password}
    end

    def inspect
        %Q| <User id: "#{@id}", userName: "#{@userName}", email: "#{@email}", password: "#{@password}">|
    end

    def self.createUser(user_info)
        query = <<-REQUEST
        INSERT INTO #{$tablename} (userName, email, password) VALUES (
            "#{user_info[:userName]}",
            "#{user_info[:email]}",
            "#{user_info[:password]}"
        );
        REQUEST
        puts query
        Connection.new.execute(query)
    end

    def self.allUsers
        query = <<-REQUEST
            SELECT * FROM #{$tablename}
        REQUEST
        rows = Connection.new.execute(query)
        if rows.any?
            rows.collect do |row|
                User.new(row)
            end
        end 
    end

    def self.findUser(userId)
        query = <<-REQUEST
            SELECT * FROM #{$tablename} WHERE id = #{userId};
        REQUEST
        p query
        row = Connection.new.execute(query)
        if row.any?
            User.new(row)
        else
            nil
        end
    end

    def self.updateUser(userId, attribute, value)
        query = <<-REQUEST
            UPDATE #{$tablename}
            SET #{attribute} = '#{value}'
            WHERE id = #{userId}
        REQUEST
        Connection.new.execute(query)
    end

    def self.destroy(userId)
        query = <<-REQUEST 
            DELETE FROM #{$tablename}
            WHERE id = #{userId}
        REQUEST
        p query
        Connection.new.execute(query)
    end

end

def main()
  # p User.createUser(userName:'sdfgrr', email:'frrfd@gmail.com', password:'lana12')
   # p User.updateUser(2, :userName, 'yess')
    #p User.destroy(5)
#    p User.findUser(1)
    
    p User.allUsers
end

main()