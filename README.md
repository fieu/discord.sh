# Discord.sh

Write-only command-line integration for Discord webhooks, written in 100% Bash script. Influenced heavily by [slack-cli][slack].

[![Travis (.org) branch](https://img.shields.io/travis/ChaoticWeg/discord.sh/master.svg)](https://travis-ci.org/ChaoticWeg/discord.sh)

### Dependencies

- [curl]() (http requests)
- [bats]() (tests)

### Specifying a Webhook URL

There are three ways to point `discord.sh` at a webhook endpoint, in order of recommended usage:

1. Set an environment variable called `$DISCORD_WEBHOOK`
2. Create a file called `.webhook` in the same directory as `discord.sh`, containing only the webhook URL
3. Pass the webhook URL as an argument to `discord.sh` using `--webhook-url`

### Usage

1. [Set up a webhook][webhook] in the desired Discord text channel
2. Download (or clone) a copy of `discord.sh`
3. Point `discord.sh` at a webhook endpoint (see above)
4. Go nuts.

[slack]: https://github.com/rockymadden/slack-cli/
[curl]: https://curl.haxx.se/
[bats]: https://github.com/sstephenson/bats
[webhook]: https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
