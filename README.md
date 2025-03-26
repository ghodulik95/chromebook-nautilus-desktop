# So you want to install Linux on your Samsung Chromebook Plus v2 (codename Nautilus)?

I did too! Thankfully it is totally doable, and I've created this project to more easily set up your desktop environment once you do. This project and its contents should assure you that installing Linux can be done without bricking your device, and you will still have (almost) the full functionality of your old Chromebook, plus all the functionality and speediness of Linux.

## Limitations

__The only serious limitations to Linux on your Samsung Chromebook Plus v2 are: 1) Your speakers will not work, 2) Your microphone will not work, and 3) Your AUX-input will not work! 4) Tablet camera does not work (but normal webcam facing camera does). If any of these are absolute dealbreakers*, you may want to stick with ChromeOS :(__

Bluetooth works great though for audio and mic. For me, Bluetooth is working way way better than it ever did on ChromeOS (it was nearly unuseable in the end).

<details>
  <summary>* You're not necessarily SOL, though. </summary>
  
  [This script by WeirdTreeThing](https://github.com/WeirdTreeThing/chromebook-linux-audio?tab=readme-ov-file) is supposed to work on Ubuntu 24.10 and some other supported distros, and therefor e might work on Xubuntu. HOWEVER, it has a known issue of busting the speakers PERMANENTLY on the Samsung Chromebook Plus v2 when used on high volume settings. Still, this script might work to fix your microphone or AUX-IN. I personally tried running it once when using NixOS and it did not work so I gave up. I have been content with Bluetooth on Xubuntu so for the moment I do not plan to try and further fix the audio.
</details>

## Included Features of this project

The contents of this project will allow you to use Linux (specifically Xubuntu) without having to forego these features you might have enjoyed while running ChromeOS:  

1. Functional F1-F10 row that does original Chromebook functions
	- Xubuntu, and probably most Linux distros, is going to recognize these keys as F1-F10, rather than 
		- Back
		- Forward
		- Refresh
		- Fullscreen
		- Window manage
		- Minus brightness
		- Plus brightness
		- (Un)Mute
		- Minus volume
		- Plus volume
		- Screen Lock
2. Tablet mode
	- Note that this is not a full featured tablet mode, but this will disable the keyboard on tablet mode, and re-enable it when going back to laptop mode. You could probably customize a better tablet mode fairly easily though if you want to.
3. Swipe navigation
	- I really liked swipe for browser back-foreward functions on ChromeOS. And this is possible on Linux, albeit I could only get 3-finger swiping to work instead of 2-finger swiping.
4. Bluetooth headphone/headset toggle
	1. While Bluetooth works great, applications don't necessarily auto-toggle between headphones/headset mode, so included is a script that will do this toggle with toggler (by default with hotkeys Ctrl+Alt+h)
5. Tap to click from mousepad.
	
## What is not included in this documentation

While I will include a light summary on the Linux install process, and why I decided to settle on Xubuntu over other distros I tested, I will not be supplying a detailed guide. [MrChromebox](https://docs.mrchromebox.tech/) has already done an excellent job of that!

__DISCLAIMERS: As is well communicated in the MrChromebox documentation, installing Linux on a Chromebook, and specifically the Samsung Chromebook v2 Plus (codename Nautilus), is an involved process that will 1) void warranties and 2) carry risk of bricking your device. Proceed with caution on that.__

But once Xubuntu is installed, the stuff in this project should not carry more risk of bricking your device than tweaking stuff in Linux does in general.

# Background/Prerequisites

## Who is this for?

I tailored this project for the former use cases of what I used my Samsung Chromebook Plus v2 for: easy browsing, prioritizing the experience for the main user. A lot of the tricks I use are specific to the logged in user - modifications would need to be made to make these work at the whole system level. You could also just install all this stuff for each user.

If your goal is to be a power-user, high-fidelity/security user, multi-user machine, and/or you already have tons of specific desktop preferences that deviate significantly from ChromeOS, you may not appreciate this project. Still, it might be useful for you as simple confirmation that Linux can run on your device! And you might still want to read my notes on Why Xubuntu. 

## Why Xubuntu?

The short answer is that Xubuntu is lightweight and I found that most hardware worked out-of-the-box with Xubuntu compared to other distros I tried. Specifically, Bluetooth, Wifi, and the webcam all worked out-of-the-box more or less with Xubuntu.

My hope was to be able to run NixOS, but after working on the audio for a few hours and then realizing Bluetooth did not work out-of-the-box, I began searching for other distros that would work better right out-of-the-box.

I tried:

- Fedora KDE
- Manjora XFCE
- NixOS Plasma
- Vanilla Puppy Linux (I had a Puppy Linux phase in high school so I thought I'd try it out)
- Xubuntu

I unfortunately cannot remember exactly what worked out-of-the-box with all of these. I am pretty sure that Wifi also worked on Fedora, Manjora, NixOS, and not Puppy. Speakers were not found on any of them. I did not test cameras. Wifi didn't work on Puppy. Bluetooth was finicky on NixOS, though some of the audio stuff I tried was probably responsible for that - I never actually got to testing a connection. I don't think Bluetooth worked for both Manjora and Fedora, but it might have for one of them. Some did not easily support tap-to-click on the mousepad but I didn't earnestly try to enable it on each.



## Summary of setting up Chromebook for Linux install

The good news is that you do not need any specialized hardware or tools for this. You'll want to __thoroughly__ read through MrChromebox's [documentation](https://docs.mrchromebox.tech/docs/getting-started.html) before getting in too deep. SPOILER: You will have to do some dissambley of your device to disable hardware firmware write protection, and you will have to wipe your device to enable developer mode.

You can alternatively dual boot ChromeOS and Linux via RW_LEGACY firmware, which should not require disassembly ro disable hardware firmware write protection. However, I had no interest in this since ChromeOS was becoming unusable for me. So I opted fully install UEFI.

I can confirm for you that as of writing this, The Samsung Chromebook Plus v2 (codename Nautilus) has [UEFI support](https://docs.mrchromebox.tech/docs/supported-devices.html), however you'll want to verify on your end that your device is definitely a Nautilus. You should be able to do this by going to [chrome://version]() in Chrome. If it is not a Nautilus, your device may still be supported but I'm not sure how much of this guide will be applicable to you.

First, you'll enable developer mode, which will wipe your device and boot you into developer mode - which looks a bit different than your desktop probably. If you are still seeing your desktop you are probably not in Developer Mode.

You will then have to disable write-protection at the hardware level by disconnecting the battery. Of course make sure you are powered off when you do this. This does mean opening up the bottom of the chromebook, but you will not need to do further disassembly. - Then you can boot up while plugged in and running  while plugged in - note that you will need an appropriate charger for this - my higher-powered charger from my other laptop did not work and I had to use a Google proprietary USB-C with wall adapter - I'm sure there are other adapters that work but one that works to charge your chromebook battery will not necessarily work for this. If your device doesn't boot while plugged into your usual charger, do not fret as most likely you just need a different charger. You can look at the first minute of [this video](https://www.youtube.com/watch?v=dKZEH0U9Mto) for guidance on the disassembly.

Then, you'll run the MrChromebox firmware utility script. You will want a USB-C flash storage for this, so that you can make a backup of your ChromeOS install (If all goes well, you will not need to use this. But if all does not go well and you do not make this backup, it may be __significantly__ harder to fix your situation.). The firmware utility script will need to reboot once to disable the firmware write protection, then you can install the UEFI ROM firmware.

If you read this far but neglected to read any of MrChromebox's documentation, YOU ARE NOT RESPONSIBLY PREPARED YET TO INSTALL THE NEW FIRMWARE. This is not meant to be a full guide, but just a slight tailoring of MrChromebox's guide to the Nautilus.

# Project overview

## How to install
0. Install Xubuntu by flashing to .iso to a USB-C flash drive device and running through the UEFI Boot menu.
	- I opted to not force strong passwords and allow passwordless login at startup. I am not 100% sure whether this is required or not for some of the project to work.
1. Download the source code
	1. Clone the git repo
		- If git is not installed, install with `sudo apt install git`
	2. OR download the .zip and unzip it
2. In the project root directory, install necessary packages with 
	- `sudo xargs -a packages.txt apt install -y`
3. Copy the project files into your home directory.
	- `rsync -av --exclude 'README.md' --exclude 'packages.txt' path-to-git-repo-code/ ~/`
4. Make the relevant files executable:
	 1. `chomd +x ~/bin/tablet-mode-handler.sh`
	 2. `chmod +x ~/bin/toggle-headset-mode.sh`
5. Enable passwordless sudo for the tablet-mode-handler.sh script and brightnessctl
	- `your-username ALL=(ALL) NOPASSWD: /home/your-username/bin/tablet-mode-handler.sh`
	- `your-username ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl`
6. Add keyboard shortcut for toggling Bluetooth Headphone/Headset
	1. Use command `xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Primary><Alt>h" -n -t string -s "bin/toggle-headset-mode.sh"`
	2. OR, manually navigate to Keyboard > Application Shortcuts > Add, and make the command `bin/toggle-headset-mode.sh` and set it to keys Ctrl+Alt+h, or a keymapping of your choice.


## Packages needed to install
The following packages will be installed by

- brightnessctl
	+ Allows for changing screen brightness via terminal
- Touché (touchegg)
	+ Used for sensing 3-finger gesture controls.
	+ Config file at `.config/touchegg/touchegg.conf` can be modified for different gesture controls
- xbindkeys
	+ Handles some key-binding for F-row keys that XModMap could not handle
- xdotool
	+ Handler for some key-binding
- grep
	+ Used in some of the bin/ scripts
- google-chrome-stable
	+ The stable version of Google Chrome
	
## Overview of files byt functionality

### Autostart Applications

These `.desktop` files live in `~/.config/autostart/` and are automatically launched when the user logs in:

- **`Tablet Mode Toggle.desktop`**  
  Listens for tablet mode (using the script in /bin) and disables the keyboard when tablet mode is enabled. 

- **`XModMap.desktop`**  
  Runs `xmodmap` in the background on startup, using the configuration at `.config/keyboardmapping/.Xmodmap`. Handles some F-row key remappings including: Back, Forward, Audio Mute, Volume Down, Volume Up, and maps the Lock key to Delete. Other F-row mappings are handled by xkeybind

- **`touchegg.desktop`**  
  Starts the `touchegg` daemon in the background at login to enable multitouch gesture support.

## Input and Gesture Configuration

- **`.config/keyboardmapping/.Xmodmap`**  
  Configuration of Xmodmap that handles F-row key remappings including: Back, Forward, Audio Mute, Volume Down, Volume Up, and maps the Lock key to Delete.

- **`.xbindkeysrc`**  
  Handles additional F-row key mappings that were incompatible with `xmodmap`.  
  These include:
  - Brightness Up/Down  
  - Refresh  
  - Fullscreen  
  - Window Manager key (mapped to fullscreen screenshot)

- **`.config/touchegg/touchegg.conf`**  
  Configures swipe gestures with `touchegg`:
  - 3-finger swipe up: maximize window  
  - 3-finger swipe down: minimize window  
  - 3-finger swipe right: send `Alt_L` (Back in browsers)  
  - 3-finger swipe left: send `Alt_R` (Forward in browsers)  
  - Includes Chrome-specific settings for pinch-to-zoom gestures.
  - Includes some touche default settings.


## Application Shortcuts

- **`.local/share/applications/google-chrome.desktop`**  
  A modified Chrome launcher that adds the `--disable-features=KeyboardShortcutViewer` flag to prevent interference with F-row remappings.

## Custom Scripts

- **`tablet-mode-handler.sh`**  
  Contains the logic for monitoring tablet mode status and enabling/disabling the keyboard accordingly.

- **`toggle-headset-mode.sh`**  
  Toggles a connected Bluetooth headset between **headphones** and **headset** mode. Headset mode enables microphone input but typically reduces audio quality.
  
- **`detect-webcam.sh`**
	+ This script is not strictly necessary for basic webcam usage, as your web browser will sense the camera fine. It is disabled by default. However, the /dev/video path of the webcam can change from boot to boot, so this script links the correct device path to /dev/webcam at boot. This could be useful if you ever want to automate something with your webcam.

## Webcam notes

You can confirm the detect webcam script works after running it (may need to make it executable first), and using the command `guvcview -d /dev/webcam`. If the command opens a your camera feed without further prompting, it works, and /dev/webcam links to your webcam, and should across boots if the startup script is enabled. Note that you can also use cheese and ffplay to test your camera is working, but specifying the device/device link doesn't seem to work wtih cheese and ffplay.

