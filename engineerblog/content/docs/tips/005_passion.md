---
title: "Spark Passion"
weight: 500
date: 2023-11-15T01:47:46+07:00
---

# Spark Your Passion

## Server Monitoring

### Htop

- A lightweight, no-frills process manager for resource-constrained environments or terminal purists

![htop](/tips/passion/htop.png)

```sh
# Install
apt install htop
# Run 
htop
```

### Btop

- A feature-rich, visually enhanced monitoring experience where modern aesthetics and detailed insights matter

![btop](/tips/passion/btop.png)

```sh
# Install
apt install btop
# Run  
btop
```

## Termial Custom

|    Before    |    After    | 
|:------------:|:-----------:|
| ![terminal-origin](/tips/passion/terminal-origin.png) | ![terminal](/tips/passion/terminal.png) |

### Oh My Zsh

- A framework for managing the configuration of the Zsh

```sh
# Install Zsh
apt install zsh
# Install Oh My Zsh using curl
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
# Switch to Zsh (if not already the default shell)
chsh -s $(which zsh)
# Restart your terminal
```

### Agnoster theme

```sh
# Download necessary font
apt install fonts-powerline
# Edit file .zshrc (zsh config)
vim ~/.zshrc
# Change theme to agnoster (inner file .zshrc)
ZSH_THEME="agnoster"
```

### Plugins

#### [Auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#zsh-autosuggestions)

![auto_suggestions](/tips/passion/auto_suggestions.png)

```sh
# Download plugin
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# Edit file .zshrc (zsh config)
vim ~/.zshrc
# Add plugin name (inner file .zshrc)
plugins=(
    git 
    zsh-autosuggestions
)
```

#### [Syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting?tab=readme-ov-file#zsh-syntax-highlighting-)

![syntax_highlighting](/tips/passion/syntax_highlighting.png)

```sh
# Download plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# Edit file .zshrc (zsh config)
vim ~/.zshrc
# Add plugin name (inner file .zshrc)
plugins=(
    git 
    ...
    zsh-syntax-highlighting
)
```

## Cmatrix

- Emulate the digital rain effect seen in the movie **The Matrix**

![cmatrix](/tips/passion/cmatrix.png)

```sh
# Install
apt install cmatrix
# Run  
cmatrix
```

## Vscode Custom

### Power Mode extension

- Add visual effects and animations as you type

![power_mode](/tips/passion/power_mode.gif)

- Install extension name: `Power Mode`
- ID: `hoovercj.vscode-power-mode`

```sh
# Open file setting.json of vscode
vim ~/.config/Code/User/settings.json
```

```json
// settings.json
{
    // Other settings
    "powermode.enabled": true,
    "powermode.maxExplosions": 10,
    "editor.codeActionsOnSave": null,
    "powermode.explosions.size": 15,
    "powermode.explosions.frequency": 2,
    "powermode.explosions.offset": 0.215,
    "powermode.explosions.customExplosions": [
        "https://media.giphy.com/media/sLMRyFR4eIEgnFe4mK/giphy.gif",
        "https://media.giphy.com/media/RFvv2miX3KHcOkBwns/giphy.gif",
        "https://media.giphy.com/media/8Hw8ei9OiUXIUlHEBy/giphy.gif"
    ],
    "powermode.explosions.backgroundMode": "mask",
    "powermode.explosions.gifMode": "restart",
    "powermode.explosions.explosionOrder": "sequential",
    "powermode.explosions.duration": 1000,
    "powermode.explosions.customCss": {
        "mix-blend-mode": "color-dodge"
    },
    "powermode.shake.enabled": false
}
```

### Todo Tree extension

- This extension quickly searches your workspace for comment tags like **TODO** and **FIXME**, and displays them in a tree view in the activity bar

![todo](/tips/passion/todo.png)

- Install extension name: `Todo Tree`
- ID: `Gruntfuggly.todo-tree`

## References

- Github: [Power mode setup templates](https://github.com/hoovercj/vscode-power-mode/issues/1)
- Scottspence: [My Zsh Config](https://scottspence.com/posts/my-zsh-config) (April 14th, 2022)