require "sqlite3"
require_relative 'database.rb'

$table='user_projects'

class UserProjects
    attr_accessor :project, :user, :admin, :creator, :creator_name

    def initialize(array)
        @project           = array[0]
        @user = array[1]
        @admin  = array[2]
        @creator= array[3]
        @creator_name = array[4]
    end
    
    def inspect
        %Q| <Project project: "#{@project}", user: "#{@user}", admin: "#{@admin}", creator: "#{@creator}", creator_name: "#{@creator_name}">|
    end

    def to_hash
        {project: @project, user: @user, admin: @admin, creator: @creator, creator_name: @creator_name}
    end

    def self.all
        query = <<-REQUEST
            SELECT * FROM #{$table};
        REQUEST
        p rows = Connection.new.execute(query)
        if rows.any?
            rows.collect do |row|
                UserProjects.new(row)
            end
        end 
    end  

    def self.creator(project,id,creator)
        q = <<-REQUEST
            SELECT id FROM project WHERE project_name = "#{project}";
        REQUEST
        p r=Connection.new.execute(q)
        query = <<-REQUEST
            INSERT INTO user_projects (project, user, isadmin, creator, creator_name) VALUES ("#{r[0][0]}","#{id}","1","1","#{creator}");
        REQUEST
        Connection.new.execute(query)
    end
    
    def self.addmember(project,email,admin)
        q=<<-REQUEST
            SELECT id FROM user WHERE email="#{email}";
        REQUEST
        r=Connection.new.execute(q)
        qu=<<-REQUEST
            SELECT creator_name FROM user_projects WHERE project="#{project}";
        REQUEST
        re=Connection.new.execute(qu)
        query=<<-REQUEST
            INSERT INTO #{$table} (project, user, isadmin, creator, creator_name) VALUES ("#{project}","#{r[0][0]}","#{admin}" , "0", "#{re[0][0]}");
        REQUEST
        Connection.new.execute(query)
    end
    
    def self.createdByMe(id)
        q=<<-REQUEST
            SELECT project FROM #{$table} WHERE user="#{id}" AND creator=1;
        REQUEST
        p r=Connection.new.execute(q)
        i=0
        arr=[]
        while(i<r.length) do
                 query=<<-REQUEST
                    SELECT * FROM project WHERE id="#{r[i][0]}"
                REQUEST
                arr += Connection.new.execute(query)
            i+=1
        end
        p arr
        if arr.any?
            arr.collect do |row|
                query=<<-REQUEST
                SELECT creator_name FROM #{$table} WHERE project="#{row[0]}"
            REQUEST
            c=Connection.new.execute(query)
            row << c[0][0]
            UserProjects.new(row)
            end
        end 
    end
    
    def self.sharedWithMe(id)
        q=<<-REQUEST
            SELECT project FROM #{$table} WHERE user="#{id}" AND creator=0;
        REQUEST
        r=Connection.new.execute(q)
        i=0
        arr=[]
        while(i<r.length) do
                 query=<<-REQUEST
                    SELECT * FROM project WHERE id="#{r[i][0]}"
                REQUEST
                arr += Connection.new.execute(query)
            i+=1
        end
        if arr.any?
            arr.collect do |row|
                query=<<-REQUEST
                SELECT creator_name FROM #{$table} WHERE project="#{row[0]}"
            REQUEST
            c=Connection.new.execute(query)
            row << c[0][0]
            UserProjects.new(row)
            end
        end 
    end
    
    def self.allUserProject(id)
        q=<<-REQUEST
            SELECT project FROM #{$table} WHERE user="#{id}";
        REQUEST
        r=Connection.new.execute(q)
        i=0
        arr=[]
        while(i<r.length) do
                 query=<<-REQUEST
                    SELECT * FROM project WHERE id="#{r[i][0]}"
                REQUEST
                arr += Connection.new.execute(query)
            i+=1
        end
        if arr.any?
            arr.collect do |row|
                    query=<<-REQUEST
                        SELECT creator_name FROM #{$table} WHERE project="#{row[0]}"
                    REQUEST
                    c=Connection.new.execute(query)
                    row << c[0][0]
                    UserProjects.new(row)
            end
        end 
    end

    def self.count(id)
        q=<<-REQUEST
            SELECT COUNT(*) FROM #{$table} WHERE project="#{id}";
        REQUEST
        r=Connection.new.execute(q)
        return r[0][0]
    end

    def self.findcreator(id)
        q=<<-REQUEST
            SELECT creator_name FROM #{$table} WHERE project="#{id}";
        REQUEST
        r=Connection.new.execute(q)
        return r[0][0]
    end

    def self.findCreated(id)
         q=<<-REQUEST
            SELECT project FROM #{$table} WHERE user="#{id}" AND creator=1;
        REQUEST
        r=Connection.new.execute(q)
        return r
    end

    def self.findAdmin(pid,uid)
        q=<<-REQUEST
            SELECT * FROM #{$table} WHERE project="#{pid}" AND user="#{uid}";
        REQUEST
        r=Connection.new.execute(q)
        return r[0][3]
    end

    def self.findMembers(pid)
        result = []
        q=<<-REQUEST
            SELECT * FROM #{$table} WHERE project="#{pid}";
        REQUEST
        r=Connection.new.execute(q)
        i=0
        while(i<r.length) do
            qu=<<-REQUEST
                SELECT userName,email FROM user WHERE id="#{r[i][1]}";
            REQUEST
            re=Connection.new.execute(qu)
            if(r[i][2]==1)
                p r[i][2]
                result << [re[0][0],re[0][1],'Admin', r[i][3]]
            else
                result << [re[0][0],re[0][1],'Not admin', r[i][3]]

            end
            i+=1
        end
        return result
    end

    def self.del(id)
        q=<<-REQUEST
            DELETE FROM #{table} WHERE user=#{id};
        REQUEST
    end

    def self.updateMember(project,email,admin,what)
        q=<<-REQUEST
            SELECT id FROM user WHERE email="#{email}";
        REQUEST
        r=Connection.new.execute(q)
        query=<<-REQUEST
            UPDATE #{$table} SET #{what}="#{admin}" WHERE project="#{project}" AND user="#{r[0][0]}";
        REQUEST
        Connection.new.execute(query)
    end

end
#  UserProjects.creator("bitch",1,"sdfgrr")
#  UserProjects.addmember(2,"frrfd@gmail.com","yess")
#  UserProjects.addmember(3,"frrfd@gmail.com","hey")
#  UserProjects.creator("souembot",1,"sdfgrr")
# #  UserProjects.sharedWithMe(1)
# p UserProjects.all

p UserProjects.findMembers(10)

