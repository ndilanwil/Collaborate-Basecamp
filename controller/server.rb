require 'sinatra'
require 'sinatra/flash'
require 'json'
require '../models/project.rb'
require '../models/user.rb'
require '../models/database.rb'
require '../models/user_projects.rb'
require "sqlite3"

enable :sessions

set :port, 8080
set :bind, '0.0.0.0'

set('views', '../views')


$id
get '/projects' do
    Project.allProjects.collect do |row|
        row.to_hash.to_json
    end
end

=begin
get '/users' do
    User.allUsers.collect do |row|
        row.to_hash.to_json
    end
end
=end
get '/' do
    erb :welcome
end

get '/signup' do 
    erb :signup
end
post '/signup' do
    puts params
    users=User.allUsers
    if(users!=nil)
        user=users.filter {|user| user.email==params['email']}.first
    end
    if(params['password']==params['Rpassword']&& user==nil)
        User.createUser(params)
        "user created"
        flash[:uCreated]="User created successfully. Please login"
        redirect '/login'
    elsif(user!=nil)
        flash[:uExist]="User already exist. Please login"
        redirect '/signup'
    else
        flash[:password]="Passwords must be the same"
        redirect '/signup'
    end
end

get '/login' do 
    erb :login
end

post '/login' do
    p params['email']
    p params['password']
    users=User.allUsers
    $user=users.filter { |user| user.email==params['email'] && user.password==params['password']}.first
    if($user && params['email']!="")
        session[:user_id]=$user.id
        $id=$user.id
        $name=$user.userName
        $password=$user.password
        flash[:connected]="Welcome back #{$name}"
        redirect '/home'
    else
        flash[:incorrect]="Wrong username or password"
        redirect '/login'
    end
end

get '/home' do
    erb :index
end

get '/projectCreation' do
    erb :create_project
end

post '/projectCreation' do
    Project.createProject(params)
    UserProjects.creator(params['project_name'],$id,$name)
    if UserProjects.findCreated($id)==[]
        flash[:pCreated]="You have created your first project ;)"
    end
    redirect '/home'
end

get '/editProject' do
    erb :edith_project
end

post '/editProjectName' do
    Project.updateProject($pid,"project_name",params['project_name'])
    flash[:pUpdate]="Project informations updated"
    redirect '/home'
end

post '/editProjectDesc' do
    Project.updateProject($pid,"description",params['description'])
    flash[:pUpdate]="Project's informations updated"
    redirect '/home'
end

post '/editProjectCont' do
    Project.updateProject($pid,"contents",params['contents'])
    flash[:pUpdate]="Project's informations updated"
    redirect '/home'
end

post '/sign_out' do
    if session[:user_id]
        session.clear
        flash[:Logout]="You have log out"
        redirect '/'
    end
end

get '/editUser' do
    erb :edith_user
end

get '/showProject' do
    erb :show_project
end
post '/editUser' do
    p params
    if(params['c_password']==$password)
        if(params['n_userName']!="")
            User.updateUser($id,"userName",params['n_userName'])
            flash[:uUpdate]="User's information updated successfully"
            redirect '/home'
        end
        if(params['n_email']!="")
            User.updateUser($id,"email",params['n_email'])
            flash[:uUpdate]="User's information updated successfully"
            redirect '/home'
        end
        if(params['n_password']!="")
            User.updateUser($id,"password",params['n_password'])
            flash[:uUpdate]="User's information updated successfully"
            redirect '/home'
        end
    else
        flash[:wrong]="Wrong password"
        redirect 'editUser'
    end
    
end

post '/user' do
    if session[:user_id] 
        if params['c_password']==$password
            User.destroy($id)
            UserProject.del($id)
            flash[:uDelete]="User permanently deleted"
            redirect '/'
        else
            flash[:wrong]="Wrong password"
            redirect '/editUser'
        end
    end
end

post '/project' do
    flash[:pDelete]="User's information updated successfully"
    Project.deleteProject(params['pid'])
    redirect '/home'
end

post '/show' do
    $pid=params['ppid'].to_i
    projects=Project.allProjects
    $project=projects.filter { |project| project.id==params['ppid'].to_i}.first
    p $project
    if UserProjects.findAdmin(params['ppid'].to_i,$id)==1
        redirect '/editProject'
    else
        flash[:notAdmin]="Sorry you are not an admin. You cannot edit the project"
        redirect '/showProject'
    end
end

post "/showP" do
    $pid=params['ppid'].to_i
    projects=Project.allProjects
    $project=projects.filter { |project| project.id==params['ppid'].to_i}.first
    p $project
    redirect '/showProject'
end

post "/addUser" do
    if(params['admin']=="yes")
        UserProjects.addmember($project.id,params['email'],1)
    else
        UserProjects.addmember($project.id,params['email'],0)
    end
    flash[:uAdded]="One user added"
    redirect '/showProject'
end

post '/updateUser' do
    if(params['admin']=="yes")
        UserProjects.updateMember($project.id,params['email'],1,"isadmin")
    else
        UserProjects.updateMember($project.id,params['email'],0,"isadmin")
    end
    flash[:update]="Member status updated"
    redirect '/showProject'
end