<h4 align="center">
  <br>
  <a href="https://github.com/ChaoticWeg/discord.sh"><img src="https://i.imgur.com/xZ8r3N0.png" alt="discord.sh"></a>
  <br>
  <br>
</h4>

<p align="center" id="badges">
  <a href="https://github.com/chaoticweg/discord.sh/releases/latest"><img src="https://img.shields.io/github/release/chaoticweg/discord.sh.svg?style=for-the-badge&label=Download"/></a>
  <a href="https://travis-ci.org/ChaoticWeg/discord.sh"><img src="https://img.shields.io/travis/ChaoticWeg/discord.sh/master.svg?style=for-the-badge" alt="Travis CI (master branch)"></a>
  <a href="https://github.com/ChaoticWeg/discord.sh/stargazers"><img src="https://img.shields.io/github/stars/ChaoticWeg/discord.sh.svg?style=for-the-badge" alt="GitHub stars"></a>
</p>

> Write-only command-line integration for Discord webhooks, written in 100% Bash script. Influenced heavily by [slack-cli][slack].

## Table of Contents
- [Features](#features)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Options](#options)
- [Tips](#tips)
- - [Proper character escaping](#proper-character-escaping)
- [Contributing](#contributing)
- [License](#license)

### Features
- Create and send very customizable and beautiful Discord messages 🎉 ✨
- Less than 400 lines of pure Bash 😎
- Extremely lightweight ⚡ 🚀
- Only requires [curl][curl] and [jq][jq] to run 🔥

### Dependencies

- [curl][curl] (http requests)
- [bats][bats] (tests)
- [jq][jq] (JSON parsing)

## Usage

### 1. Setting up a Discord webhook.

1. [Setup a webhook][webhook] in the desired Discord text channel
2. Download (or clone) a copy of `discord.sh`
3. Point `discord.sh` at a webhook endpoint (see below)
4. Go nuts.

### 2. Specifying a Webhook URL within `discord.sh`

There are three ways to point `discord.sh` at a webhook endpoint, in order of priority that `discord.sh` takes:

1. Pass the webhook URL as an argument to `discord.sh` using `--webhook-url`
2. Set an environment variable called `$DISCORD_WEBHOOK`
3. Create a file called `.webhook` in the same directory as `discord.sh`, containing only the webhook URL

### 3. Using the script

__Simple chat example__

```bash
$ ./discord.sh --webhook-url="$WEBHOOK" --text "Hello, world!"
```

__Simple chat example with custom username and avatar__

```bash
$ ./discord.sh \
  --webhook-url="$WEBHOOK" \
  --username "NotificationBot" \
  --avatar "https://i.imgur.com/12jyR5Q.png" \
  --text "Hello, world!"
```

__Advanced chat example using an embed (using all possible options)__

```bash
$ ./discord.sh \
  --webhook-url="$WEBHOOK" \
  --username "NotificationBot" \
  --avatar "https://i.imgur.com/12jyR5Q.png" \
  --text "Check out this embed!" \
  --title "New Notification!" \
  --description "This is a description\nPretty cool huh?" \
  --color "0xFFFFFF" \
  --url "https://github.com/ChaoticWeg/discord.sh" \
  --author "discord.sh" \
  --author-url "https://github.com/ChaoticWeg/discord.sh" \
  --author-icon "https://i.imgur.com/12jyR5Q.png" \
  --image "https://i.imgur.com/12jyR5Q.png" \
  --thumbnail "https://i.imgur.com/12jyR5Q.png" \
  --field "Author;ChaoticWeg" \
  --field "Author;fieu" \
  --footer "discord.sh" \
  --footer-icon "https://i.imgur.com/12jyR5Q.png" \
  --timestamp
```

__Sending a file (up to 8MB, per Discord limitations)__

_Note: per the Discord webhook API, posts cannot contain embeds **and** file attachments. Therefore, `discord.sh` will bail out when trying to build a message with embeds and files. The best practice is to send the message with embeds before sending a file._

```bash
$ ./discord.sh \
  --webhook-url="$WEBHOOK" \
  --file README.md \
  --username "Notification Bot" \
  --text "Check out this README.md file!"
```

## Options

### • `--webhook-url <url>`
> This should be set to your Discord webhook URL. You may alternatively set the environment variable `DISCORD_WEBHOOK` to your Discord webhook URL and that way you don't have to pass in the webhook URL inline.

### • `--text <string>`
> This is basic text like shown below.

![](https://i.imgur.com/LQx7PLT.png)

### • `--username <string>`
> You can override the username of the webhook "bot" with this flag.

![](https://i.imgur.com/jTA9XgW.png)

### • `--avatar <url>`
> You can override the avatar of the webhook "bot" with this flag.

![](https://i.imgur.com/lni4fI3.png)

## Advanced Options

Now we're going to look at how to setup a custom embed message.

### • `--title <string>`
> This option allows you to set the title of the embed.

![](https://i.imgur.com/LRB77rl.png)

### • `--description <string>`
> This option allows you to set the description of the embed.

![](https://i.imgur.com/Wdo7J1N.png)

### • `--color <string>`
> This option allows you to set color on the left of the embed.

#### Input Syntax 1: `0x` + `COLOR HEX`
#### Input Syntax 2: `COLOR DEC`
#### Input Example 1: `--color 0xFFFFFF`
#### Input Example 2: `--color 16777215`

![](https://i.imgur.com/cUQPjoK.png)

### • `--url <url>`
> This option allows you to set the URL of the `--title` flag within the embed.

![](https://i.imgur.com/xqTcE5p.png)

### • `--author <string>`
> This option allows you to set the author name of the embed.

![](https://i.imgur.com/dL4hvyw.png)

### • `--author-url <url>`
> This option allows you to set the author URL of the `--author` flag within the embed.

![](https://i.imgur.com/0E39bcV.png)

### • `--author-icon <url>`
> This option allows you to set the author icon that sits to the left of the `--author` flag within the embed.

![](https://i.imgur.com/hHReI85.png)

### • `--image <url>`
> This option allows you to set the image that sits within the embed.

![](https://i.imgur.com/v3qrJpS.png)

### • `--thumbnail <url>`
> This option allows you to set the thumbnail that sits to the right within the embed.

![](https://i.imgur.com/ogzUeHl.png)

### • `--field <name;value;inline>`
> This option allows you to add fields to your embed. You may use this option multiple times up to 25 times.
Example usage:
```bash
$ ./discord.sh \
  --webhook-url="$WEBHOOK" \
  --username "System Status" \
  --description "Here are your system stats!" \
  --field "Hostname;localhost;false" \
  --field "CPU;95%" \
  --field "Disk Usage;120/512GB"
```
![](https://i.imgur.com/wPKmCdM.png)
### • `--footer <string>`
> This option allows you to set the thumbnail that sits to the right within the embed.

![](https://i.imgur.com/xqlgW9t.png)

### • `--footer-icon <url>`
> This option allows you to set the footer icon that sites to the right of the `--footer` flag within the embed.

![](https://i.imgur.com/YfvfW2h.png)

### • `--timestamp`
> This option allows you to define whether the timestamp is displayed on the embed message or not.
![](https://i.imgur.com/T5EhvyB.png)

## Tips
### Proper character escaping
If you want to show the output of a file or `stdin` via [discord.sh][discord.sh], and your file includes special characters such as ``backticks (`)`` and `"`, then you can't simply `cat filename`. You will need to properly escape special characters.

One of the easiest methods to output properly escaped text from a file is to use `jq`, `cut`, and `rev`

#### Prerequisites
* [jq][jq] - Character escaping
* [cut][cut] - Cut characters from string (part of [coreutils][coreutils], included by default on most systems)
* [rev][rev] - Reversing of characters (part of [util-linux][util-linux], included by default on most systems)


#### Usage (contents of file)
1. Simply pass `filename` to the following command to escape the file contents to `stdout`:
```bash
jq -Rs . <filename | cut -c 2- | rev | cut -c 2- | rev
```
---
#### Usage (contents of `stdin`)
1. Simply pipe `stdin` to the beginning of the following command to escape the contents to `stdout`:
```bash
cat `filename` | jq -Rs . | cut -c 2- | rev | cut -c 2- | rev
```
---
2. Assuming `filename` or `stdin` contains the following contents when viewed in an editor such as `vim` or `nano`:
```
    ```php
    <?php echo "Hello, world!" ?>
    ```

    :smile:

    Bobs your uncle. !@#$%^&*()_}{":?><,./;'[]-=
```
3. If you ran the command, the output would be:
```
```php\n<?php echo \"Hello, world!\" ?>\n```\n\n:smile:\n\nBobs your uncle. !@#$%^&*()_}{\":?><,./;'[]-=\n
```
4. In order to use it in [discord.sh][discord.sh], all we have to do is pass that command within a [subshell](https://en.wikipedia.org/wiki/Child_process).
---
5. Usage (contents of file)
```bash
./discord.sh --webhook-url "$WEBHOOK_URL" --text "$(jq -Rs . <filename | cut -c 2- | rev | cut -c 2- | rev)"
```
---
5. Usage (contents of `stdin`)
```bash
./discord.sh --webhook-url "$WEBHOOK_URL" --text "$(cat filename | jq -Rs . | cut -c 2- | rev | cut -c 2- | rev)"
```
5. Result:

![Screenshot](https://i.imgur.com/VZH5Xsj.png)

#### Usage (contents of stdin)
Simply pass `filename` to the following command to escape the file to `stdout`:
```bash
jq -Rs . <filename | cut -c 2- | rev | cut -c 2- | rev
```


#### Explanation
`jq` takes the file in as `stdin` then escapes it. We then pipe it to cut to remove the first 2 "indexes" meaning the first character which is a `"` that `jq` adds. We then pip that into `rev` to reverse the text as a whole, then pipe that into `cut` to remove the first 2 "indexes" or first (last) character which is once again a `"` that `jq` adds. Finally we re-reverse the text back to the standard order. The command will output to `stdout`


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html)

<div class="weg-spacer" style="margin:2em;"></div>

Made with 💖 by [ChaoticWeg][weg] & [fieu][fieu] || Documentation and design by [fieu][fieu] and [Matt][matt]

<!-- Programs -->
[slack]: https://github.com/rockymadden/slack-cli/
[discord.sh]: https://github.com/ChaoticWeg/discord.sh
[curl]: https://curl.haxx.se/
[bats]: https://github.com/bats-core/bats-core
[jq]: https://stedolan.github.io/jq/
[rev]: https://linux.die.net/man/1/rev
[cut]: https://linux.die.net/man/1/cut
[coreutils]: https://www.gnu.org/software/coreutils/coreutils.html
[util-linux]: https://en.wikipedia.org/wiki/Util-linux
<!-- Documentation -->
[webhook]: https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
<!--  Contributors -->
[weg]: https://chaoticweg.cc
[fieu]: https://github.com/fieu
[matt]: https://github.com/MatthewDietrich
