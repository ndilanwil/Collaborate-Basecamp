require "sqlite3"
require_relative 'database.rb'

$project_table='project'

class Project
    attr_accessor :id, :project_name, :description, :contents

    def initialize(array)
        @id           = array[0]
        @project_name = array[1]
        @description  = array[2]
        @contents     = array[3]
    end
    
    def inspect
        %Q| <Project id: "#{@id}", project_name: "#{@project_name}", description: "#{@description}", contents: "#{@contents}">|
    end

    def to_hash
        {id: @id, project_name: @project_name, description: @description, contents: @contents}
    end

    def self.createProject(project_info)
        query = <<-REQUEST
        INSERT INTO #{$project_table} (project_name, description, contents) VALUES (
            "#{project_info[:project_name]}",
            "#{project_info[:description]}",
            "#{project_info[:contents]}"
        );
        REQUEST
        Connection.new.execute(query)
    end
   
    def self.allProjects
        query = <<-REQUEST
            SELECT * FROM project
        REQUEST
        
        rows = Connection.new.execute(query)
        if rows.any?
            rows.collect do |row|
                Project.new(row)
            end
        else
            []
        end 
    end

    def self.updateProject(project_id,attribute,value)
        query = <<-REQUEST
            UPDATE #{$project_table} SET #{attribute}="#{value}" WHERE id="#{project_id}"
        REQUEST
        Connection.new.execute(query)
    end

    def self.deleteProject(project_id)
        query = <<-REQUEST
            DELETE FROM #{$project_table} WHERE id=#{project_id}
        REQUEST
        q = <<-REQUEST
            DELETE FROM user_projects WHERE project='#{project_id}'
        REQUEST
        Connection.new.execute(query)
        Connection.new.execute(q)
    end
end

def main()
     #Project.createProject(project_name: 'souembot', description: 'love', contents: 'dilan lol')
    #i=5
    #while(i<23) do
    #Project.deleteProject(i)
    #i+=1
    #end
   
end

main()