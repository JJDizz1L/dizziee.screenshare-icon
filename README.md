# dizziee.screenshare-icon

Shows an indicator in the Omarchy bar when screen sharing is active via PipeWire portals.

## Installation

```sh
omarchy plugin add https://github.com/JJDizz1L/dizziee.screenshare-icon.git --enable
```

### Then place it in your bar layout with
`omarchy bar plugin add dizziee.screenshare-icon [--section <left|center|right>]`</br>

Suggested placement:
```
omarchy bar plugin add dizziee.screenshare-icon --section right
```

You can validate the plugin at any time with:

```sh
omarchy plugin validate ~/.config/omarchy/plugins/dizziee.screenshare-icon
```

## Updating

To pull the latest version of the plugin:

```sh
omarchy plugin update dizziee.screenshare-icon --yes
```

## Configuration

Configuration lives in `~/.config/omarchy/shell.json`.

No configurable options.

## Preview

![preview](preview.png)

## Uninstall

```sh
omarchy plugin remove dizziee.screenshare-icon
```

## License

MIT
