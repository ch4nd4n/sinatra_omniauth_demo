### Introduction
Sample code to use Omniauth in conjunction with Sinatra.

### Derived from

Watch [Railcast](http://railscasts.com/episodes/304-omniauth-identity?view=asciicast) to get an idea of how Omniauth can be used in Ruby.

Take  a look at the code to understand rest of it.

### Few things added

* Use of Twitter Bootstrap(CDN reference)
* Customized log in and registration page
* Use of Identity Strategy
* Simple role based sinatra routes.

#### Rake Tasks

    rake db:create_migration  # create an ActiveRecord migration
    rake db:migrate           # migrate the database (use version with VERSION=n)
    rake db:rollback          # roll back the migration (use steps with STEP=n)

* More on migrations on [sinatra-activerecord Github](https://github.com/janko-m/sinatra-activerecord)
* Integrated multiple omniauth provider. [More info](http://bernardi.me/using-multiple-omniauth-providers-with-omniauth-identity-on-the-main-user-model/)

#### Access irb console
To be able to do some dirty checks

    irb
    load 'app.rb'
    u = User.all
