# feedback

An anonymous feedback mechanism guaranteeing anonymity to those providing it.

Try it: https://dwyl-feedback.herokuapp.com

![feedback-app-screenshot](https://user-images.githubusercontent.com/194400/44026238-4955d5ea-9eea-11e8-86b1-7e26ae69ea72.png)

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
+ Set environment variables:
  + ADMIN_EMAIL - the email that you want to log in with (must also be verified by AWS)
  + ADMIN_PASSWORD - the password you want to log in with
  + SECRET_KEY_BASE - taken from `config.exs`
  + TARGET_EMAIL - verified SES email for testing
  + SES_SERVER - your SES server
  + SES_PORT - your SES port
  + SMTP_USERNAME - your SMTP username
  + SMTP_PASSWORD - your SMTP password
  + DEV_URL - http://localhost:4000
  + PROD_URL - url of the live site
+ Run `priv/repo/seeds.exs`
+ Run `source .env` to load your environment variables
+ Start Phoenix endpoint with `mix phoenix.server`

Now visit [`localhost:4000`](http://localhost:4000) from your web browser.


# Research

See the [`research.md`](https://github.com/dwyl/feedback/blob/master/research.md)
file.

# Conclusion

We have [surveyed the market](https://github.com/dwyl/feedback/blob/master/research.md)
and can conclude that there isn't an existing Open-Source, easy-to-run application
or Service with an API we can use in April 2017 so we decided to *make* one.
