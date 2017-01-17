# Deep Recusion

This is a demo project to show my Ruby and RoR code examples and technology vision. 

Deep recursion in general leads to stack overflow, so it would be a good
name for a project like Stack Overflow.

Though it is sligtly outdated (today we can use Rails 5 with ActionCable, for example) I think it shows many aspects of my code style.


## This project use:

* Rails 4.5 (the latest release at the project start)
* Rails Assets Pipeline, **SASS**, **Twitter Bootstrap** version 3
* **Slim** where it is possible, **ERB** otherwise
* Turbolinks
* Almost full **RSpec 3.5** coverage (green of course) with reasonable DRYed specs including Models, Controllers, Jobs, Mailers, shared examples, macroses, **FactoryGirl**, RSpec 3.5 mocks
* **shoulda-matchers** for RSpec
* JS-capable Feature RSpec tests using **Capybara** and **Webkit** webdriver
* Various approaches to **AJAX** data communacations to show possible uses of AJAX
* **Devise** for authentication and **Pundit** for authorization (with Policies RSpec tests)
* Multiple file uploaders using **[cocoon](https://github.com/nathanvda/cocoon)** gem
* **PrivatePub**-based Comet
* **JST** (Javascript Templates) with **skim** and **gon** gems to check authorization at client side in Comet renderings
* Skinny controllers using **Responders**
* **OAuth** authentications using Twitter and Facebook (with RSpec tests)
* **API** using **ActiveModel::Serializer**
* **Mailers** to send custom transactions emails (user subscriptions, etc) and digests (scheduled by **whenever** gem)
* **Rails Jobs** and **Sidekiq** to perform async tasks (e.g. mail dispatching)
* Search user created objects using **Sphinx** search engine and **thinking_sphinx** gem (with specs, of course!)
* **Capistrano** deployment
* Various **cachings** to speed up rendering

## Evolution

You can see how Deep Recursion grows using numbered branches aimed to implement separate features like API, Comet, JS RSpec and so on.

Of course, the final version is in **master** branch.

## A few words more

If you need my CV, ask me directly or in case you have an access to hh.ru, you can found it here: https://hh.ru/applicant/resumes/view?resume=2e90430cff020bdca50039ed1f574772796331
