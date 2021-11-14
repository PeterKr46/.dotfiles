# Dependencies

> dunst

I use `dunst` for desktop notifications.
`volume.sh` and `brightness.sh` directly depend on the `pango` features available in `dunst`, switch from `pango_bar` to `bar` for more generic versions...

> libnotify-bin

dunst is, for the most part, controlled by `notify-send`.

> rofi

I use `rofi` as a `dmenu` substitute

> network-manager

Some scripts use `nmcli`

> playerctl

Media players are controlled via `playerctl`

> alsa-utils

Volume is controlled via `amixer`

> maim

Screenshots are taken via `maim`

> fonts-ubuntu

I use the Ubuntu font family a lot...

> i3blocks

Allows me to slap together my own `i3status` replacement (: