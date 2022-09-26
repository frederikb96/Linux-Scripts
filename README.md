# Linux-Scripts
Some linux scripts I use

## Notes to myself

- Link the bin folder to ~/.local/bin/my-bin
  - add this path to your .profile

```
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin/my-bin" ] ; then
    PATH="$HOME/.local/bin/my-bin:$PATH"
fi
```

- Link the applications folder you want to use to something like ~/.local/share/applications/my-applications
- **not working** the icons folder to ~/.local/share/icons/my-icons
- Link unison to ~/.unison/my-profiles
  - call unison profiles with `unison my-profile/my-profile-name.prf`
- Link templates to ~/Templates/my
- Link tikzit to ~/Programs/tikzit/my-tikzit

