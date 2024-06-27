<div align="center">
 
# Bubbly

 <img src="https://user-images.githubusercontent.com/59060246/219005943-7ae41569-6a29-4585-8dfd-f8016dcf8fd4.svg" width="250" alt="bubbly logo">
 
</div>

# Notice
Since the original project doesn't work with Ubuntu 22.04 at the moment. The following enhancements were made compared to the original versions:
 - Use another method to get the keys instead of using 'xinput' with $device parameter since it's difficult to get the right keyboard device with BLE keyboard
 - Shorten many keycodes: Shift -> Sft, Control -> Ctrl, Up -> '↑', etc.
 - Press 'Ctrl+Esc' twice to terminate bubbly 
 - Use 'Shift+Ctrl+Alt+<monitor_index>' as the shortkey to switch monitor for the keystrokes widget

## About 

- Bubbly lets you create on-screen chat_bubble like widgets based on the keystrokes you type on the keyboard. It uses xinput to fetch the keys and puts them into an eww widget.

- It has 2 modes :
  - **chat** - Creates onscreen chat like widgets based on the keys you type in the form of sentences.
  - **keystrokes** - Creates onscreen widgets to show keystrokes, something like screenkey, keycaster etc.

## Demo 

### Chat widget

https://user-images.githubusercontent.com/59060246/227874712-1e749a32-ff7e-4a69-abb5-414bff0fb637.mp4

### Keystrokes widget 

https://user-images.githubusercontent.com/59060246/227874881-bbc970e7-869d-4e40-91d7-e7622d2dde1e.mp4

<br/>

full video : https://www.youtube.com/watch?v=JxG1buUmJ2U


## Requirements 

- [eww](https://github.com/elkowar/eww)
- xinput
- dash

## Install

```zsh
curl https://raw.githubusercontent.com/siduck/bubbly/buttons/install.sh | sh
```

## Usage

- Open the bubbly app from your app menu.
