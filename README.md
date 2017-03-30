# feedback

An anonymous feedback mechanism guaranteeing anonymity to those providing it.

## _Why_?

We _all_ have things we would _like_ to improve in our lives and work.
But _often_ we do not know how to approach communicating the "issue"
without _offending_ someone.
If we just _ignore_ the issue or
["_bottle it up_"](https://youtu.be/tf92q6Vrj2o)
without saying anything,
the issue _rarely_ just "_goes away_".

We need a _systematic_ way of sharing feedback on _anything_.
So that _anyone_ can describe an issue, capture and address it.


## _What_?

+ Collect ***anonymous*** feedback from _anyone_.
+ Store that feedback in a simple database
+ Act on the feedback and show progress towards _solving_ any issues raised.

> Initially the feedback will only be _internal_ but we need
to _discuss_ the potential for how to make it `public`
please share your thoughts on this: https://github.com/dwyl/feedback/issues/2




## _Who_?

### _Who_ is the feedback app made for?

Initially this app is for our _internal_ purposes.
We @dwyl are doing a _terrible_ job of collecting feedback from
all the team members, clients,
"users" of the apps we build and other stakeholders.

The `feedback` app addresses this challenge.

### _Who_ _might_ the feedback app be useful to in the future?

_Any_ organsiation or individual who needs a _systematic_ way of collecting
both specific/targeted ***and*** _anonymous_ feedback.


## _How_?

To run this app locally, you will need to have some _basic_ Phoenix Knowledge.
We recommend reading: https://github.com/dwyl/learn-phoenix-framework

### Get Started in _2 Minutes_

+ Clone the Git repository: `git clone git@github.com:dwyl/feedback.git && cd feedback`
+ Install dependencies with `mix deps.get && npm install`
+ Create and migrate your database with `mix ecto.create && mix ecto.migrate`
+ Start Phoenix endpoint with `mix phoenix.server`

Now visit [`localhost:4000`](http://localhost:4000) from your web browser.


# Research

see: https://github.com/dwyl/feedback/issues/1

### Existing Feedback Mechanisms/Solutions

+ ***Uservoice***: https://www.uservoice.com is one of the most well-known
product/user feedback platforms, but when we attempt to search their website
for the word "anonymous"
https://www.google.com/webhp?#q=https://www.uservoice.com:+anonymous
we don't see any results in their product.
But there is something on their forum: https://feedback.uservoice.com/forums/1-product-management/suggestions/956361-allow-anonymous-users-to-create-ideas-without-leav
+ Please add other existing providers
and search for if they allow anonymous feedback ... 

### Open Source Feedback Systems?

> Are there any _Open Source_ feedback systems we can use and/or learn from.


### Gather Requirements

> Gather requirements from people you know who either work
or _have_ worked somewhere they don't _love_.
What _specifically_ would they like to have in a feedback system?
