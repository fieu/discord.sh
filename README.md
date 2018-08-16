<h4 align="center">
  <br>
  <a href="https://github.com/ChaoticWeg/discord.sh"><img src="https://i.imgur.com/xZ8r3N0.png" alt="discord.sh"></a>
  <br>
  <br>
</h4>

<p align="center">
  <a href="https://travis-ci.org/ChaoticWeg/discord.sh"><img src="https://img.shields.io/travis/ChaoticWeg/discord.sh/master.svg" alt="Travis CI (master branch)"></a>
</p>

Write-only command-line integration for Discord webhooks, written in 100% Bash script. Influenced heavily by [slack-cli][slack].

### Dependencies

- [curl][curl] (http requests)
- [bats][bats] (tests)
- [jq][jq] (JSON parsing)

## Usage

### 1. Setting up a Discord webhook.

1. [Set up a webhook][webhook] in the desired Discord text channel
2. Download (or clone) a copy of `discord.sh`
3. Point `discord.sh` at a webhook endpoint (see above)
4. Go nuts.

### 2. Specifying a Webhook URL within `discord.sh`

There are three ways to point `discord.sh` at a webhook endpoint, in order of recommended usage:

1. Set an environment variable called `$DISCORD_WEBHOOK`
2. Create a file called `.webhook` in the same directory as `discord.sh`, containing only the webhook URL
3. Pass the webhook URL as an argument to `discord.sh` using `--webhook-url`

### 3. Usage

Now we're going to look at how to use the script.

__Simple chat example__

```console
$ ./discord.sh --webhook-url=$WEBHOOK --text "Hello, world!"
```

__Simple chat example with custom username and avatar__

```console
$ ./discord.sh --webhook-url=$WEBHOOK --username "NotificationBot" --avatar "https://i.imgur.com/12jyR5Q.png" --text "Hello, world!"
```

__Advanced chat example using an embed (using all possible options)__

```console
$ ./discord.sh \
  --webhook-url=$WEBHOOK \
  --username "NotificationBot" \
  --avatar "https://i.imgur.com/12jyR5Q.png" \
  --text "Check out this embed!" \
  --title "New Notification!" \
  --description "This is a description\nPretty cool huh?" \
  --color "0xFFFFFF"
  --url "https://github.com/ChaoticWeg/discord.sh" \
  --author-name "discord.sh v1.0" \
  --author-url "https://github.com/ChaoticWeg/discord.sh" \
  --author-icon "https://i.imgur.com/12jyR5Q.png" \
  --footer "discord.sh v1.0" \
  --footer-icon "https://i.imgur.com/12jyR5Q.png"
```

[slack]: https://github.com/rockymadden/slack-cli/
[curl]: https://curl.haxx.se/
[bats]: https://github.com/sstephenson/bats
[jq]: https://stedolan.github.io/jq/
[webhook]: https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
