# Angular-Coffee-Haml-Skeleton

This seed app lets you bootsrap a fresh angular app with coffee script and HAML and live reload configured. It is based on

* [yeoman-angular-haml])(https://github.com/tuyen/yeoman-angular-haml)

I changed the gruntfile a bit to allow for a bit more control over the build process (which files to include from bower dependencies etc.)

## Assumptions

* nodejs & npm
* ruby -- uses the haml gem at compile time, and also sass

## Installation

Install grunt and bower:

    npm install -g grunt-cli bower
    
Install haml gem:

    gem install haml
    
Install compass for SASS support:

    gem install sass

Install dependencies:
    
    npm install
    bower install

## Run

Launch the server:

    grunt server

to build a release

    grunt release

## Test

    grunt server
    karma start


Edit any of the files in app and watch the LiveReload goodness!
