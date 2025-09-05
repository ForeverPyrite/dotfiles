# dotfiles

It's my dotfiles! Woah!!!!

This git repo really just stores a bootstrap script for new systems (`install.sh`, because I felt like naming it that for some reason...), along with...well...my .config configuration files.
Absolutely insane, I know.

okay yeah maybe a bootstrap script isn't exactly a dotfile, but oh well, it's not getting it's own repo.

# Setup Synopsis

I use `alacritty` as my terminal editor, if I'm on a desktop environment (sorry Xfce Terminal, your time has come).
For the shell, I use `fish`, as it has batteries included autocompletion, nice configuration syntax, and some other goodies. (I still have a decent amount of compatibility with `bash`, and the `.bash*` files are somewhat up to date...kind of)
In order to have a cutesy little shell prompt, I use `starship`
Of course, we must have the over-engineered `tmux` setup for terminal multiplexing.
Then there is a suite of Rust based commands for use in the CLI for the most baller terminal navigation imaginable. (The list is too large to put here, just check out [[#Short and sweet:]])
For consistent theming, I'm just like other girls and use [catppuccin](https://catppuccin.com/).

## Script Rundown

The script has a few phases that are pretty extensively commented on, but the gist is this:
(I'm not going to talk about OS detection and stuff because that's boring)

1. The script checks that the `git` and `stow` command are installed, to clone the repo (if it's not already in it) and `stow` the dotfiles (symlink them to where they are supposed to be under the `~/` directory)
2. The script installs a few packages from the system package manager:
  - `curl`, to install `rustup`, `docker`, `tailscale`, sometimes `starship`, and a [Nerd Font](https://www.nerdfonts.com/), depending on the flags
  - `tmux`, not only is it a godsend, but the script uses it to install packages in parallel because that's baller
  - `btop`, because I can't install it with `cargo install` (it's written in C)
  - `fish`, because I also can't build it that easily (largely written in Rust, but would require cloning the repo and having a few extra dependencies...and why do that?), and I'd prefer the shell be installed system-wide.
3. The script then runs a bunch of steps in parallel, using `tmux` to make individual sessions:
  - "dotfiles" - Always runs
    - Installs all the rust packages with `cargo`
    - Clones/installs `fzf`
    - Installs the Tmux Plugin Manager
  - "docker" - Runs when the `--docker` flag is passed
    - Installs Docker via the convenience, what the hell else would it be doing
  - "extended" - Runs when the `--extended` flag is specified (meant for GUI/Desktop setups)
    - Installs the "Hack Nerd Font" (very haphazardly, naively assumes Debian-based distro and that `fc-cache` is installed)
    - Installs `alacritty` as the terminal emulator
    - Changes the shell to `fish` (shouldn't it do that anyway?)


Quick shoutout to my man `gemini-2.5-pro-preview-05-06`, saved me from a large chunk of lame bash scripting.
Although I clearly didn't review the changes well enough if we have undefined variables, but I'll figure it out some day (it works, for the most part, so I'm not too worried. All my concerns are commented for my future self to fix if needed).

# holy Rust what is your problem (all of the Rust utilities)

Honestly, that's a valid question. The amount of oxidization my workflow has undergone must be some kind of unhealthy.
There isn't a whole lot of it that is me doing it just because "Rust", really.
If I was, I'd be full sending it and even replacing the GNU coreutils with the [Rust "uutils" rewrite](https://github.com/uutils/coreutils), but I don't even know what to call something that egregious.
Hell, that'd give off some "I use arch btw" energy.

While yes, I do enjoy coding in Rust, and yes, I just have a bias for Rust utilities over, say, Python, it makes sense.
Rust is the most loved programming language- and it's fast.
Due to it's popularity and how much people love writing programs in it, it makes sense that there are several useful, focused programs that are simply better than their predecessors.
Not to say you can't write powerful or tools with good UX in C/C++ or anything. Don't get it twisted.
I use tools like `btop` and "ImHex" rather frequently, which are largely written in C++. I'm simply pointing out that more people want to write in Rust, and that's probably why it's used for a large majority of these upgrades.
(I feel like it's also worth mentioning `ffmpeg` here, which is a pretty good example of how well-written C can surpass Rust)

That being said, I have actually found these utilities to vastly improve upon their couple decade-old counterparts.

## Short and sweet:


- `bat` - Drop in `cat` replacement, more modern formatting, uhh "cat with wings" is what they said. I agree.
- `ripgrep` - Drop in `grep` replacement, and it's FASTTTTTTTTTTTTTT. Has unironically saved me trying to find a file I misplaced so many times. FASTTTTTTTTTTTTTT.
- `eza` - Drop in `ls` replacement, more modern formatting, and even has a built in tree command! (The amount of times I've had to install `tree`...)
- `zoxide` - Drop in `cd` replacement, can use `fzf` to...well...fuzzy find, and it also just knows where to go. Even without filepaths.
- `fd-find` - Drop in `find` replacement. Much like `ripgrep`, it is incredibly fast and simply more modernized. The main difference is that `ripgrep` looks through file contents, and `fd` looks for file(path)s.
- `atuin` - This is kinda like zoxide, but for your shell commands. Pressing the up arrow now shows your entire command history, and you can fuzzy find through them. I imagine it's more secure than .bash_history too.
- `dua-cli` - Disk-usage-analyzer. Plain and simple. , so this'll do. Useful for my limited storage cloud VPS and stuff.
- `starship` - Super customizable cross-shell prompt. Very informative, yet very brief (at least, by default).
- `bob-nvim` - Neovim manager. Simple as that.
- `alacritty` - GPU accelerated and extremely customizable terminal emulator
- `cargo-cache` - Actually just used for this script so far. It'll clean up all the, likely useless, sizable compiled dependencies used to build all of this.
Not Rust
- `fish` - It's a really friendly and interactive shell, I like it's configuration/scripting a decent amount, and it has things like command autocompletion included, and that's pretty hype. (It's also mostly Rust, btw)
- `btop` - It's a resource monitoring TUI, but like, the most badass one out there. Incredibly intuitive and informative. Even if you open it just to find and kill a process, you're gonna look like a hacker doing it. 

When I say drop in replacement, I mean I literally set aliases for all of the commands with the original GNU ones, so my muscle memory stays the same and it is yet to have backfired on me.
Something to note about these modern Rust alternatives: most of them not only ignore hidden `.files`, but they will also respect `.gitignore` when present. Keep that in mind if they seem like they aren't working.


## As for the extended yap sesh:


### [bat](https://github.com/sharkdp/bat)
It has freaking SYNTAX HIGHLIGHTING
Not that that's *super* impressive or anything, but for an upgraded version of `cat`? That's AWESOME.

On top of syntax highlighting, it prints line numbers, the filename, will even show git diffs when relevant, and is just beautifully formatted.
If the output would go beyond the size of the screen, by default, `bat` will automatically page content using `less` by default. 
It can also act as a pager, which is also neat.

`bat` still acts just like `cat` when it's being used for pipes or output redirection, or by passing the `-pp` flag (once for `--plain` to disable any formatting, and then `--paging=never` to disable paging)

You can also unlock some secret synergies with [batextras](https://github.com/eth-p/bat-extras).

### [ripgrep](https://github.com/BurntSushi/ripgrep)
Command: `rg`

Actually an obscenely fast, and useful, file content search. Oh, and it also can work just like `grep`, which is pretty neat.

Lets say you remember the content of a file, but not the file name, somehow (I would *NEVER* do something this impractical)
You can simply run `rg "content"` and oh shit there it is.
Like no deadass by the time you press enter, the command has actually ran while you were typing it.
There is no hyperbole here, I couldn't be more serious.

I was expecting this command take a while since my old method of running the og `find -type f -exec grep "pattern" {} \;` was considerably slower.
At least a second?
Oh god no.
With `ripgrep`, I'm never waiting on the command to find results: I'm waiting on the commands output to finish printing on the screen.

The days of me running commands like the og `find` with `grep`, or `cat`ing the output of `.bash_history` to find a command I've used before are SO far gone, partly thanks to `ripgrep` (it helped start the whole Rust endeavour)

### [eza](https://eza.rocks)
I really don't have a ton to say, it's just `ls` but full of useful features that simply make it more modern (you'll notice this is a reoccurring theme with these tools).

As it is a drop in replacement for `ls`, and there are so many options.
I took the default aliases set in [.bashrc](./bash/.bashrc), and essentially converted them into `.bash_aliases`, before ultimately deciding to use `fish`.
Now the `eza` aliases for `ls` are in [config.fish](./fish/.config/fish/conf.d/aliases.fish), still mirroring the old `bash` aliases I've been using for years, but looking way better doing it.

### [zoxide](https://github.com/ajeetdsouza/zoxide)
Command: `z`
`zi` for interactive mode

As I said, it "just knows where to go", learning from your long ass paths, and letting you simply type in a keyword, or use fzf in interactive mode to find the directory you want.

Basically the command logs what directories you've been in when you run it.
Lets say you run `z really/annoying/and/long/file/path/omg/is-it/over.yet`
Well, you'd then be able to run `z over.yet` and it would find the directory to change into for you based off that.
It has a really smart algorithm to determine what the best path is using recency and frequency

You can also use it with two directory names
I have all of my code in `~/Documents/code`, sorted by language and some enough subdirectories to annoy me, even though the organizational benefit is worth it.
If I have an overlapping directory name outside of my `code` folder (like `~/docker/discord-bot` and `~/Documents/code/python/discord-bot`), and I want to specify that I want the one within the code directory:
`z code project-name`

To top it all off, there is an interactive mode with `fzf` with `zi` to go through your directories and their weights

Unlike the others, it actually has a `--cmd [cmd]` flag that will essential change `z` and `zi` to `[cmd]` and `[cmd]i`
This means you can easily directly replace `cd` by using the flag `--cmd cd` on the init command in your .bashrc or equivalent.

[The GitHub README](https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation) details it all incredibly well, and it supports most major shells, so you can certainly find a use for it no matter who you are. (well, unless you never touch the terminal, I guess)

### [fd-find](https://github.com/sharkdp/fd)
Command: `fd`

Gonna cut to the chase here, it's effectively the same as `ripgrep`, but on your files and filepaths instead.
Again, more modernized with features you'd expect from modern equivalents just like the rest of these.
The `--exec` options are SO much more useful here, as the most simple example.

This in tandem with `fzf` is actually a diabolical combo for any kind of interactive path selection (as in really effective).

### [autin](https://atuin.sh/)

It it's really useful compared to `history | grep "cmd i'm trying to find"` or `cat ~/.bash_history | grep "what was the name of that damn flag"`
There is also a feature I haven't used where you can sync your history to a server, which is kinda neat.
You can also see some pretty cool statistics too, but that's just a novelty.

I will, again, bitch when I'm the problem, but since it takes up so much more space than the literally non I'm used to, it'll push content I was about to use off the screen.
So for example, I might run `docker compose exec --help` to figure out how format a command, and then I press the up arrow so I can actually use the command (replace `--help` with `bash service_name` or whatever) and the `autin` window will open, pushing the formatting I was going to use as a reference for the next command out of the window.
This is partially an old habit of how shell histories usually work dying hard, but it's also me not giving enough fucks to just read some documentation and change some configuration.
Again, I'm absolutely the problem here, but I do find that default behavior a little annoying.

### [dua-cli](https://github.com/Byron/dua-cli)
Command: `dua`

Alright, it analyzes your disk usage. What else do I need to say? You know you need to clean your drive.

For some reason I can't figure out how to find folder sizes (I wouldn't be surprised if you could with `eza`)
Extremely useful, especially on my cloud VPSes with extremely limited space.
It's how I figured out that AdGuard was logging every single DNS request since I started using it, which was around a dozen or so gigs after a few months.
gigs 
Allegedly, it's able to help you remove files faster than `rm`, and while I don't have much experience with that, I don't doubt it one bit.

### [starship](https://starship.rs/)
uhh
It works as advertised, so I don't have a ton to say about it.
It works between shells, is extremely customizable, and...yeah

I haven't toyed with the configuration myself too much yet, just installed the catppuccin theme and moved on.
And honestly, I'm happy.
It tells you when you're one a remote host, github repo, codebase (along with a corresponding emoji), always useful and brief.

### [bob-nvim](https://github.com/MordechaiHadad/bob)
Command: `bob`

It's a neovim version manager I mean I don't really have a lot to say. 
Pretty straight-forward.
Why does it exist?
I don't know, but I like it.

Unfortunately, it hasn't been properly symlinking the `nvim` binary to anywhere within PATH, and I want to have it easily executable system-wide (so I can still invoke it via `sudo` or as another user (particularly for editing files owned by root))
I can either quit bitching and solve the problem, or complain about it here when it's my fault.
I'll stick with the latter for the time being.

(for desktop)
### [alacritty](https://alacritty.org/)
It's a GPU accelerated terminal emulator.
Pretty simple.
But it's super customizable.

Yet this is the one that pissed me off the most.
In all my bitching, I keep mentioning how I'm the problem, and this is the perfect example.
Alacritty, by default, would open up in a small window with a title bar, and I'd go to to fullscreen it with `F11` and it would literally interpret the key as terminal input.
After about 3 days of this I couldn't take it anymore, checked out some documentation, and found that there was so much customization that I wasn't even mad about it.

I think that is part of the beauty of all these free open source tools, and why I am making how idiotic my complaints are so clear.
They have so many options for you to do whatever you want with.
Even if they are missing something you want, there's nothing from stopping you forking the project yourself and creating what you want for yourself, and potentially everyone else too.

~~I yapped so much for the other commands, I had to figure out something to talk about.~~

### [cargo-cache](https://lib.rs/crates/cargo-cache)
Simply use it in the script to clean up, not a whole lot to it. 
Yet to use it outside of the script, haven't found much of a use for it and dua is pretty good.

This is probably the oldest thing here, but hey, if it works.
There's a crate, [cargo-wash](https://lib.rs/crates/cargo-wash) that I should probably check out.
If it has the same feature set I might replace this one.

## possible additions
I could add `gitoxide`, but that kinda falls under the "why though" of the "uutils coreutils" rewrite, especially if I'm using `lazygit` instead of the CLI.
I also don't as frequently use `git` on ALL of machines like I do the other utilities.


--- 

Yes this README in my dotfiles repo is absolutely talking about everything BUT my dotfiles (mostly cause I try to go through and comment in the doftiles for my future self anyways, but the last thing anyone else would want is my config. Instead, I choose to advertise better tools.)
