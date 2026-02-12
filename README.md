Simple quickshell confg

<img width="1920" height="72" alt="image_2026-02-10_06-38-38" src="https://github.com/user-attachments/assets/2240765b-040a-443e-b79b-b8a282fc9769" />


## Installation

Just copy /quickshell to ~/.config/quickshell, also you will need to install swaync.
Add this to your hyprland conf and turn on blur in it to better view(only for top tier computers): 

```
layerrule = blur on, match:namespace quickshell
layerrule = blur_popups on, match:namespace quickshell
layerrule = ignore_alpha 0.4, match:namespace quickshell

layerrule = blur on, match:namespace swaync-notification-window
layerrule = blur_popups on, match:namespace swaync-notification-window
layerrule = ignore_alpha 0.35, match:namespace swaync-notification-window

layerrule = blur on, match:namespace swaync-control-center
layerrule = blur_popups on, match:namespace swaync-control-center
layerrule = ignore_alpha 0.35, match:namespace swaync-control-center
```
