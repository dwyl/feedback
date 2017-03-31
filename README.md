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
+ ***Sayat.me***: https://www.sayat.me/ this is a feedback tool that is used
by individuals to gain insight into how people honestly feel about them. It has
a good interface for the feedback itself but it's too specific which means that
it doesn't apply to organisations such as dwyl. The feedback is public and
comments can be made on the feedback:
![sayat.me feedback](https://cloud.githubusercontent.com/assets/12450298/24554452/38df2670-15f3-11e7-9cdd-8757072183e0.png)
+ ***Suggestion Ox***: https://www.suggestionox.com is a private feedback platform
and is easy to set up but only allows you one suggestion box before
you have to subscribe to some sort of service. The functionality looks good and
it offers a few privacy features that could be nice, for example if you only want
your feedback question to be viewed by certain people, you can give them a secret
word that they have to enter before gaining access.
![suggestion ox feedback](https://cloud.githubusercontent.com/assets/12450298/24554725/3864b056-15f4-11e7-9e09-748b4da8e5bc.png)
![suggestion ox form](https://cloud.githubusercontent.com/assets/12450298/24554757/5272e8fa-15f4-11e7-8c6e-33031ffc30c5.png)
Once your feedback has been submitted it appears in an inbox that organises and
categorises them.
![suggestion ox answer](https://cloud.githubusercontent.com/assets/12450298/24555098/81b8b8a0-15f5-11e7-9247-7463a41db3b9.png)
+ ***3Sixty***: www.get3sixty.com is another feedback platform. However it isn't
secure and the functionality isn't up to scratch. It is free to use but it
imposes limits saying that you can only request feedback from 3 people per day
which isn't great.
![3sixty](https://cloud.githubusercontent.com/assets/12450298/24555419/b3c02ff8-15f6-11e7-9bf4-080b13546c41.png)
+ ***15FIVE***: https://www.15five.com is similar to Suggestion Ox.
![15 five](https://cloud.githubusercontent.com/assets/12450298/24556562/6d0058d2-15fa-11e7-9102-7337c47af05f.png)
They give you the option to input how you're feeling on a scale of 1-5 when
giving the feedback along with options to enter what's been going well and
what the biggest challenge is you're facing at the minute:
![15 five feedback](https://cloud.githubusercontent.com/assets/12450298/24556654/b82b2490-15fa-11e7-819f-f682e18894ce.png)
Once the feedback has been submitted it gives you the opportunity to review and
respond to it:
![15 five response](https://cloud.githubusercontent.com/assets/12450298/24557030/eb3f7ff6-15fb-11e7-815b-3f110b547f35.png)
+ Please add other existing providers
and search for if they allow anonymous feedback ...

### Open Source Feedback Systems?

> Are there any _Open Source_ feedback systems we can use and/or learn from.

+ ***PHPBack***: http://www.phpback.org/ is an open source project similar to
Uservoice found at https://github.com/ivandiazwm/phpback/. It's a feedback system
for products that can be directly injected into your website.


+ Scarce options for _Open Source_ feedback systems that will fit our exact
needs. Please add other existing providers and add them to the list.

### Gather Requirements

> Gather requirements from people you know who either work
or _have_ worked somewhere they don't _love_.
What _specifically_ would they like to have in a feedback system?

#### Examples

[@conorc1000](https://github.com/conorc1000):
##### Previous feedback experience
Conor worked for a civil engineering company run by a husband and wife. The husband
was the boss of the company and the wife was the company secretary. They would
have an appraisal once a year where you could voice your opinion about anything
regarding the company and your experience within it. However, this appraisal
was more of a box ticking exercise and the feedback given wouldn't filter
through to the boss which meant that no action could be taken on it, rendering
the whole thing a bit pointless.
##### Ideal feedback experience
Conor's ideal feedback system would consist of a free text input where you could
voice your opinion on the organisation that you work with. He would have two
toggles, one for anonymity and then the other for privacy. By switching the
toggles on the feedback it would mean that you could attach your name to it, or
not, and you could also say whether or not you would prefer if the feedback was
kept private or made public. He said that it might be good to have an incentive
to give feedback as well so that more people would get involved.

[@roryc89](https://github.com/roryc89)
##### Previous feedback experience
Rory worked for a spread-betting platform in London and said that he had similar
opportunities to give feedback in the form of appraisals. His perception was
that the feedback wasn't absorbed sufficiently and that it got lost among the
noise.
##### Ideal feedback experience
Rory's ideal feedback experience would be one with the ability to give anonymous
feedback about anything that was going on within the organisation. Also he would
want to open discussions about decisions that the agency makes in order to
further understand the way it functions and why. Rory also believes that
feedback should have the option to be private so that people are protected if
neccessary (you might be able to work out the identity of a person just by
the way they phrase something or the context in which they are talking). 
