# Monster Shop: Back End Mod 2 Group Project

## Introduction

*Monster Shop* is a web application created by [Sage Lee](https://github.com/sagemlee), [Danny Ramos](https://github.com/muydanny), [Michael Gallup](https://github.com/Gallup93), & [Stella Bonnie](https://github.com/stellakunzang), students at Turing School of Software and Design. It was our final project for Mod 2 (of 4), completed 5 weeks after first encountering Rails, MVC, ActiveRecord, and RSpec.

The "Monster Shop" itself is a fictitious e-commerce platform, specializing in silly items. It is something akin to a digital flea market, hosting many different merchants who are each responsible for fulfilling their part of a customer's order. Vistors to the site must be logged-in in order to checkout. Once they enter shipping information and checkout, a merchant user is able to then fulfill their items in the order. Once all of the items from the various merchants have been marked as fulfilled, the order status is changed to "packaged." This status is visible to the customer. A third type of user, an admin or "super user", is then able to mark the order as "shipped."

This project was completed remotely, with team members utilizing Slack, Zoom, Github, and Github projects in order to collaborate and accomplish the 54 assigned user stories in a mere 10-days. As is encouraged by Turing, we relied heavily on Test Driven Development(TDD) and ActiveRecord, strived to create RESTful routes and slim controllers, and utilized Action Helper Tags in the views. Our tests are written in RSpec with Orderly, Capybara, and Should Matchers gems.

## Schema Design

When we began the project, we were pleasantly surprised to find that the schema was already populated with merchants, items, reviews, and orders. A joins table for the many-to-many relationship between items and orders was also already created. Our first addition was users, which included columns for name, address, city, state, zip code, email, password digest, and role. This was our first project with authentication and authorization, and we utilized the BCrypt gem in order to create the password digests(i.e. encrypted passwords stored in database instead of user passwords). The role utilized an enum association, with a default setting of 0 to denote a basic user.

Once we started working on the merchant user functionality (role 1), we needed a migration to associate a user with a merchant. We created a one-to-many relationship (one merchant, many employees) and a foreign_key of merchant id on the users table.

We also needed to add a column to the orders table with a status, and again used enums to associate an integer with a string (pending, packaged, shipped, or cancelled). We also realized a little further along that we would need to associate a user with an order. This was truly the most difficult migration because we had to go back and revise all of our tests and seeds to first create a user and then associate it with the orders. This relationship was also a one-to-many, with a user having many orders.

Our final migration was to add fulfillment to the item orders joins table, denoting whether a particular item in an order had been fulfilled by the merchant. A merchant user was then able to mark an order as fulfilled.

## Code Snippets

Of note, we refactored some of our model methods which were relying heavily on SQL, to simplified, streamlined ActiveRecord methods.

SQL => AR refactoring

We also went back once the project was completed to refactor our routes, utilizing namespacing to make them more RESTful. In accordance with this refactor, we restructured our controller, view, and test file structure to incorporate more nested directories.

RESTful routes refactor

## Implementation Instructions

### Rails
* Create routes for namespaced routes
* Implement partials to break a page into reusable components
* Use Sessions to store information about a user and implement login/logout functionality
* Use filters (e.g. `before_action`) in a Rails controller
* Limit functionality to authorized users
* Use BCrypt to hash user passwords before storing in the database

### ActiveRecord
* Use built-in ActiveRecord methods to join multiple tables of data, calculate statistics and build collections of data grouped by one or more attributes

### Databases
* Design and diagram a Database Schema
* Write raw SQL queries (as a debugging tool for AR)

## Requirements

- must use Rails 5.1.x
- must use PostgreSQL
- must use 'bcrypt' for authentication
- all controller and model code must be tested via feature tests and model tests, respectively
- must use good GitHub branching, team code reviews via GitHub comments, and use of a project planning tool like github projects
- must include a thorough README to describe their project


## Rubric

| | **Feature Completeness** | **Rails** | **ActiveRecord** | **Testing and Debugging** | **Documentation** |
| --- | --- | --- | --- | --- | --- |
| **4: Exceptional**  | All User Stories 100% complete including all sad paths and edge cases, and some extension work completed | Students implement strategies not discussed in class to effectively organize code and adhere to MVC. | Highly effective and efficient use of ActiveRecord beyond what we've taught in class. Even `.each` calls will not cause additional database lookups. | Very clear Test Driven Development. Test files are extremely well organized and nested. Students utilize `before :each` blocks. 100% coverage for features and models. Close to all edge cases are accounted for.| Final project has a well written README with pictures, schema design, code snippets, contributors names linked to their github profile, heroku link, and implementation instructions. |

| **3: Passing** | Students complete all User Stories. No more than 2 Stories fail to correctly implement sad path and edge case functionality. | Students use the principles of MVC to effectively organize code. Students can defend any of their design decisions. Students limit access to authorized users. | ActiveRecord is used in a clear and effective way to read/write data using no Ruby to process data. | 100% coverage for models. 98% coverage for features. Tests are well written and meaningful. | Students have a README with thorough implementation instructions and description of content. |
|
