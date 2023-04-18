require "sqlite3"

class Connection
    def new
        @db=nil
    end

    def get_connection
        if @db==nil
            @db||=SQLite3::Database.new "../controller/db.sql"          
              createdb
        end
        @db
    end

    def createdb
        rows=self.get_connection().execute <<-SQL
        CREATE TABLE IF NOT EXISTS user_projects(
            project INTEGER,
            user INTEGER,
            isadmin INTEGER,
            creator INTEGER,
            creator_name varchar(20)
        );
        CREATE TABLE IF NOT EXISTS user (
            id INTEGER PRIMARY KEY,
            userName varchar(20),
            email varchar(30),
            password varchar(6)
        );
        CREATE TABLE IF NOT EXISTS project (
            id INTEGER PRIMARY KEY,
            project_name varchar(20),
            description varchar(50),
            contents varchar(150)
        );
        SQL
    end

    def execute(query)
        self.get_connection().execute(query)
    end
end