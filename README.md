# oma.off

Bar-widget för Omarchy.

- Power-ikon i baren
- Klick öppnar bekräftelseruta
- Klick på den stora knappen kör `omarchy-system-shutdown`

## Installera

```bash
mkdir -p ~/.config/omarchy/plugins/oma.off
git clone https://github.com/nmlit/oma.off.git ~/.config/omarchy/plugins/oma.off
omarchy plugin validate ~/.config/omarchy/plugins/oma.off
omarchy plugin enable oma.off --section right
```

Eller:

```bash
omarchy plugin add https://github.com/nmlit/oma.off.git --enable
```

Om ikonen saknas:

```bash
omarchy restart shell
```

## Ta bort

```bash
omarchy plugin remove oma.off
```
