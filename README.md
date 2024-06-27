<div align="center">
 
# Bubbly

 <img src="https://user-images.githubusercontent.com/59060246/219005943-7ae41569-6a29-4585-8dfd-f8016dcf8fd4.svg" width="250" alt="bubbly logo">
 
</div>

# Notice
The original project is currently incompatible with Ubuntu 22.04. To address this and improve functionality, the following enhancements have been implemented:
- Replaced the 'xinput' method for key detection, as it struggles with identifying BLE keyboards accurately. An alternative approach has been adopted to retrieve keystrokes.
- Abbreviated various keycodes for improved readability and efficiency (e.g., Shift -> Sft, Control -> Ctrl, Up -> '↑').
- Implemented a new termination method: double-pressing 'Ctrl+Esc' now exits bubbly.
- Added a monitor-switching feature for the keystrokes widget, accessible via 'Shift+Ctrl+Alt+<monitor_index>'.
- Enhanced the label widget for each key to auto-expand, preventing text truncation

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
