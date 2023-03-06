### Ruby Bot

Ruby Bot is a Mastodon bot that runs ruby in mentions and replies with the result.

## What it does

1. Use the [Push Subscription API](https://docs.joinmastodon.org/methods/push/#create) to be notified of new mentions.
2. Fetch the mentions
3. Atempt to parse and run the mention as ruby code
4. Reply with the evaluation, output and/or error.
