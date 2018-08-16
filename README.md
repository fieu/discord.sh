<h4 align="center">
  <br>
  <a href="https://github.com/ChaoticWeg/discord.sh"><img src="https://i.imgur.com/xZ8r3N0.png" alt="discord.sh"></a>
  <br>
  <br>
</h4>

<p align="center">
  <a href="https://travis-ci.org/ChaoticWeg/discord.sh"><img src="https://img.shields.io/travis/ChaoticWeg/discord.sh/master.svg" alt="Travis CI (master branch)"></a>
</p>

> Write-only command-line integration for Discord webhooks, written in 100% Bash script. Influenced heavily by [slack-cli][slack].

## Table of Contents
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Options](#options)

### Dependencies

- [curl][curl] (http requests)
- [bats][bats] (tests)
- [jq][jq] (JSON parsing)

## Usage

### 1. Setting up a Discord webhook.

1. [Setup a webhook][webhook] in the desired Discord text channel
2. Download (or clone) a copy of `discord.sh`
3. Point `discord.sh` at a webhook endpoint (see above)
4. Go nuts.

### 2. Specifying a Webhook URL within `discord.sh`

There are three ways to point `discord.sh` at a webhook endpoint, in order of recommended usage:

1. Set an environment variable called `$DISCORD_WEBHOOK`
2. Create a file called `.webhook` in the same directory as `discord.sh`, containing only the webhook URL
3. Pass the webhook URL as an argument to `discord.sh` using `--webhook-url`

### 3. Using the script

__Simple chat example__

```bash
$ ./discord.sh --webhook-url=$WEBHOOK --text "Hello, world!"
```

__Simple chat example with custom username and avatar__

```bash
$ ./discord.sh \
  --webhook-url=$WEBHOOK \
  --username "NotificationBot" \
  --avatar "https://i.imgur.com/12jyR5Q.png" \
  --text "Hello, world!"
```

__Advanced chat example using an embed (using all possible options)__

```bash
$ ./discord.sh \
  --webhook-url=$WEBHOOK \
  --username "NotificationBot" \
  --avatar "https://i.imgur.com/12jyR5Q.png" \
  --text "Check out this embed!" \
  --title "New Notification!" \
  --description "This is a description\nPretty cool huh?" \
  --color "0xFFFFFF" \
  --url "https://github.com/ChaoticWeg/discord.sh" \
  --author "discord.sh v1.0" \
  --author-url "https://github.com/ChaoticWeg/discord.sh" \
  --author-icon "https://i.imgur.com/12jyR5Q.png" \
  --image "https://i.imgur.com/12jyR5Q.png" \
  --thumbnail "https://i.imgur.com/12jyR5Q.png" \
  --footer "discord.sh v1.0" \
  --footer-icon "https://i.imgur.com/12jyR5Q.png"
```

## Options

### • `--webhook-url`
#### Input Type: String
> This should be set to your Discord webhook URL. You may alternatively set the environment variable `DISCORD_WEBHOOK` to your Discord webhook URL and that way you don't have to pass in the webhook URL inline.

### • `--text`
#### Input Type: String
> This is basic text like shown below.

![](https://i.imgur.com/LQx7PLT.png)

### • `--username`
#### Input Type: String
> You can override the username of the webhook "bot" with this flag.

![](https://i.imgur.com/jTA9XgW.png)

### • `--avatar`
#### Input Type: String
> You can override the avatar of the webhook "bot" with this flag.

![](https://i.imgur.com/lni4fI3.png)

## Advanced Options

Now we're going to look at how to setup a custom embed message.

### • `--title`
> This option allows you to set the title of the embed.
#### Input Type: String

![](https://i.imgur.com/LRB77rl.png)

### • `--description`
> This option allows you to set the description of the embed.
#### Input Type: String

![](https://i.imgur.com/Wdo7J1N.png)

### • `--color`
> This option allows you to set color on the left of the embed.
#### Input Type: String
#### Input Pattern 1: `0x` + `COLOR HEX`
#### Input Pattern 2: `COLOR DEC`
#### Input Example 1: `--color 0xFFFFFF`
#### Input Example 2: `--color 16777215`

![](https://i.imgur.com/cUQPjoK.png)

### • `--url`
> This option allows you to set the URL of the `--title` flag within the embed.
#### Input Type: String

![](https://i.imgur.com/xqTcE5p.png)

### • `--author`
> This option allows you to set the author name of the embed.
#### Input Type: String

![](https://i.imgur.com/dL4hvyw.png)

### • `--author-url`
> This option allows you to set the author URL of the `--author` flag within the embed.
#### Input Type: String

![](https://i.imgur.com/0E39bcV.png)

### • `--author-icon`
> This option allows you to set the author icon that sites to the right of the `--author` flag within the embed.
#### Input Type: String

![](https://i.imgur.com/hHReI85.png)

### • `--image`
> This option allows you to set the image that sits within the embed.
#### Input Type: String

![](https://i.imgur.com/v3qrJpS.png)

### • `--thumbnail`
> This option allows you to set the thumbnail that sits to the right within the embed.
#### Input Type: String

![](https://i.imgur.com/ogzUeHl.png)

### • `--footer`
> This option allows you to set the thumbnail that sits to the right within the embed.
#### Input Type: String

![](https://i.imgur.com/xqlgW9t.png)

### • `--footer-icon`
> This option allows you to set the footer icon that sites to the right of the `--footer` flag within the embed.
#### Input Type: String

![](https://i.imgur.com/YfvfW2h.png)

### • `--timestamp`
> This option allows you to define whether the timestamp is displayed on the embed message or not.
#### Input Type: Boolean

![](https://i.imgur.com/T5EhvyB.png)

[slack]: https://github.com/rockymadden/slack-cli/
[curl]: https://curl.haxx.se/
[bats]: https://github.com/sstephenson/bats
[jq]: https://stedolan.github.io/jq/
[webhook]: https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
