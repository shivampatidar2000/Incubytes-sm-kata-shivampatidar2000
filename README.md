# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Project Setup
    bundle install
    rails db:create db:migrate
    rails s
* Endpoints
    Endpoint	                            Method	                    Description
    /employees	                            GET/POST	                CRUD for employees
    /employees/:id/calculate_salary	        GET	                        Calculates deductions & net salary
    /salary_metrics/by_country/:country	    GET	                        Country salary stats
    /salary_metrics/by_job_title/:job_title	GET	                        Job salary stats
