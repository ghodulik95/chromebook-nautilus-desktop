# Installing Linux on a Samsung Chromebook Plus v2 (codename Nautilus)

If you want to run Linux on your Samsung Chromebook Plus v2, you’re in luck—it’s absolutely possible! This project provides a convenient setup for a working **Xubuntu** desktop environment that replicates many Chromebook conveniences (minus some hardware limitations).

Installing Linux on this Chromebook (and many Chromebooks) can be more involved than on a typical PC because you must replace or modify the original firmware for UEFI boot. However, once that’s done and Xubuntu is installed, you’ll enjoy (almost) the full functionality of your old Chromebook plus the power and speed of a Linux system. Even the stylus works great with Krita and Xournal++.

---

## Table of Contents

1. [Limitations](#limitations)  
2. [Features of This Project](#features)  
3. [What’s Not Included](#whats-not-included)  
4. [Disclaimers](#disclaimers)  
5. [Installation & Setup Steps](#installation)  
6. [Project File Overview](#project-file-overview)  
7. [Webcam Notes](#webcam-notes)  
8. [Who This Project Is For & Distro Observations](#who-is-this-for)  
9. [Performance Notes](#performance-notes)

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
I'll repeat here: Speakers, AUX-IN (headphone jack), Microphone, and tablet-facing camera do not work. Workarounds on the speakers are specifically known to potentially cause permanent damage.

### 4.3. My attempts at addressing the hardware limitations
While I put in *some* effort to get the speakers, headphone jack, and microphone to work, I put in zero effort at getting the tablet camera to work. You might have more luck than me, finding an easy workaround. I suspect that many of these limitations will be a more involved process to workaround, however, so I would not recommend proceeding if any of that hardware is essential to you and you don't have the time and/or skill to sort it out.

---

<a name="installation"></a>
## 5. Installation & Setup Steps

These steps assume you’ve already replaced the Chromebook’s firmware with something UEFI-capable (e.g., via MrChromebox scripts).

### 5.1. Install Xubuntu
1. **Flash Xubuntu to a USB-C stick**  
2. **Boot via UEFI**  
3. **Install Xubuntu** as you would on any PC.

*I am using Xubuntu 24.04.2 LTS (Noble Numbat)*

### 5.2. (Optional, but Recommended) Enable Tap-to-Click & Natural Scrolling
By default, Xubuntu’s GUI may not expose these settings. To enable them:

~~~~bash
sudo mkdir -p /etc/X11/xorg.conf.d
sudo nano /etc/X11/xorg.conf.d/40-touchpad.conf
~~~~

Paste:

~~~~conf
Section "InputClass"
    Identifier "Touchpad defaults"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
EndSection
~~~~

Save and reboot.

### 5.3. Download/Clone This Project
Download the .zip, or clone the git repository:
1. Install Git if needed:

~~~~bash
sudo apt install git
~~~~

2. Clone the repo (or download a `.zip`):

~~~~bash
git clone <URL-of-this-project>
~~~~

### 5.4. Install Required Packages

In the project root directory:

~~~~bash
sudo xargs -a packages.txt apt install -y
~~~~

Installs:
- `brightnessctl`  
- `touchegg` (Touché)  
- `xbindkeys`  
- `xdotool`  
- `grep`  
- `google-chrome-stable`

### 5.5. Copy Project Files to Your Home Directory

~~~~bash
rsync -av --exclude 'README.md' --exclude 'packages.txt' path-to-project/ ~/
~~~~

**What’s Being Copied?**  
- **Configuration files** for keyboard mapping, gesture handling, and autostart scripts  
- **Desktop files** for autostart (like tablet mode handling, XModMap, etc.)  
- **Custom shell scripts** (for toggling headset mode, linking webcam device, etc.)

You can see a deeper breakdown in [Section 6](#project-file-overview). The autostart `.desktop` files go into `~/.config/autostart/`. If you decide you don’t want one of these services running at login, open **Session and Startup** (in the Xubuntu Settings GUI) and uncheck or remove the relevant entry.

TODO: I need to check if xbindkeys autostart needs to be manually added.

### 5.6. Make Relevant Scripts Executable

~~~~bash
chmod +x ~/bin/tablet-mode-handler.sh
chmod +x ~/bin/toggle-headset-mode.sh
chmod +x ~/bin/detect-webcam.sh
~~~~

### 5.7. Enable Passwordless Sudo

You need passwordless sudo for:
- `tablet-mode-handler.sh` (managing tablet mode)
	+ The tablet event id can change across boots, so sudo is needed to read the device list from libinput.
- `brightnessctl` (adjusting screen brightness)
	+ This software appears to require sudo privileges.

Use:

~~~~bash
sudo visudo
~~~~

Then add lines like:

~~~~conf
your-username ALL=(ALL) NOPASSWD: /home/your-username/bin/tablet-mode-handler.sh 
your-username ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl
~~~~


### 5.8. (Optional, but Recommended) Add Keyboard Shortcut for Bluetooth Headset Toggle

~~~~bash
xfconf-query \
  -c xfce4-keyboard-shortcuts \
  -p "/commands/custom/<Primary><Alt>h" \
  -n -t string -s "bin/toggle-headset-mode.sh"
~~~~

Or do this in **Keyboard > Application Shortcuts**.

> **Note**: Some applications may automatically toggle your headphones into headset mode (mic enabled) without any manual intervention. However, if you plan to use headphones in video calls and don’t see an auto-toggle, this script plus a shortcut can be handy.

---

<a name="project-file-overview"></a>
## 6. Project File Overview

All the copied files in `~/` after installation serve different roles, but they can be grouped as follows:

### 6.1 Autostart, Input, and Custom Scripts

1. **Autostart Desktop Files** (`~/.config/autostart/`)  
   - **`Tablet Mode Toggle.desktop`**  
     - Runs `bin/tablet-mode-handler.sh` at login, automatically enabling/disabling your keyboard when you fold the screen.  
   - **`XModMap.desktop`**  
     - Applies `.config/keyboardmapping/.Xmodmap` to restore top-row keys (Back, Forward, Mute, Volume, etc.).  
   - **`touchegg.desktop`**  
     - Starts the Touché (touchegg) daemon to enable multi-finger gestures.  
   - **`webcam-link.desktop`**  
     - (Disabled by default) Runs `detect-webcam.sh` on login, creating a stable `/dev/webcam` symlink.
 * (also) xbindkey also has an autostart, but it seems to be added and handled by xbindkey itself

2. **Input Config & Gesture Mapping**  
   - **`.config/keyboardmapping/.Xmodmap`**  
     - Remaps many F-row keys to their Chromebook counterparts.  
     - Lock button is mapped to delete instead.
   - **`.xbindkeysrc`**  
     - Handles keys that `xmodmap` can’t, like brightness.  
     - The window manage key is set to screenshot to clipboard.
   - **`.config/touchegg/touchegg.conf`**  
     - Sets up 3-finger swipe gestures for minimize, maximize, and browser back/forward.
     - Also added 3 finger swipe up/down for maximize/minimize

3. **Custom Scripts** (`~/bin/`)  
   - **`tablet-mode-handler.sh`**  
     - Detects and toggles keyboard off/on in tablet mode.  
   - **`toggle-headset-mode.sh`**  
     - Switches a Bluetooth device between headphone and headset (mic-enabled) modes.  
   - **`detect-webcam.sh`**  
     - Creates a symlink `/dev/webcam` to your actual camera device (which can vary from boot to boot). Used by the (disabled) `webcam-link.desktop`.

### 6.2. Modified Google Chrome Desktop Launcher

- **`.local/share/applications/google-chrome.desktop`**  
  - Adds `--disable-features=KeyboardShortcutViewer` so Chrome doesn’t hijack top-row keys.  
  - **Important**: If you launch Chrome without this parameter, many of the top-row key mappings will break, because Chrome intercepts those keys. It's likely that Chromium also needs this flag.

---

<a name="debug-tools"></a>
## 7. Notable debugging tools/commands

- **showkey**: Useful for debugging keys for keymapping
- **xev**: Useful for debugging keys for keymapping
- **xbindkeys -v**: Useful for debugging keys for keymapping
- **libinput debug-events**: Useful for debugging keys for keymapping and  seeing stuff like the tablet-mode event
- **touchegg --debug**: Useful for seeing what touchegg is picking up

---

<a name="webcam-notes"></a>
## 8. Webcam Notes

- **Works Out of the Box**: The front-facing webcam (labeled something like *720p HD Camera*) typically works fine without the `detect-webcam.sh` script. However, you might see multiple `/dev/videoX` devices in some apps, and only one of them is the real camera feed.  
- **Symlink Behavior**: If you do enable `detect-webcam.sh`, you can then run:  
  ~~~~bash
  guvcview -d /dev/webcam
  ~~~~
  to confirm it opens your live camera feed.
  - **Cheese & ffplay** often don’t accept an explicit `/dev/webcam` argument, but they still pick up the camera automatically. 
- **Tablet-Facing Camera**:  
  - Currently not detected at all in Linux.  
  - I haven’t explored possible fixes, so I can’t speculate on how to get it running.

---

<a name="who-is-this-for"></a>
## 9. Who This Project Is For & Distro Observations

- **Primary Focus**: A single-user laptop experience that mimics Chromebook shortcuts.  
- **Not (necessarily) a Power-Linux Layout**: You can adapt these configs for more complex setups if you wish, but out-of-the-box, it’s intended for a straightforward, ChromeOS-like environment.

### Distros I Tried
- **Xubuntu**  
- **NixOS**  
- **Manjaro**  
- **Fedora**  
- **Vanilla Puppy**

I can't remember specifically what worked and didn't, but most distros besides Xubuntu had something that wasn't easily working out-of-the-box.  Wifi, Bluetooth, and tap-to-click are all issues I remember running into. I most earnestly tried NixOS as I really wanted to use it. I even tried the audio fix script from chrultrabook, but that didn't work, and Bluetooth was spotty across different configuration.nix builds.

---

<a name="performance-notes"></a>
## 10. Performance Notes

- **Overall Performance**: Excellent. The Intel Core m3 processor handles everyday tasks smoothly under Xubuntu (web, media, notetaking app with stylus, etc.).  
- **Battery Life**:  
  - I don’t have precise measurements yet because I’ve been doing heavy installs and testing.  
  - It might drain a bit faster than ChromeOS did, but still significantly better than my i7 ultrabook in comparable usage.  
  - Under typical (light) usage, you could still see very good battery life—just not necessarily identical to ChromeOS.
- **Miscellaneous**:  
  - I tried installing OpenBoard to try even more stylus apps, but had trouble getting dependencies to work. Krita and Xournal++ seem to work great though. At least as smooth as the ChromeOS/Android options I used before. 

<a name="uefi"></a>
## 11. UEFI Firmware Installation (Non-Comprehensive Summary)

*This is **not** a full guide. Before proceeding, thoroughly read [MrChromebox’s documentation](https://docs.mrchromebox.tech/docs/getting-started.html). The steps below are only additional notes specific to the Samsung Chromebook Plus v2 (Nautilus).*

1. **Tools Needed**  
   - A small screwdriver  
   - A thin-edged tool (e.g., a small plastic pry tool or a blunt knife) to help gently pop off the back cover
   - A USB-C flash drive  
   - A USB-C charger that can power the device *without* its battery connected (**Note**: higher-watt chargers are unlikely to work; your safest option is the official Google charger. You could test this out before making irreversible software changes, but doing so could still void warranties pottentially.)  

2. **Check Device Compatibility**  
   - Verify that your Chromebook is the Samsung Chromebook Plus v2 (codename “Nautilus”).  
   - If unsure, open `chrome://version` in Chrome to confirm.  
   - At time of this writing, Nautilus is supported my the MrChromebox tools. You can double check [here](https://docs.mrchromebox.tech/docs/supported-devices.html)

3. **Developer Mode**  
   - Enabling Developer Mode **will** wipe the device.  
   - After doing so, you’ll boot into a Developer Mode environment (not the standard ChromeOS desktop).  

4. **Hardware Write Protection**  
   - You must disable write protection at the hardware level by removing the bottom cover and disconnecting the battery.  
   - With the battery unplugged, you must power the device via a suitable USB-C charger.  

5. **Install the Firmware**  
   - Use a USB-C flash drive for creating a backup of your existing firmware (strongly recommended). The firmware tool walks you through this.  
   - Run the MrChromebox firmware utility script. It will require a reboot to disable firmware write protection, then proceed with installing the UEFI ROM.  

6. **Alternative: RW_LEGACY**  
   - If you prefer dual-booting ChromeOS and Linux, you can install RW_LEGACY firmware instead, which *usually* does not require disabling hardware write protection.  
   - This guide focuses on full UEFI firmware replacement.  
   - I did not attempt this at all so I have not first-hand experience.

**Important:** If you read this far but have *not* gone through MrChromebox’s documentation in detail, you are *not* prepared to do this responsibly. These steps only provide brief notes for Nautilus devices; the official MrChromebox documentation remains your primary reference.
