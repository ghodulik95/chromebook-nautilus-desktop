# Installing Linux on a Samsung Chromebook Plus v2 (codename Nautilus)

If you want to run Linux on your Samsung Chromebook Plus v2, you’re in luck—it’s absolutely possible! This project provides a convenient setup for a working **Xubuntu** desktop environment that replicates many Chromebook conveniences (minus some hardware limitations). It was not tested on other distros or desktops.

Installing Linux on this Chromebook (and many Chromebooks) can be more involved than on a typical PC because you must replace or modify the original firmware for UEFI boot. However, once that’s done and Xubuntu is installed, you’ll enjoy (almost) the full functionality of your old Chromebook plus the power and speed of a Linux system. Even the stylus works great with Krita and Xournal++.

---

## Table of Contents

1. [Limitations](#limitations)  
2. [Features of This Project](#features)  
3. [What’s Not Included](#whats-not-included)  
4. [Disclaimers](#disclaimers)  
5. [Quick Start](#quick-start)  
6. [Installation & Setup Steps](#installation)  
7. [Project File Overview](#project-file-overview)  
8. [Troubleshooting](#troubleshooting)  
9. [Webcam Notes](#webcam-notes)  
10. [Who This Project Is For & Distro Observations](#who-is-this-for)  
11. [Performance Notes](#performance-notes)  
12. [UEFI Firmware Installation (Non-Comprehensive Summary)](#uefi)

---

<a name="limitations"></a>
## 1. Limitations

While Linux can run very well on the Samsung Chromebook Plus v2, there are significant hardware limitations to note:

1. **Speakers do not work**  
2. **Microphone does not work**  
3. **AUX input does not work**  
4. **Tablet-facing camera does not work** (though the regular “webcam” camera does)

If you rely on internal audio or a built-in mic, this may be a dealbreaker.  

> **Bluetooth Audio Workaround**  
> - Headphone and microphone modes work great via Bluetooth.  
> - Anecdotally, Bluetooth under ChromeOS had become nearly unusable for me—failing to connect to most devices. Under Xubuntu, Bluetooth has been rock-solid and easily connects to all my devices.

<details>
  <summary>Could the audio issues be fixable?</summary>

  [WeirdTreeThing’s audio script](https://github.com/WeirdTreeThing/chromebook-linux-audio?tab=readme-ov-file) can fix audio on some Chromebooks. However, there’s a risk of permanently damaging the speakers at high volumes on this model. I tried it once on NixOS with no success and decided not to pursue further. If you need internal mic or AUX input, feel free to explore it—but proceed with caution. Xubuntu is not officially supported but Ubuntu 24.10 is.
</details>

---

<a name="features"></a>
## 2. Features of This Project

This repository helps you keep some of the conveniences you had in ChromeOS:

1. **Functional F1–F10 Row**  
   - Restores the top-row keys to Chromebook roles (Back, Forward, Refresh, Fullscreen, etc.).

2. **Tablet Mode**  
   - Disables the keyboard automatically when the screen is folded into tablet position, then re-enables it afterward.

3. **Swipe Navigation**  
   - Implements 3-finger swipes for browser back/forward (mimicking ChromeOS-style gestures).

4. **Bluetooth Headphone/Headset Toggle**  
   - Quickly switch between high-quality audio (“headphone”) and mic-enabled (“headset”) modes.

5. **Tap-to-Click & Natural Scrolling**  
   - Makes the touchpad behave more like ChromeOS.

---

<a name="whats-not-included"></a>
## 3. What’s Not Included

- **Firmware Installation Steps**  
  I do not provide detailed instructions for flashing or replacing the Chromebook’s firmware. For that, refer to [MrChromebox’s documentation](https://docs.mrchromebox.tech/).

- **Full Xubuntu Installation Tutorial**  
  Once UEFI boot is enabled, installing Xubuntu is similar to any standard PC. I won’t provide every step here.

- **System-Wide or Power-User Customizations**  
  These configs focus on replicating a ChromeOS-like, single-user experience. If you want multi-user or heavily locked-down setups, you can adapt these scripts as needed.

---

<a name="disclaimers"></a>
## 4. Disclaimers

### 4.1. Warranties & Risk of Bricking
Modifying the Chromebook firmware and installing Linux on this device can void your warranty and carries an inherent risk of bricking.

### 4.2. Known hardware limitations and risks
I'll repeat here: Speakers, AUX-IN (headphone jack), Microphone, and tablet-facing camera do not work. Workarounds on the speakers are specifically known to potentially cause permanent damage. See [Limitations](#limitations).

### 4.3. My attempts at addressing the hardware limitations
While I put in *some* effort to get the speakers, headphone jack, and microphone to work, I put in zero effort at getting the tablet camera to work. You might have more luck than me, finding an easy workaround. I suspect that many of these limitations will be a more involved process to work around, however, so I would not recommend proceeding if any of that hardware is essential to you and you don't have the time and/or skill to sort it out.

---

<a name="quick-start"></a>
## 5. Quick Start

Here’s a high-level outline of the key setup steps. For more specific instructions and commands, see the Installation section.

1. **Clone or Download This Project**  
   - Either `git clone https://github.com/ghodulik95/chromebook-nautilus-desktop.git` or download the ZIP to your new Xubuntu install.

2. **Install Required Packages**  
    
    cd path/to/project
    sed '/^\s*#/d;/^\s*$/d' packages.txt | xargs sudo apt install -y


3. **Copy Project Files to Your Home Directory**  

    rsync -av --exclude 'README.md' --exclude 'packages.txt' path-to-project/ ~/


4. **Make Scripts Executable**  

    chmod +x ~/bin/tablet-mode-handler.sh
    chmod +x ~/bin/toggle-headset-mode.sh
    chmod +x ~/bin/detect-webcam.sh


5. **Enable Passwordless Sudo (Optional)**  
   - Add entries in `sudo visudo` if you need the tablet-mode or brightness scripts to run without password prompts (or potentially at all).

6. **Reboot & Validate**  
   - Flip the screen to test tablet-mode.  
   - Confirm the top-row keys work as expected.  
   - Test gestures, brightness, and Bluetooth audio if you configured them.  

For more in-depth instructions and caveats, consult the detailed sections of this README.

---
<a name="installation"></a>
## 6. Installation & Setup Steps

These steps assume you’ve already replaced the Chromebook’s firmware with something UEFI-capable (e.g., via MrChromebox scripts).

### 6.1. Install Xubuntu

1. **Flash Xubuntu to a USB-C stick**  
2. **Boot via UEFI**  
3. **Install Xubuntu** as you would on any PC.

*I am using Xubuntu 24.04.2 LTS (Noble Numbat)*

### 6.2. (Optional, but Recommended) Enable Tap-to-Click & Natural Scrolling

By default, Xubuntu’s GUI may not expose these settings. To enable them:

    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo nano /etc/X11/xorg.conf.d/40-touchpad.conf

Paste:

    Section "InputClass"
        Identifier "Touchpad defaults"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "NaturalScrolling" "true"
    EndSection

Save and reboot/logout and back in.

### 6.3. Add google-chrome ppa repository

    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg

    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

    sudo apt update

### 6.4. Download/Clone This Project

Download the .zip, or clone the git repository:

1. Install Git if needed:
    
        sudo apt install git

2. Clone the repo (or download a `.zip`):
    
        git clone https://github.com/ghodulik95/chromebook-nautilus-desktop.git

### 6.5. Install Required Packages

In the project root directory:

    sed '/^\s*#/d;/^\s*$/d' packages.txt | xargs sudo apt install -y

**Installs:**
- `brightnessctl=0.5.1-3.1`  
  + For brightness controls
- `grep=3.11-4build1`  
  + Used in some scripts
- `xbindkeys=1.8.7-2`  
  + For keymapping Xmodmap does not handle well
- `xdotool=1:3.20160805.1-5build1`  
  + For certain keymapping commands
- `libinput-tools=1.25.0-1ubuntu2`
  + For detecting tablet-mode event emitting hardware
- `google-chrome-stable` (from official Google repository)  
- **Touché** (the `touchegg` package from PPA or Ubuntu repo)  
  + For multi-touch gesture commands

*Note: Specifying exact package versions is probably unnecessary. However, the internet tells me that some versions of xbindkeys do not add an autostart rule by default, so if the default package does not do this you may need to manually add an autostart rule that runs xbindkeys.*

#### Alternative: Single-line install command

With version specifications:
    
    sudo apt install -y brightnessctl=0.5.1-3.1 grep=3.11-4build1 xbindkeys=1.8.7-2 xdotool=1:3.20160805.1-5build1 libinput-tools=1.25.0-1ubuntu2 google-chrome-stable touchegg

Without version specifications:
    
    sudo apt install -y brightnessctl grep xbindkeys xdotool libinput-tools google-chrome-stable touchegg

### 6.6. Copy Project Files to Your Home Directory

    rsync -av --exclude 'README.md' --exclude 'packages.txt' path-to-project/ ~/

**What’s Being Copied?**  
- **Configuration files** for keyboard mapping, gesture handling, and autostart scripts  
- **Desktop files** for autostart (like tablet mode handling, XModMap, etc.)  
- **Custom shell scripts** (for toggling headset mode, linking webcam device, etc.)

You can see a deeper breakdown in [Section 7](#project-file-overview). The autostart `.desktop` files go into `~/.config/autostart/`. If you decide you don’t want one of these services running at login, open **Session and Startup** (in the Xubuntu Settings GUI) and uncheck or remove the relevant entry.

### 6.7. Make Relevant Scripts Executable

    chmod +x ~/bin/tablet-mode-handler.sh
    chmod +x ~/bin/toggle-headset-mode.sh
    chmod +x ~/bin/detect-webcam.sh

### 6.8. Enable Passwordless Sudo

You need passwordless sudo for:

- `tablet-mode-handler.sh` (managing tablet mode)  
  + The tablet event id can change across boots, so sudo is needed to read the device list from libinput.
- `brightnessctl` (adjusting screen brightness)  
  + This software appears to require sudo privileges.

Use:

    sudo visudo

Then add lines like (replacing your-username 3 times with your username):

    your-username ALL=(ALL) NOPASSWD: /home/your-username/bin/tablet-mode-handler.sh
    your-username ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl

### 6.9. (Optional, but Recommended if you'll be making video calls) Add Keyboard Shortcut for Bluetooth Headset Toggle

    xfconf-query \
      -c xfce4-keyboard-shortcuts \
      -p "/commands/custom/<Primary><Alt>h" \
      -n -t string -s "bin/toggle-headset-mode.sh"

Or do this in **Keyboard > Application Shortcuts**.

> **Note**: Some applications may automatically toggle your headphones into headset mode (mic enabled) without any manual intervention. However, if you plan to use headphones in video calls and don’t see an auto-toggle, this script plus a shortcut can be handy.

### 6.10. Log out and back in, or reboot.

Confirm everything is working:

- Flip into tablet mode. You should get a notification and you can confirm the keyboard is disabled and re-enabled when you exit tablet mode.
- Open chrome normally, and you can test the 3-finger swiping for back and forward, and the top row keys for back, forward, refresh, and fullscreen.
- Test brightness and volume keys.
- Confirm the "lock" key actually is "Delete".
- Test bluetooth headset audio toggle (Ctrl+Alt+h if using default keymapping).
- If using the detect-webcam script, you can test with `guvcview -d /dev/webcam` (requires installing guvcview).
- Test that the window manage key captures a screenshot to clipboard.
- Confirm tap-to-click, 2-finger tap right-click, and 2-finger natural scrolling works.

<a name="project-file-overview"></a>
## 7. Project File Overview

All the copied files in `~/` after installation serve different roles, but they can be grouped as follows:

### 7.1 Autostart, Input, and Custom Scripts

1. **Autostart Desktop Files** (`~/.config/autostart/`)  
   - **`Tablet Mode Toggle.desktop`**  
     - Runs `bin/tablet-mode-handler.sh` at login, automatically enabling/disabling your keyboard when you fold the screen.  
   - **`XModMap.desktop`**  
     - Applies `.config/keyboardmapping/.Xmodmap` to restore top-row keys (Back, Forward, Mute, Volume, etc.).  
   - **`touchegg.desktop`**  
     - Starts the Touché daemon (the `touchegg` package) to enable multi-finger gestures.  
   - **`webcam-link.desktop`**  
     - (Disabled by default, as most users probably won't need this) Runs `detect-webcam.sh` on login, creating a stable `/dev/webcam` symlink.
   
   *(Also, xbindkeys may add its own autostart; if not, you’d need to do so manually.)*

2. **Input Config & Gesture Mapping**  
   - **`.config/keyboardmapping/.Xmodmap`**  
     - Remaps many F-row keys to their Chromebook counterparts.  
     - Lock button is mapped to delete instead.
   - **`.xbindkeysrc`**  
     - Handles keys that `xmodmap` can’t, like brightness.  
     - The window manage key is set to screenshot to clipboard.
   - **`.config/touchegg/touchegg.conf`**  
     - Defines gesture mappings (e.g., 3-finger swipes for browser back/forward, minimize, maximize).

3. **Custom Scripts** (`~/bin/`)  
   - **`tablet-mode-handler.sh`**  
     - Detects and toggles keyboard off/on in tablet mode.  
   - **`toggle-headset-mode.sh`**  
     - Switches a Bluetooth device between headphone (A2DP) and headset (HSP/HFP) with mic enabled.  
   - **`detect-webcam.sh`**  
     - Creates a symlink `/dev/webcam` to your actual camera device (which can vary from boot to boot). Used by the (disabled) `webcam-link.desktop`.

### 7.2. Modified Google Chrome Desktop Launcher

- **`.local/share/applications/google-chrome.desktop`**  
  - Adds `--disable-features=KeyboardShortcutViewer` so Chrome doesn’t hijack top-row keys.  
  - **Important**: If you launch Chrome without this parameter, many of the top-row key mappings will break, because Chrome intercepts those keys. It's likely that Chromium also needs this flag.

### 7.3 Tabular summary of scripts and config files

| **File/Directory**                            | **Purpose**                                                                                                                                  | **Optional or Required?**                          |
|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------|
| `~/.config/autostart/Tablet Mode Toggle.desktop` | Launches `~/bin/tablet-mode-handler.sh` at login to auto-enable/disable the keyboard in tablet mode.                                         | Recommended if using the convertible touchscreen   |
| `~/.config/autostart/XModMap.desktop`        | Applies `.config/keyboardmapping/.Xmodmap` for Chromebook-like top-row keys (Back, Refresh, Volume, etc.).                                   | Highly recommended for Chromebook key layout       |
| `~/.config/autostart/touchegg.desktop`       | Starts **Touché** (the `touchegg` daemon) at login, enabling multi-finger gestures (e.g., 3-finger swipes to navigate).                      | Recommended if you want gestures                   |
| `~/.config/autostart/webcam-link.desktop`    | (Disabled by default) Runs `detect-webcam.sh` to create a stable `/dev/webcam` symlink.                                                      | Optional — if your camera device number changes    |
| `~/.config/keyboardmapping/.Xmodmap`         | Remaps F-row keys to Chromebook equivalents, including making the "lock" key act as Delete.                                                 | Required for full Chromebook-like key behavior     |
| `~/.xbindkeysrc`                             | Handles brightness, screenshot, and other bindings that Xmodmap alone doesn’t cover.                                                         | Highly recommended                                  |
| `~/.config/touchegg/touchegg.conf`           | Defines gesture mappings (e.g., 3-finger swipes for browser back/forward, minimize, maximize).                                               | Optional if you don’t want gesture support         |
| `~/bin/tablet-mode-handler.sh`               | Detects tablet folding events (via libinput) and toggles the keyboard on/off automatically.                                                  | Required for seamless tablet-mode functionality    |
| `~/bin/toggle-headset-mode.sh`               | Toggles Bluetooth device mode between headphone (A2DP) and headset (HSP/HFP) with mic enabled.                                               | Optional — only if you use BT headphones + mic     |
| `~/bin/detect-webcam.sh`                     | Finds the correct camera device (e.g., `/dev/video2`, this can vary across boots) and symlinks it to `/dev/webcam`.                                                      | Optional                                           |
| `~/.local/share/applications/google-chrome.desktop` | Custom Chrome launcher with `--disable-features=KeyboardShortcutViewer` to prevent Chrome from stealing top-row keys.                          | Recommended for Chrome users                       |

---

<a name="troubleshooting"></a>
## 8. Troubleshooting

Below are some issues you could run into.

### 8.1 Brightness Keys Not Working

- **Check if `xbindkeys` is running**  
    pgrep -laf xbindkeys  
  If there’s no output, try `xbindkeys` manually or create a `.desktop` file in `~/.config/autostart/` to start it.

- **Test Manual Brightness**  
    brightnessctl s 50  
  If you can set brightness manually, your bindings or permissions may be misconfigured.

### 8.2 Tablet Mode Doesn’t Disable the Keyboard

- **Ensure `tablet-mode-handler.sh` is executable**  
    chmod +x ~/bin/tablet-mode-handler.sh

- **Check Sudoers**  
  If the script runs commands needing sudo (like `libinput debug-events`), confirm you’ve set `NOPASSWD:` for your username.

### 8.3 No Speaker or AUX Audio

- **Known Device Limitation**  
  The internal speakers, microphone, and AUX input don’t work out-of-the-box on the Samsung Chromebook Plus v2. Use Bluetooth or attempt advanced fixes at your own risk.

### 8.4 Multi-Finger Gestures Not Working

- **Confirm Touché Daemon**  
    touchegg --debug  
  Check if gestures are detected. If not, verify that `~/.config/touchegg/touchegg.conf` is loaded and `touchegg.desktop` is enabled on startup.

### 8.5 Webcam Issues

- **Check Video Devices**  
    ls /dev/video*  

- **Test with GUVCView or Cheese**  
    guvcview -d /dev/video2  
  or open Cheese to confirm live video feed.

- **Symlink**  
  If multiple devices exist, enable `webcam-link.desktop` to consistently link `/dev/webcam`.

### 8.6 Key Mappings Revert After Reboot

- **Ensure XModMap Autostart**  
  Verify `XModMap.desktop` is enabled in **Session and Startup**. Some systems may require a short delay or running it in `.xprofile` to stick reliably.

### 8.7 Notable Debugging Tools/Commands

- **showkey**, **xev**, **xbindkeys -v**  
  - For debugging keycodes and verifying your mappings.
- **libinput debug-events**  
  - For seeing tablet-mode events and other hardware input.
- **Touché** (`touchegg --debug`)  
  - For confirming multi-touch gesture detection.

---

<a name="webcam-notes"></a>
## 9. Webcam Notes

- **Works Out of the Box**: The front-facing webcam (labeled something like *720p HD Camera*) typically works fine without the `detect-webcam.sh` script. However, you might see multiple `/dev/videoX` devices in some apps, and only one of them is the real camera feed.

- **Symlink Behavior**:  
  If you do enable `detect-webcam.sh`, you can then run:
  
      guvcview -d /dev/webcam
  
  to confirm it opens your live camera feed.  
  - **Cheese & ffplay** often don’t accept an explicit `/dev/webcam` argument, but they still pick up the camera automatically.

- **Tablet-Facing Camera**:  
  Currently not detected at all in Linux. I haven’t explored possible fixes, so I can’t speculate on how to get it running.

<a name="who-is-this-for"></a>
## 10. Who This Project Is For & Distro Observations

- **Primary Focus**: A single-user laptop experience that mimics Chromebook shortcuts.  
- **Not (necessarily) a Power-Linux Layout**: You can adapt these configs for more complex setups if you wish, but out-of-the-box, it’s intended for a straightforward, ChromeOS-like environment.

### Distros I Tried

- **Xubuntu**  
- **NixOS**  
- **Manjaro**  
- **Fedora**  
- **Vanilla Puppy**

I can't remember specifically what worked and didn't, but most distros besides Xubuntu had something that wasn't easily working out-of-the-box. Wifi, Bluetooth, and tap-to-click are all issues I remember running into. I most earnestly tried NixOS as I really wanted to use it. I even tried the audio fix script from chrultrabook, but that didn't work, and Bluetooth was spotty across different configuration.nix builds.

---

<a name="performance-notes"></a>
## 11. Performance Notes

- **Overall Performance**: Excellent. The Intel Core m3 processor handles everyday tasks smoothly under Xubuntu (web, media, notetaking app with stylus, etc.).

- **Battery Life**:  
  - I don’t have precise measurements yet because I’ve been doing heavy installs and testing.  
  - It might drain a bit faster than ChromeOS did, but still significantly better than my i7 ultrabook in comparable usage.  
  - Under typical (light) usage, you could still see very good battery life—just not necessarily identical to ChromeOS.

- **Miscellaneous**:  
  - I tried installing OpenBoard to try even more stylus apps, but had trouble getting dependencies to work. Krita and Xournal++ seem to work great though. At least as smooth as the ChromeOS/Android options I used before.

<a name="uefi"></a>
## 12. UEFI Firmware Installation (Non-Comprehensive Summary)

*This is **not** a full guide. Before proceeding, thoroughly read [MrChromebox’s documentation](https://docs.mrchromebox.tech/docs/getting-started.html). The steps below are only additional notes specific to the Samsung Chromebook Plus v2 (Nautilus).*

1. **Tools Needed**  
   - A small screwdriver  
   - A thin-edged tool (e.g., a small plastic pry tool or a blunt knife) to help gently pop off the back cover  
   - A USB-C flash drive  
   - A USB-C charger that can power the device *without* its battery connected (**Note**: higher-watt chargers are unlikely to work; your safest option is the official Google charger. You could test this out before making irreversible software changes, but doing so could still void warranties potentially.)

2. **Check Device Compatibility**  
   - Verify that your Chromebook is the Samsung Chromebook Plus v2 (codename “Nautilus”).  
   - If unsure, open `chrome://version` in Chrome to confirm.  
   - At time of this writing, Nautilus is supported by the MrChromebox tools. You can double check [here](https://docs.mrchromebox.tech/docs/supported-devices.html)

3. **Developer Mode**  
   - Enabling Developer Mode **will** wipe the device.  
   - After doing so, you’ll boot into a Developer Mode environment (not the standard ChromeOS desktop).

4. **Hardware Write Protection**  
   - You must disable write protection at the hardware level by removing the bottom cover and disconnecting the battery.  
   - With the battery unplugged, you must power the device via a suitable USB-C charger.  
   - The first minute of [this Youtube video](https://www.youtube.com/watch?v=dKZEH0U9Mto) may be helpful.

5. **Install the Firmware**  
   - Use a USB-C flash drive for creating a backup of your existing firmware (strongly recommended). The firmware tool walks you through this.  
   - Run the MrChromebox firmware utility script. It will require a reboot to disable firmware write protection, then proceed with installing the UEFI ROM.

6. **Alternative: RW_LEGACY**  
   - If you prefer dual-booting ChromeOS and Linux, you can install RW_LEGACY firmware instead, which *usually* does not require disabling hardware write protection.  
   - This guide focuses on full UEFI firmware replacement.  
   - I did not attempt this at all, so I have no first-hand experience.

**Important:** If you read this far but have *not* gone through MrChromebox’s documentation in detail, you are *not* prepared to do this responsibly. These steps only provide brief notes for Nautilus devices; the official MrChromebox documentation remains your primary reference.

---

