# Welcome to My Basecamp 1
***

## Task
What is basecamp?
It's a web-based project management tool launched in 2004. Its primary features are to-do lists, milestone management, forum-like messaging, file sharing, and time tracking - basecamp

We will have a to create a website which mimique features from the original tools. It means having a database, a backend and a frontend.

We want our users to create their accounts, to connect and create projects!

As developer you need to think about the User Experience and it needs to be great.

## Description
This projects was solved by using an MVC method with Ruby language and sinatra gem to manage the database
Let's talk about each part
Views: views represent the front-end, what the user will see.
        For this part we used HTML, CSS and bootstrap

Models: This usually represented the database and models. That is all what deals with databases and classes
        -Our database is made up of 3 tables, users, project, and user_projects
        users is the table containing all users and their infos
        projects is the table containing all projects and their infos
        user_projects is the table which will be the relation between each users and their projects
        For the class we got 3 to User, Project, UserProject for users,projects and user_projects respectively

Controller: Ok somehow the server, it manages the relation between the "views" and the "models"
            You will find a doc server, this doc has been manage using sinatra gem(We were young when starting so we didn't use a framework)
            some other gems used here is sinatra/flash which is used to display flash messages on screen
            
## Installation
enter the controller doc : cd controller
do a bundle init to install the gems: bundle init
launch the server : ruby server.rb
Then go to https://web-x5defceb0-f97d.docode.fi.qwasar.io/

cd controller
bundle init
ruby server.rb

Then go to https://web-x5defceb0-f97d.docode.fi.qwasar.io/

## Usage
After launching go to https://web-x5defceb0-f97d.docode.fi.qwasar.io/
The UI/UX is made in such a way the user is easily guided by himself
As you arrive you will see a welcome home, if you are a new user choose sign up else login
fill in the infromations, on your home page you will find at the header
add project to add a project, edit user to edit your infos, log out to log out
on the body you will see 3 columns one is for the project created by you one for all your projects and the other for projects on which you were added
For the rest of your navigation you will be able to fly by yourself

### The Core Team


<span><i>Made at <a href='https://qwasar.io'>Qwasar Silicon Valley</a></i></span>
<span><img alt='Qwasar Silicon Valley Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px'></span>
