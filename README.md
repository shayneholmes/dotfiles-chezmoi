# Dotfiles

## Setup instructions
```
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply https://github.com/shayneholmes/dotfiles-chezmoi.git
```

## Manual operations


### Change home directory name if desired

Courtesy of http://osxdaily.com/2016/12/02/change-user-home-folder-mac/

1. create a temporary admin user
2. Log into that account
3. Move the home folder
4. Change the main account's home folder (advanced options)

### Change system login keyboard layout

https://leons.im/posts/resetting-default-input-method-in-mac-os/

### Install other apps

- Flycut: https://github.com/TermiT/Flycut/releases
- FreeMind: http://freemind.sourceforge.net/wiki/index.php/Download
- Grand Perspective: http://grandperspectiv.sourceforge.net/
- Itsycal: https://www.mowglii.com/itsycal/
- Karabiner: https://pqrs.org/osx/karabiner/
- Notational Velocity: https://brettterpstra.com/projects/nvalt/#dl
- OBS: https://obsproject.com/
- Plover: http://www.openstenoproject.org/plover/
- VLC: https://www.videolan.org/vlc/
- Finicky: https://github.com/johnste/finicky/releases/

### App store apps

- SwiftoDo

### Add calendar account

### Configure hammerspoon command-line

https://www.reddit.com/r/hammerspoon/comments/10v59ln/having_issues_with_hsipccliinstall/

```sh
cd ~/bin; ln -s /Applications/Hammerspoon.app/Contents/Frameworks/hs/hs .
```

### Fix bitbar rendering

sudo /usr/bin/pip3 install pillow

### Set up recurring tasks:

- Note sync (nvAlt -> repo)
- Regular duplicacy backups

### Set up tmux in terminal

Set all terminals to run "tmux attach-session -t main"
