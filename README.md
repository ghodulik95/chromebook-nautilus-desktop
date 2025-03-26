<a name="top"></a>
# Customized Desktop Environment for Xubuntu on the Samsung Chromebook Plus v2 (Nautilus)

So you’ve installed (or want to install) Linux on your beloved Samsung Chromebook Plus v2 (Nautilus) but don’t want to deal with improper key mappings, poor tablet-mode handling, or missing ChromeOS conveniences (e.g., gesture navigation). Don’t worry—this repository should help! I have found these modifications sufficiently address those issues, at least for my needs.

### Tested configuration

These modifications have been tested only on Xubuntu, specifically *Xubuntu 24.04.2 LTS (Noble Numbat)*. Your mileage may vary with other distros or Xubuntu versions, and many features may not work on non-Xfce desktops.

### Important disclaimers

__This project is not affiliated with or endorsed by Google or Samsung__.

__Use the scripts and configurations included in this project at your own risk.__

This project is **not** intended as a guide for updating Chromebook firmware or installing Linux once you have UEFI. However, [section 12](#uefi) contains some informal notes on my installation experience that may serve as an additional resource alongside proper documentation (I recommend MrChromebox). Proceed with caution, and do **not** assume those notes apply to any Chromebook other than the Samsung Chromebook Plus v2 (Nautilus). Replacing or modifying the original firmware for UEFI boot on a Chromebook can be riskier and more involved than a typical Linux installation on a PC. 

More disclaimers and limitations are noted in [disclaimers](#disclaimers) and [limitations](#limitations).

### Other Linux distributions?

[Section 10](#who-is-this-for) describes other distros I tested (NixOS, Manjaro, Fedora, Vanilla Puppy), highlighting some hardware compatibility issues I encountered before ultimately choosing Xubuntu. In short, Xubuntu provided the best out-of-the-box experience among these options—even though NixOS was my first preference.

### Current experience

I have not run extensive stress tests on my Nautilus, but it’s currently running *wonderfully* for all my old Chromebook use cases and QOL preferences. Even the stylus works great with Krita and Xournal++, including pressure sensitivity and palm rejection. And it is *significantly* speedier than ChromeOS had been running, even after a powerwash. [Performance notes](#performance-notes) contains some more details.

### Hardware limitations

Finally, please note that there are some serious hardware limitations related to the internal speakers, microphone, and the tablet-facing camera (the [normal webcam functions fine](#webcam-notes). See the [limitations](#limitations) and [disclaimers](#disclaimers) for more details. **You have been warned.**


---

<a name="toc"></a>
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

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

While Linux can run very well on the Samsung Chromebook Plus v2 Nautilus, there are significant hardware limitations to note:

1. **Speakers do not work**  
2. **Microphone does not work**  
3. **AUX headphone jack does not work**  
4. **Tablet-facing camera does not work** (though the regular “webcam” camera does)

If you rely on internal audio or a built-in mic, this may be a dealbreaker.  

> **Bluetooth Audio Workaround**  
> - Headphone and microphone modes work great via Bluetooth.  
> - Anecdotally, Bluetooth under ChromeOS had become nearly unusable for me—failing to connect to most devices. Under Xubuntu, Bluetooth has been rock-solid and easily connects to all my devices.

<details>
  <summary>Could the audio issues be fixable?</summary>

  [WeirdTreeThing’s audio script](https://github.com/WeirdTreeThing/chromebook-linux-audio?tab=readme-ov-file) can fix audio on some Chromebooks. However, there’s a risk of permanently damaging the speakers at high volumes on this model. I tried it once on NixOS with no success and decided not to pursue further. If you need internal mic or headphone jack, feel free to explore that audio script solution—but proceed with caution. Xubuntu is not officially supported by the audio script but Ubuntu 24.10 is, so that might be good enough ?
</details>

---

<a name="features"></a>
## 2. Features of This Project

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

This repository helps you keep some of the conveniences you had in ChromeOS:

1. **Functional F1–F10 Row**  
   - Restores the top-row keys to Chromebook roles (Back, Forward, Refresh, Fullscreen, etc.).

2. **Tablet Mode**  
   - Disables the keyboard automatically when the screen is folded into tablet position, then re-enables it afterward.

3. **Swipe Navigation**  
   - Implements 3-finger swipes for browser back/forward (mimicking ChromeOS-style gestures). 
   - Confirmed to work with Google Chrome, Firefox, Tor Browser, Opera, Vivaldi,Brave, and Falkon (minor configuration needed to add support for gesture nav on other browsers)
   - 2-finger gestures not supported.

4. **Bluetooth Headphone/Headset Toggle**  
   - Quickly switch between high-quality audio (“headphone”) and mic-enabled (“headset”) modes.

5. **Tap-to-Click & Natural Scrolling**  
   - Makes the touchpad behave more like ChromeOS.

---

<a name="whats-not-included"></a>
## 3. What’s Not Included

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

- **Firmware Installation Steps**  
  I do not provide detailed instructions for flashing or replacing the Chromebook’s firmware. For that, refer to [MrChromebox’s documentation](https://docs.mrchromebox.tech/).

- **Full Xubuntu Installation Tutorial**  
  Once UEFI boot is enabled, installing Xubuntu is similar to any standard PC. I won’t provide every step here.

- **System-Wide or Power-User Customizations**  
  These configs focus on replicating a ChromeOS-like, single-user experience. If you want multi-user or heavily locked-down setups, you can adapt these scripts as needed.

---

<a name="disclaimers"></a>
## 4. Disclaimers

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

__This project is not affiliated with or endorsed by Google or Samsung__.

### 4.1. Warranties & Risk of Bricking
Modifying the Chromebook firmware and installing Linux on this device can void your warranty and carries an inherent risk of bricking.

### 4.2. Known hardware limitations and risks
I'll repeat here: internal speakers, headphone jack, microphone, and tablet-facing camera do not work. Workarounds on the speakers are specifically known to potentially cause permanent damage. See [Limitations](#limitations).

### 4.3. My attempts at addressing the hardware limitations
While I put in *some* effort to get the speakers, headphone jack, and microphone to work, I put in zero effort at getting the tablet camera to work. You might have more luck than me, finding an easy workaround. I suspect that many of these limitations will be a very involved process to work around, however, so I would not recommend proceeding if any of that hardware is essential to you and you don't have the capacity to spend several hours sorting it out (and possibly come up empty). If that founds like a fun challenge for you, though, then awesome. Please let me know how it goes.

---

<a name="quick-start"></a>
## 5. Quick Start

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

Here’s a high-level outline of the key setup steps. For more specific instructions and commands, see the [Installation](#installation) section.

1. **Clone or Download This Project**  
   - Either `git clone https://github.com/ghodulik95/chromebook-nautilus-desktop.git` or download the ZIP to your new Xubuntu install.

2. **Install Required Packages**  
    The package projects include brightnessctl grep xbindkeys xdotool libinput-tools touchegg and google-chrome-stable (requires adding official repository link). You can install with this command to make sure you use the same versions as I did (probably just using system defaults will work just fine though).
    
		cd path/to/project
		sed '/^\s*#/d;/^\s*$/d' packages.txt | xargs sudo apt install -y
    

3. **Modify Google Chrome .desktop launcher file**
	
	Many of the top-row keymappings require the following launch flag to prevent key interception by Chrome:

        --disable-features=KeyboardShortcutViewer

4. **Copy Project Files to Your Home Directory**  

		rsync -av --exclude 'README.md' --exclude 'packages.txt' path-to-project/ ~/


5. **Make Scripts Executable**  

    	chmod +x ~/bin/tablet-mode-handler.sh
    	chmod +x ~/bin/toggle-headset-mode.sh
   		chmod +x ~/bin/detect-webcam.sh


6. **Enable Passwordless Sudo**  
   - Add entries in `sudo visudo` to allow the tablet-mode script and brightnessctl package to run without password prompts.

6. **Reboot & Validate**  
   - Flip the screen to test tablet-mode.  
   - Confirm the top-row keys work as expected.  
   - Test gestures, brightness, and Bluetooth audio if you configured them.  

For more in-depth instructions, see the next section.

---
<a name="installation"></a>
## 6. Installation & Setup Steps

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

These steps assume you’ve already replaced the Chromebook’s firmware with something UEFI-capable (e.g., via MrChromebox scripts).

### 6.1. Install Xubuntu

1. **Flash Xubuntu to a USB-C stick** 
	- I used Rufus on Windows.
	- I flashed *Xubuntu 24.04.2 LTS (Noble Numbat)*.
2. **Boot via UEFI**  
3. **Install Xubuntu** as you would on any PC.

### 6.2. (Optional, but Recommended) Enable Tap-to-Click & Natural Scrolling

If you regularly used tap-to-click, natural scrolling, and two-finger-tap-for-right-click when running ChromeOS, these modifications are essential. By default, Xubuntu’s GUI may not expose these settings (It didn't for me). To enable them:

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

Save and reboot/logout and back in. *I have not looked into momentum scrolling so I cannot say how easy or difficult that is to enable or implement. I might look into it in the future.*

### 6.3. Add google-chrome ppa repository

    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg

    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

    sudo apt update

### 6.4. Download/Clone This Project

Download the .zip, or clone the git repository:

1. Install Git if needed:
    
        sudo apt install git

2. Clone the repo (or download a `.zip` and use `unzip` to unzip):
    
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
- `libinput-tools`
  + For detecting tablet-mode event emitting hardware
- `google-chrome-stable` (from official Google repository, added in prior steps)  
- Touché (the `touchegg` package from PPA or Ubuntu repo)  
  + For multi-touch gesture commands

*Note: Specifying exact package versions is probably unnecessary. However, the internet tells me that some versions of xbindkeys do not add an autostart rule by default, so if the default package does not do this you may need to manually add an autostart rule that runs xbindkeys.*

#### Alternative: Single-line install command

With version specifications:
    
    sudo apt install -y brightnessctl=0.5.1-3.1 grep=3.11-4build1 xbindkeys=1.8.7-2 xdotool=1:3.20160805.1-5build1 libinput-tools google-chrome-stable touchegg

Without version specifications:
    
    sudo apt install -y brightnessctl grep xbindkeys xdotool libinput-tools google-chrome-stable touchegg

#### If using the detect-webcam script
you will also need to install v4l-utils. This can be done with the below command or by uncommenting the package in packages.txt before installing via packages.txt.

		sudo apt install -y v4l-utils

### 6.6. Modifying the Google Chrome Launcher

To prevent Chrome from intercepting the Chromebook top-row keys (e.g., Back, Refresh, Fullscreen), you’ll need to modify its `.desktop` launcher:

1. **Copy the system launcher to your local applications directory**:

        mkdir -p ~/.local/share/applications/
        cp /usr/share/applications/google-chrome.desktop ~/.local/share/applications/

2. **Edit the copied file**:

        nano ~/.local/share/applications/google-chrome.desktop

3. **Add the following flag** to each `Exec=` line:

        --disable-features=KeyboardShortcutViewer

    For example, change:

        Exec=/usr/bin/google-chrome-stable %U

    to:

        Exec=/usr/bin/google-chrome-stable --disable-features=KeyboardShortcutViewer %U

#### Example Diff

        --- /usr/share/applications/google-chrome.desktop
        +++ ~/.local/share/applications/google-chrome.desktop
        @@ -2,7 +2,7 @@
         Version=1.0
         Name=Google Chrome
         GenericName=Web Browser
        -Exec=/usr/bin/google-chrome-stable %U
        +Exec=/usr/bin/google-chrome-stable --disable-features=KeyboardShortcutViewer %U
         Terminal=false
         Icon=google-chrome
         Type=Application

*Note that there are several Exec= lines for different launching options, and it is recommended to add the flag to each so that your top-row keys work as expected at all times.*

**Important**: If you launch Chrome without this parameter, many of the top-row key mappings will break, because Chrome intercepts those keys and will not interpret them appropriately. It's likely that Chromium also needs this flag if you prefer Chromium; you can similarly create a custom .desktop by copying it from /usr/share/applications/ to ~/.local/share/applications/ and adding the disable-features tag to each Exec line (I have not tested this with Chromium, YMMV). 

**Other browsers should not need this customization**: I think it is specific to Chrome browsers detecting Chromebook hardware strangely.

### 6.7. Copy Project Files to Your Home Directory

    rsync -av --exclude 'README.md' --exclude 'packages.txt' path-to-project/ ~/

**What’s Being Copied?**  
- **Configuration files** for keyboard mapping, gesture handling, and autostart scripts  
- **Desktop files** for autostart (like tablet mode handling, XModMap, etc.)  
- **Custom shell scripts** (for toggling headset mode, linking webcam device, etc.)

You can see a deeper breakdown in [Section 7](#project-file-overview). The autostart `.desktop` files go into `~/.config/autostart/`. If you decide you don’t want one of these services running at login, open **Session and Startup** (in the Xubuntu Settings GUI) and uncheck or remove the relevant entry.

### 6.8. Make scripts Executable

    chmod +x ~/bin/tablet-mode-handler.sh
    chmod +x ~/bin/toggle-headset-mode.sh
    chmod +x ~/bin/detect-webcam.sh

*For a tabular breakdown of what these scripts do, see [this table in section 7](#tabular)*

### 6.9. Enable Passwordless Sudo

You need passwordless sudo for:

- `tablet-mode-handler.sh` (managing tablet mode)  
  + The tablet event id can change across boots, so sudo is needed to read the device list from libinput every boot/login.
- `brightnessctl` (adjusting screen brightness)  
  + This software appears to require sudo privileges for basic use.

Use:

    sudo visudo

Then add lines like (replacing your-username 3 times with your username):

    your-username ALL=(ALL) NOPASSWD: /home/your-username/bin/tablet-mode-handler.sh
    your-username ALL=(ALL) NOPASSWD: /usr/bin/brightnessctl

### 6.10. (Optional, but Recommended if you'll be making video calls) Add Keyboard Shortcut for Bluetooth Headset Toggle

    xfconf-query \
      -c xfce4-keyboard-shortcuts \
      -p "/commands/custom/<Primary><Alt>h" \
      -n -t string -s "bin/toggle-headset-mode.sh"

Or do this in **Keyboard > Application Shortcuts**. Feel free to modify the keymapping in the command or in the GUI if you do not want to use Ctrl+Alt+H.

> **Note**: Some applications may automatically toggle your headphones into headset mode (mic enabled) without any manual intervention. However, if you plan to use headphones in video calls and don’t see an auto-toggle, this script plus a shortcut can be handy. Because the webcam device id can change across boots, applications might not operate consistently (more on that in [webcam notes](#webcam-notes).

### 6.11. Log out and back in, or reboot.

Confirm everything is working:

1. Flip into tablet mode. You should get a notification and you can confirm the keyboard is disabled and re-enabled when you exit tablet mode.
2. Open Chrome normally, and you can test the 3-finger swiping for back and forward, and the top row keys for back, forward, refresh, and fullscreen. **Note that there is unfortunately no cute arrow animation like in ChromeOS, so if a specific web page is being unresponsive to back/forward/refresh, it may look like nothing is happening.** Be sure to test multiple pages before concluding that it didn't work. (I have created a script for animations in another branch but ran into issues getting Touché to execute commands.)
3. Test brightness and volume keys. (The volume keys should still be responsive even without connected to Bluetooth.)
4. Confirm the "lock" key actually is "Delete". 
	- (This is not standard ChromeOS functionality, but I made an assumption that most Linux users would prefer to have a Delete key, which is otherwise not present on the keyboard. If you prefer a lock/sleep behavior, there is guidance on how to do that in the comments of `.config/keyboardmapping/.Xmodmap`)
5. Test bluetooth headset audio toggle (Ctrl+Alt+h if using default keymapping).
6. If using the detect-webcam script, you can test with `guvcview -d /dev/webcam` (requires installing guvcview). If the camera opens with no additional prompting, the symlink worked.
	+ Note that `cheese` and `ffplay` did not seem to cooperate with specifying devices at command line, so if you test with these, it may appear the symlink did not work. This is why I recommend testing with `guvcview`.
7. Test that the window manage key captures a screenshot to clipboard. There should be a quick notification.
	- If you don't want a notification (e.g. you do a lot of back to back screenshots and don't want the notication in view), I have included commented out keymappings in `.xkeybindsrc` that will forego the notification.
8. Confirm tap-to-click, 2-finger tap right-click, and 2-finger natural scrolling works.
9. All set. Hoorah!

### 6.12. Other desktop configurations to consider.

1. Window snapping on screen edge *should* already be enabled, although I found it pretty difficult to activate without tap-to-click enabled via step 6.2. If for some reason it is not enabled, the setting is in Window Manager Tweaks > Accessibility. I think this requires display compositing, which should also be enabled, but if it is not, the setting is in Window Manager Tweaks > Compositor.
	- You might want to enable Window snapping to other windows in Window Manager > Advanced.
2. In Window Manager Tweaks > Compository, you can modify opacity of windows when they are moving or inactive.
3. Since I didn't have a use case for the Window manager key (right of the fullscreen key), I mapped this to do a fullscreen screenshot to clipboard. If you'd prefer a different mapping, modify `~/.xbindkeysrc`.
4. Touché has a lot more potential use for more complex swipe navigation. I only added rules for 3-finger swiping for back/forward/maximize/minimize and pinch-to-zoom. Modications can be made to `~/.config/touchegg/touchegg.conf`. I have noticed though that Touché seems a bit out of maintenance and I cannot get terminal commands to execute from gestures.
5. Pretty much any other Xubuntu/Xfce configurations you want.

<a name="project-file-overview"></a>
## 7. Project File Overview

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

All the copied files in `~/` after installation serve different roles, but they can be grouped as follows:

### 7.1 Autostart, Input, and Custom Scripts

1. **Autostart Desktop Files** (`~/.config/autostart/`)  
   - **`Tablet Mode Toggle.desktop`**  
     - Runs `bin/tablet-mode-handler.sh` at login, automatically enabling/disabling your keyboard when you fold the screen.  
     - This file was originally generated by Xubuntu’s autostart manager.
   - **`XModMap.desktop`**  
     - Applies `.config/keyboardmapping/.Xmodmap` to restore top-row keys (Back, Forward, Mute, Volume, etc.).  
     - This file was originally generated by Xubuntu’s autostart manager.
   - **`touchegg.desktop`**  
     - Starts the Touché daemon (the `touchegg` package) to enable multi-finger gestures.  
     - This file was originally generated by Xubuntu’s autostart manager.
   - **`webcam-link.desktop`**  
     - (Disabled by default, as most users probably won't need this) Runs `detect-webcam.sh` on login, creating a stable `/dev/webcam` symlink.
     - This file was originally generated by Xubuntu’s autostart manager.

* (Also, note xbindkeys should add its own autostart under `/etc/xdg/autostart/xbindkeys.desktop` or `/usr/share/xsessions/xbindkeys.desktop`; if not, you’d need to manually add an autostart rule at the user or system level.)*

2. **Input Config & Gesture Mapping**  
   - **`.config/keyboardmapping/.Xmodmap`**  
     - Remaps many F-row keys to their Chromebook counterparts.  
     - Lock button is mapped to delete instead. (Alternative Lock/Sleep mappings included in comments.)
     - This file contains many of the default contents from running xmodmap -pke (which prints the current keymap to stdout).
   - **`.xbindkeysrc`**  
     - Handles keys that `xmodmap` can’t, like brightness.  
     - The window manage key is set to screenshot to clipboard.
     - This file contains many of the default contents from running xbindkeys --defaults (which outputs a sample/default configuration).
   - **`.config/touchegg/touchegg.conf`**  
     - Defines gesture mappings (e.g., 3-finger swipes for browser back/forward, refresh, maximize, minimize (commented out)).
     - This file contains many of the default contents created after first launching touchegg or running touchegg --generate-config.

3. **Custom Scripts** (`~/bin/`)  
   - **`tablet-mode-handler.sh`**  
     - Detects and toggles keyboard off/on in tablet mode.  
   - **`toggle-headset-mode.sh`**  
     - Switches a Bluetooth device between headphone (A2DP) and headset (HSP/HFP) with mic enabled.  
   - **`detect-webcam.sh`**  
     - Creates a symlink `/dev/webcam` to your actual camera device (which can vary from boot to boot). Used by the (disabled by default) `webcam-link.desktop`.

<a href="tabular"></a>
### 7.2 Tabular summary of scripts and config files
| **File/Directory**                                      | **Purpose**                                                                                                                         | **Optional or Required?**                                              |
|---------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| `~/.config/autostart/Tablet Mode Toggle.desktop`        | Launches `~/bin/tablet-mode-handler.sh` at login to auto-enable/disable the keyboard in tablet mode.                                | Required for seamless tablet-mode functionality                          |
| `~/bin/tablet-mode-handler.sh`                          | Detects tablet folding events (via libinput) and toggles the keyboard on/off automatically.                                         | Required for seamless tablet-mode functionality                         |
| `~/.config/autostart/XModMap.desktop`                   | Applies `.config/keyboardmapping/.Xmodmap` for Chromebook-like top-row keys (Back, Refresh, Volume, etc.).                          | Required for full Chromebook-like key behavior                         |
| `~/.config/keyboardmapping/.Xmodmap`                    | Remaps F-row keys to Chromebook equivalents, including making the "lock" key act as Delete.                                         | Required for full Chromebook-like key behavior                         |
| `~/.xbindkeysrc`                                        | Handles brightness, screenshot, and other bindings that Xmodmap alone doesn’t cover. This is the default xbindkeys config filepath.                                                | Required for full Chromebook-like key behavior                         |
| `~/.config/autostart/touchegg.desktop`                  | Starts **Touché** (the `touchegg` daemon) at login, enabling multi-finger gestures (e.g., 3-finger swipes to navigate).             | Required for gesture navigation |
| `~/.config/touchegg/touchegg.conf`                      | Defines gesture mappings (e.g., 3-finger swipes for browser back/forward, minimize, maximize). This is the default touchegg config filepath.                                      | Required for gesture navigation                             |
| `~/bin/toggle-headset-mode.sh`                          | Toggles Bluetooth device mode between headphone (A2DP) and headset (HSP/HFP) with mic enabled.                                      | Recommended if you use BT headphones + mic (e.g. video calls)          |
| `~/bin/detect-webcam.sh`                                | Finds the correct camera device (e.g., `/dev/video2` can vary across boots) and symlinks it to `/dev/webcam`.                       | Optional                                                               |
| `~/.config/autostart/webcam-link.desktop`               | (Disabled by default) Runs `detect-webcam.sh` to create a stable `/dev/webcam` symlink.                                             | Optional — recommended if you use your camera via command-line/code a lot.   |
| `~/.local/share/applications/google-chrome.desktop`      | Custom Chrome launcher with `--disable-features=KeyboardShortcutViewer` to prevent Chrome from stealing top-row keys.               | Recommended for Chrome users                                           |


---

<a name="troubleshooting"></a>
## 8. Troubleshooting

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

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
  
- **Ensure autostart rule is enabled**

### 8.3 No Speaker, AUX Audio (headphone jack), or tablet-facing camera

- **[Known Device Limitation](#limitations)**  
  The internal speakers, microphone, and headphone jack don’t work out-of-the-box on the Samsung Chromebook Plus v2. Use Bluetooth or attempt advanced fixes at your own risk.

### 8.4 Multi-Finger Gestures Not Working

- **Confirm Touché Daemon**  
    touchegg --debug  
  Check if gestures are detected. If not, verify that `~/.config/touchegg/touchegg.conf` is loaded and `touchegg.desktop` is enabled on startup.
  - TODO: Need to better understand and document how touchegg works for this, and see if maximazion is still weird after restart
  - TODO: Now that I think some issues are fixed with removing the user autostart, want to see if running commands works

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

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

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

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

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

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

- **Overall Performance**: Excellent. The Intel Core m3 processor handles everyday tasks smoothly under Xubuntu (web, media, notetaking app with stylus, etc.).
	+ The only times I noticed lag where I was briefly concerned was when I was running a heavy apt install with multiple other things open.

- **Battery Life**:  
  - I don’t have precise measurements yet because I’ve been doing heavy installs and testing.  
  - It might drain a bit faster than ChromeOS did, but still significantly better than my i7 ultrabook in comparable usage.  
  - Under typical (light) usage, you could still see very good battery life—just not necessarily identical to ChromeOS.

- **Miscellaneous**:  
  - I tried installing OpenBoard to try even more stylus apps, but had trouble getting dependencies to work. Krita and Xournal++ seem to work great though. At least as smooth as the ChromeOS/Android options I used before.

<a name="uefi"></a>
## 12. UEFI Firmware Installation (Non-Comprehensive Summary)

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

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

