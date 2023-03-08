### Ruby Bot

Ruby Bot is a Mastodon bot that runs Ruby code in mentions and replies with the result.

## Usage

Mention [rubybot@ruby.social](https://ruby.social/@rubybot) in a post.

> **Warning**
> We recommend you set posts mentioning Ruby Bot to 'unlisted', 'followers only' or 'mentions only' so they do not appear in the public timeline.

Ruby Bot will try to run the whole post (except for mentions):

```
@rubybot@ruby.social 7 * 6
```

```
@rubybot@ruby.social 
puts "7 * 6 = #{7 * 6}"
```

You can also use three backticks (` ``` `) to make Ruby Bot just run part of a post:

````
I like using object_class when parsing JSON - @rubybot@ruby.social 
```
require 'openstruct'
require 'json'
data = JSON.parse('{"count": 42}', object_class: OpenStruct)
puts "data => #{data.inspect}"
puts "data.count => #{data.count.inspect}"
```
````

## What it does

1. Use the [Push Subscription API](https://docs.joinmastodon.org/methods/push/#create) to be notified of new mentions.
2. Fetch the mentions
3. Attempt to parse and run the mention as Ruby code in a browser using the WASM build of Ruby.
4. Reply with the evaluation, output and/or error.
