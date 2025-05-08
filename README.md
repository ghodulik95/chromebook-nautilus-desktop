<a name="top"></a>
# Customized Desktop Environment for Xubuntu on the Samsung Chromebook Plus v2 (Nautilus)

So you’ve installed (or want to install) Linux on your beloved Samsung Chromebook Plus v2 (Nautilus) but don’t want to deal with improper key mappings, poor tablet-mode handling, or missing ChromeOS conveniences (e.g., gesture navigation). Don’t worry—this repository should help! I have found these modifications sufficiently address those needs.

### Tested configuration

These modifications have been tested only on Xubuntu, specifically *Xubuntu 24.04.2 LTS (Noble Numbat)*. Your mileage may vary with other distros or Xubuntu versions, and many features may not work on non-Xfce desktops.

### Important disclaimers

__This project is not affiliated with or endorsed by Google or Samsung__.

__Use the scripts and configurations included in this project at your own risk.__

This project is **not** intended as a guide for updating Chromebook firmware or installing Linux once you have UEFI. However, [section 12](#uefi) contains some informal notes on my installation experience that may serve as an additional resource alongside proper documentation (I recommend MrChromebox). Proceed with caution, and do **not** assume those notes apply to any Chromebook other than the Samsung Chromebook Plus v2 (Nautilus). Replacing or modifying the original firmware for UEFI boot on a Chromebook can be riskier and more involved than a typical Linux installation on a PC. 

More disclaimers and limitations are noted in [disclaimers](#disclaimers) and [limitations](#limitations).

### Other Linux distributions?

[Section 10](#who-is-this-for) describes other distros I explored (NixOS, Manjaro, Fedora, Vanilla Puppy) before ultimately choosing Xubuntu. I highlight some hardware compatibility issues I encountered with each OS. In short, Xubuntu provided the best out-of-the-box experience among these options—even though NixOS was my first preference. This is why I chose Xubuntu to ultimately further customize. The modifications in this project were not tested with those other distros I tried.

### Current experience

I have not run extensive stress tests on my Nautilus, but it’s currently running *wonderfully* for all my old Chromebook use cases and QOL preferences. Touch screen is great, even the stylus works great with Krita and Xournal++, including pressure sensitivity and palm rejection. And it is *significantly* speedier than ChromeOS had been running, even after a powerwash. [Performance notes](#performance-notes) contains some more details.

### Hardware limitations

Finally, please note that there are some serious hardware limitations related to the internal speakers, microphone, and the tablet-facing camera (the [normal webcam functions fine](#webcam-notes)). See the [limitations](#limitations) and [disclaimers](#disclaimers) for more details. **You have been warned.**


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
3. **Aux headphone jack does not work**  
4. **Tablet-facing camera does not work** (though the regular “webcam” camera does)
5. **Lid closing freezes your session and [requires a reboot or restart of lightdm](#lid-close-recovery)**
     - Workaround by remembering to suspend or shutdown manually before closing your lid.
     - Adding a keyboard shortcut for `systemctl suspend` is a pretty good idea.
     - Recovery options described [here](#lid-close-recovery), for doing a safe reboot, and some more advanced things if needed.

If you rely on internal audio or a built-in mic, this may be a dealbreaker.  

> **Bluetooth Audio Workaround**  
> - Headphone and microphone modes work great via Bluetooth.  
> - Anecdotally, Bluetooth under ChromeOS had become nearly unusable for me—failing to connect to most devices. Under Xubuntu, Bluetooth has been rock-solid and easily connects to all my devices.

<details>
  <summary>Could the audio issues be fixable?</summary>

[WeirdTreeThing’s audio script](https://github.com/WeirdTreeThing/chromebook-linux-audio?tab=readme-ov-file) can fix audio on some Chromebooks. However, there’s a risk of permanently damaging the speakers at high volumes on this model. I tried it once on NixOS with no success and decided not to pursue further. If you need internal mic or headphone jack, feel free to explore that audio script solution—but proceed with caution. Xubuntu is not officially supported by the audio script but Ubuntu 24.10 is, so that might be good enough ?
</details>


<details>
	<summary>More details on what is causing the lid closing issue and attempted fixes:</summary>

You'll notice that closing your screen and opening it will make your session unresponsive.

After a moderately thorough investigation, the issue appears to be something strange about the **lid closing**, not necessarily about suspend/wakeup or lid opening. If you close your lid by accident, you may be able to avoid the issue if you reopen your lid within around 0-4s.

It also seems to be solely (or at least primarily) a display process issue. For instance, you can still move to a different tty. See [here](#lid-close-recovery) for safe shutdown instructions and some more advanced recovery options.

I've decided to mostly ignore this problem, opting that remembering to manually suspend or shutdown before lid closing is an acceptable workaround. Consider making a `Keyboard` > `Application Shourtcut` for the `systemctl suspend` command.

#### Attempted fixes

I’ve tried several approaches to stop my Nautilus from becoming unresponsive after closing and reopening the lid. Here's what I tested:

- **Edited `/etc/default/grub`** to disable Intel display power-saving features:  
  - `i915.enable_psr=0`  
  - `i915.enable_dc=0`  
- **Used the Xfce Power Manager GUI** to set lid close actions to "Lock Screen" or "Switch off display"
  - **'Do nothing' was not a listed option here**, and perhaps these issues are why that option was not provided.
- **Edited `/etc/systemd/logind.conf`** to ignore lid events:
  - `HandleLidSwitch=ignore`
  - `HandleLidSwitchDocked=ignore`
  - `HandleLidSwitchExternalPower=ignore`
- **Disabled lid wake via `/proc/acpi/wakeup`** by toggling `LID0` to `disabled`
  - Note that I've concluded that the wakeup behavior is not the problem, so you can leave this enabled.
- **Created a udev rule in `/etc/udev/rules.d/`** to block `"Lid Switch"` input events at the device layer  
  (confirmed via presence of `/sys/class/input/event0/device/name:Lid Switch`)
  - `ls -l /sys/class/input/event0/device/` confirms there is no `enabled` attribute exposed.

Despite this, the issue persists. This may mean the lid switch is handled through non-standard firmware or ACPI behavior, bypassing typical Linux input and power management layers.
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
   - Includes scripts for screen rotation, allowing for tablet tent-mode and portrait-mode.
   - *Auto-rotation is not currently supported, but accelerometer sensor is confirmed to be working. So that may be added in the future.*

3. **Swipe Navigation**  
   - Implements 3-finger swipes for browser back/forward/refresh (mimicking ChromeOS-style gestures), including cute hacky custom animations (that are easy to disable). 
   - Confirmed to work with Google Chrome, Firefox, Tor Browser, Opera, Vivaldi, Brave, and Falkon (minor configuration to `touchegg.conf` needed to add support for gesture nav on other browsers). (*Aside note: I installed these browsers to confirm gesture support. While they seemed to run well, my use of them was very minimal so I'm not sure how well they run overall.*)
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
Modifying the Chromebook firmware and installing Linux on this device can void your warranty and carries an inherent risk of bricking. Use of this project assumes you have already done this, but I'm just putting this here anyway.

### 4.2. Known hardware limitations and risks
I'll repeat here: internal speakers, headphone jack, microphone, and tablet-facing camera do not work. Workarounds on the speakers are specifically known to potentially cause permanent damage. See [Limitations](#limitations).

### 4.3. My attempts at addressing the hardware limitations
While I put in *some* effort to get the speakers, headphone jack, and microphone to work, I put in zero effort at getting the tablet camera to work. You might have more luck than me, finding an easy workaround. I suspect that many of these limitations will be a very involved process to work around, however, so I would not recommend proceeding if any of that hardware is essential to you and you don't have the capacity to spend several hours sorting it out (and possibly come up empty). If that sounds like a fun challenge for you, though, then awesome. Please let me know how it goes. My investigations to the lid closing problem is described in [limitations](#limitations), and safe recovery options are described [here](#lid-close-recovery)

---

<a name="quick-start"></a>
## 5. Quick Start

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

Here’s a high-level outline of the key setup steps. For more specific instructions and commands, see the [Installation](#installation) section.

1. **Clone or Download This Project**  
   - Either `git clone https://github.com/ghodulik95/chromebook-nautilus-desktop.git` or download the ZIP to your new Xubuntu install.

2. **Install Required Packages**  
    The package projects include brightnessctl, grep, xbindkeys, xdotool, libinput-tools, touchegg (requires adding official repository link), imagemagick, yad, x11-utils, google-chrome-stable (requires adding official repository link). You can install with this command to make sure you use the same versions as I did (using system defaults will probably work just fine though).
    
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
        chmod +x ~/bin/gesture-flash.sh
        chmod +x ~/bin/toggle-tent-mode.sh
        chmod +x ~/bin/toggle-portrait-mode.sh

   Consider adding keyboard shortcuts for
   	
	- `toggle-headset-mode.sh` (toggle between voicecall and high-quality audio modes)
 	- `toggle-tent-mode.sh` (flip screen and touchpad for "tent" mode for "flat-open" display mode)
  	- `toggle-portrait-mode.sh` (cyles between left/right portrait mode and normal mode)

6. **Enable Passwordless Sudo**  
   - Add entries in `sudo visudo` to allow the tablet-mode script and brightnessctl package to run without password prompts.

7. **Reboot & Validate**  
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

Save and reboot/logout and back in. *I have not looked into mousepad momentum scrolling so I cannot say how easy or difficult that is to enable or implement. I might look into it in the future. I have found the default mousepad scrolling sensitivity great. Touchscreen momentum scrolling DOES work (at least on Chrome).*

### 6.3. Add necessary repositories

#### (Required) Add Touchégg repository
**Xubuntu** includes an old version of Touchégg by default. For full functionality, you must add the updated [repository as per documentation](https://github.com/JoseExposito/touchegg#ubuntu-debian-and-derivatives). At time of this writing, that documentation is:

	sudo add-apt-repository ppa:touchegg/stable
	sudo apt update

#### Google Chrome ppa repository
You can skip if you do not want to use Google Chrome.

    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg

    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

    sudo apt update

You could also download via browser from Google's official website and install that way (just note this when installing packages, and skip over the google-chrome-stable package).

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
- `imagemagick`, `yad`, `x11-utils`
  + For color/image processing and window animation in swipe gesture browser animations in ~/bin/gesture-flash.sh
- `google-chrome-stable` (from official Google repository, added in prior steps)  
- Touché (the `touchegg` package from PPA or Ubuntu repo)  
  + For multi-touch gesture commands

*Note: Specifying exact package versions is probably unnecessary. However, the internet tells me that some versions of xbindkeys do not add an autostart rule by default, so if the default package does not do this you may need to manually add an autostart rule that runs xbindkeys.*

#### Alternative: Single-line install command

With version specifications:
    
    sudo apt install -y brightnessctl=0.5.1-3.1 grep=3.11-4build1 xbindkeys=1.8.7-2 xdotool=1:3.20160805.1-5build1 libinput-tools imagemagick yad x11-utils google-chrome-stable touchegg

Without version specifications:
    
    sudo apt install -y brightnessctl grep xbindkeys xdotool libinput-tools imagemagick yad x11-utils google-chrome-stable imagemagic touchegg

#### If using the detect-webcam script
you will also need to install v4l-utils. This can be done with the below command or by uncommenting the package in packages.txt before installing via packages.txt.

		sudo apt install -y v4l-utils

### 6.6. Modifying the Google Chrome Launcher

To prevent Chrome from intercepting the Chromebook top-row keys (e.g., Back, Refresh, Fullscreen), you’ll need to modify its `.desktop` launcher. (When I tested, Vivaldi and Brave worked without customization, but it is possible some Chromium and Chromium-based browsers could need this too.)

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

**Important**: If you launch Chrome without this parameter, many of the top-row key mappings will break, because Chrome intercepts those keys and will not interpret them appropriately. It's possible that Chromium and other Chromium-based browsers would need this flag. However, Vivaldi and Brave (both Chromium-based to my knowledge) seemed to work fine.

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
    chmod +x ~/bin/gesture-flash.sh
    chmod +x ~/bin/toggle-tent-mode.sh
    chmod +x ~/bin/toggle-portrait-mode.sh

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

### 6.10.1 (Optional, but Recommended if you'll be making video calls) Add Keyboard Shortcut for Bluetooth Headset Toggle

    xfconf-query \
      -c xfce4-keyboard-shortcuts \
      -p "/commands/custom/<Primary><Alt>h" \
      -n -t string -s "bin/toggle-headset-mode.sh"

Or do this in **Keyboard > Application Shortcuts**. Feel free to modify the keymapping in the command or in the GUI if you do not want to use Ctrl+Alt+H.

> **Note**: Some applications may automatically toggle your headphones into headset mode (mic enabled) without any manual intervention. However, if you plan to use headphones in video calls and don’t see an auto-toggle, this script plus a shortcut can be handy. Because the webcam device id can change across boots, applications might not operate consistently (more on that in [webcam notes](#webcam-notes)).

### 6.10.2 Add Keyboard Shortcuts for Screen rotation in different tablet modes.

Similarly, consider adding a keyboad shortcut to flip the screen with `bin/toggle-tent-mode.sh` and `bin/toggle-portrait-mode.sh`. The former command will flip the display screen and the latter will rotate the display screen, including transforming the touchscreen input accordingly. This is not automatically toggled by flipping into tablet mode, as it is assumed you only want this if you are putting the Nautilus into "tent" mode (standing in a triangle shape), if displaying the screen flat in a full 180, or using the display like a tablet in portrait mode. If you plan to use tent or portrait mode at all, having easy access to this script is very helpful.

### 6.11 Fix onboard onscreen keyboard to prepare for tablet mode use
The on-screen keyboard onboard should come with your Xubuntu install. However, for me it did not work correctly without first calling 

	`gsettings set org.onboard.keyboard input-event-source 'GTK'`

That should fix it. Now you can open Onboard as needed for tablet mode typing. I personally added it to my icon tray so that I can easily access it from a tablet mode.


### 6.12. Log out and back in, or reboot.

Confirm everything is working:

1. Flip into tablet mode. You should get a notification and you can confirm the keyboard is disabled and re-enabled when you exit tablet mode.
2. Open Chrome (or your preferred browser) normally, and you can test the 3-finger swiping for back and forward, and the top row keys for back, forward, refresh, and fullscreen. You should see little arrow navigations for back/forward/refresh in browsers. (If you are using a browser I did not add support for, adding support is very easy by following instructions in the comments of `~/.config/touchegg/touchegg.conf`. You can also easily disable the animations here.)
3. Test brightness and volume keys. (The volume keys should still be responsive even without a connected Bluetooth device.)
4. Confirm the "lock" key actually is "Delete". 
	- (This is not standard ChromeOS functionality, but I made an assumption that most Linux users would prefer to have a Delete key, which is otherwise not present on the keyboard. If you prefer a lock/sleep behavior, there is guidance on how to do that in the comments of `.config/keyboardmapping/.Xmodmap`)
5. Test bluetooth headset audio toggle (Ctrl+Alt+h if using default keymapping). Without a Bluetooth device connected, you should still see a "No Bluetooth Headset found" notification.
6. If using the detect-webcam script, you can test with `guvcview -d /dev/webcam` (requires installing guvcview). If the camera opens with no additional prompting, the symlink worked.
	+ Note that `cheese` and `ffplay` did not seem to cooperate with specifying devices at command line, so if you test with these, it may appear the symlink did not work. This is why I recommend testing with `guvcview`.
7. Test that the window manage key captures a screenshot to clipboard. There should be a quick notification.
	- If you don't want a notification (e.g. you do a lot of back to back screenshots and don't want the notication in view), I have included commented out keymappings in `.xkeybindsrc` that will forego the notification.
8. Confirm tap-to-click, 2-finger tap right-click, and 2-finger natural scrolling works.
9. All set. Hoorah!

### 6.13. Other desktop configurations to consider.

1. Window snapping on screen edge *should* already be enabled, although I found it pretty difficult to activate without tap-to-click enabled via step 6.2. If for some reason it is not enabled, the setting is in Window Manager Tweaks > Accessibility. I think this requires display compositing, which should also be enabled, but if it is not, the setting is in Window Manager Tweaks > Compositor.
	- You might want to enable Window snapping to other windows in Window Manager > Advanced.
2. In Window Manager Tweaks > Compository, you can modify opacity of windows when they are moving or inactive.
3. Since I didn't have a use case for the Window manager key (right of the fullscreen key), I mapped this to do a fullscreen screenshot to clipboard. If you'd prefer a different mapping, modify `~/.xbindkeysrc`.
4. Touchégg has a lot more potential use for more complex swipe navigation. I only include rules for 3-finger swiping for back/forward/refresh/maximize/minimize and 2-finger pinch-to-zoom (note that maximize, minimize and pinch-to-zoom were provided by the default config). Modications can be made to `~/.config/touchegg/touchegg.conf`.
5. Pretty much any other Xubuntu/Xfce configurations you want.

---

### 6.14 Expanding Xubuntu Storage with a microSD Card

This is entirely optional and unnecessary if you plan to use your Nautilus only for web browsing. But, if you plan to install a lot of applications, it is probably necessary for you to expand beyond the Nautilus's native storage. This guide walks you through how to **use a microSD card to expand storage on a Xubuntu system**. It includes steps for formatting, mounting, and moving large folders like app caches and Steam game data. You will need a microSD card (recommended at least 64GB but ideally more if you are wanting to install a lot of apps).

#### Step 1: Insert and format the microSD as ext4

> ⚠️ This will erase all data on the SD card.

1. **Unmount the microSD (if auto-mounted)**:
   ```bash
   udisksctl unmount -b /dev/mmcblk0p1
   ```

2. **Format to ext4**:
   ```bash
   sudo mkfs.ext4 -L microsd /dev/mmcblk0p1
   ```

#### Step 2: Set Up Persistent Mount

1. **Create a mount point**:
   ```bash
   sudo mkdir -p /mnt/microsd
   sudo chown $USER:$USER /mnt/microsd
   ```

2. **Find the UUID of the microSD**:
   ```bash
   sudo blkid /dev/mmcblk0p1
   ```

3. **Add it to `/etc/fstab`**:
   Open the file:
   ```bash
   sudo nano /etc/fstab
   ```
   Add the following line (replace with your UUID):
   ```
   UUID=your-uuid-here /mnt/microsd ext4 defaults,noatime 0 2
   ```

4. **Apply the mount**:
   ```bash
   sudo mount -a
   sudo systemctl daemon-reload
   ```

### Step 3: Move Application Cache to SD

1. **Create a new cache location**:
   ```bash
   mkdir -p /mnt/microsd/cache
   ```

2. **Move your current `.cache` directory**:
   ```bash
   mv ~/.cache/* /mnt/microsd/cache/
   rm -r ~/.cache
   ln -s /mnt/microsd/cache ~/.cache
   ```

### Step 4: Move Steam (Snap) Game Data to SD

> ⚠️ This assumes you installed Steam with Snap and will not apply to other install methods.

1. **Create a new Steam directory**:
   ```bash
   mkdir -p /mnt/microsd/steam-snap/.local
   ```

2. **Move Snap Steam data**:
   ```bash
   mv ~/snap/steam/common/.local /mnt/microsd/steam-snap/
   ```

3. **Symlink it back**:
   ```bash
   ln -s /mnt/microsd/steam-snap/.local ~/snap/steam/common/.local
   ```

#### Step 5: Verify and Clean Up

- Launch Steam and confirm your games are detected and working.
- If everything looks good, optionally remove backups:
  ```bash
  rm -rf ~/snap/steam/common/.local.bak
  ```

#### Further Ideas

- Move additional heavy folders (e.g. `~/.npm`, `~/.cargo`, `~/.local/share`) the same way
- Use the SD card for `/opt` or Flatpak installations
- Create a startup check to verify SD card is mounted before launching apps that depend on it

---

<a name="project-file-overview"></a>
## 7. Project File Overview

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

All the copied files in `~/` after installation serve different roles, but they can be grouped as follows:

### 7.1 Autostart, Input, and Custom Scripts

1. **Autostart Desktop Files** (`~/.config/autostart/`)  
   - **`Tablet Mode Toggle.desktop`**  
     - Runs `bin/tablet-mode-handler.sh` at login, starting a process that listens for input events so it can automatically enable/disable your keyboard when you fold the screen.  
     - This file was originally generated by Xubuntu’s autostart manager.
   - **`XModMap.desktop`**  
     - Applies `.config/keyboardmapping/.Xmodmap` to restore top-row keys (Back, Forward, Mute, Volume, etc.).  
     - Note that some of the top-row mappings are handled by xbindkeys instead.
     - This file was originally generated by Xubuntu’s autostart manager.
   - **`touchegg.desktop`**  
     - Starts the Touché daemon (the `touchegg` package) to enable multi-finger gestures.  
     - This file was originally generated by Xubuntu’s autostart manager.
   - **`webcam-link.desktop`**  
     - (Disabled by default, as most users probably won't need this) Runs `detect-webcam.sh` on login, creating a stable `/dev/webcam` symlink.
     - This file was originally generated by Xubuntu’s autostart manager.

* *(Also, note xbindkeys should add its own autostart under `/etc/xdg/autostart/xbindkeys.desktop` or `/usr/share/xsessions/xbindkeys.desktop`; if not, you’d need to manually add an autostart rule at the user or system level.)*

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
     - Defines gesture mappings (e.g., 3-finger swipes for browser back/forward, refresh, maximize, minimize, pinch-to-zoom).
     - This file contains many of the default contents created after first launching touchegg or running touchegg --generate-config.

3. **Custom Scripts** (`~/bin/`)  
   - **`tablet-mode-handler.sh`**  
     - Detects and toggles keyboard off/on in tablet mode.  
   - **`toggle-headset-mode.sh`**  
     - Switches a Bluetooth device between headphone (A2DP) and headset (HSP/HFP) with mic enabled.  
   - **`gesture-flash.sh`**
   	 - Creates quick fading back/forward/refresh animations 
   - **`detect-webcam.sh`**  
     - Creates a symlink `/dev/webcam` to your actual camera device (which can vary from boot to boot). Used by the (disabled by default) `webcam-link.desktop`.
   - **`toggle-tent-mode.sh`**  
     - Vertically flips the laptop screen and sets the touchscreen input to transform accordingly.
   - **`toggle-portrait-mode.sh`**  
     - Rotates the laptop screen and sets the touchscreen input to transform accordingly. Cycles between left, right, and normal rotation.

<a href="tabular"></a>
### 7.2 Tabular summary of scripts and config files
| **File/Directory**                                      | **Purpose**                                                                                                                         | **Optional or Required?**                                              |
|---------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| `~/.config/autostart/Tablet Mode Toggle.desktop`        | Launches `~/bin/tablet-mode-handler.sh` at login to auto-enable/disable the keyboard in tablet mode.                                | Required for seamless tablet-mode functionality                          |
| `~/bin/tablet-mode-handler.sh`                          | Detects tablet folding events (via libinput) and toggles the keyboard on/off automatically.                                         | Required for seamless tablet-mode functionality                         |
| `~/.bin/toggle-tent-mode.sh`               | Vertically flips screen and touchscreen input                                             | Optional — recommended if you use tent-mode of flat presentation mode  |
| `~/.bin/toggle-portrait-mode.sh`               | Rotates screen and touchscreen input                                             | Optional — recommended if you use tablet mode in portrait orientation  |
| `~/.config/autostart/XModMap.desktop`                   | Applies `.config/keyboardmapping/.Xmodmap` for Chromebook-like top-row keys (Back, Refresh, Volume, etc.).                          | Required for full Chromebook-like key behavior                         |
| `~/.config/keyboardmapping/.Xmodmap`                    | Remaps F-row keys to Chromebook equivalents, including making the "lock" key act as Delete.                                         | Required for full Chromebook-like key behavior                         |
| `~/.xbindkeysrc`                                        | Handles brightness, screenshot, and other bindings that Xmodmap alone doesn’t cover. This is the default xbindkeys config filepath.                                                | Required for full Chromebook-like key behavior                         |
| `~/.config/touchegg/touchegg.conf`                      | Defines gesture mappings (e.g., 3-finger swipes for browser back/forward, minimize, maximize). This is the default touchegg config filepath.                                      | Required for gesture navigation                             |
| `~/bin/gesture-flash.sh`                      | Called by Touchégg to create forward/back/refresh animations    | Optional. Disable by replacing \<command> tags in touchegg.conf with the commented-out versions that omit calling gesture-flash.sh                            |
| `~/bin/toggle-headset-mode.sh`                          | Toggles Bluetooth device mode between headphone (A2DP) and headset (HSP/HFP) with mic enabled.                                      | Recommended if you use BT headphones + mic (e.g. video calls)          |
| `~/bin/detect-webcam.sh`                                | Finds the correct camera device (e.g., `/dev/video2` can vary across boots) and symlinks it to `/dev/webcam`.                       | Optional                                                               |
| `~/.config/autostart/webcam-link.desktop`               | (Disabled by default) Runs `detect-webcam.sh` to create a stable `/dev/webcam` symlink.                                             | Optional — recommended if you use your camera via command-line/code a lot.   |


---

<a name="troubleshooting"></a>
## 8. Troubleshooting

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

Below are some issues you could run into.

### 8.1 Brightness Keys Not Working

- **Check if `xbindkeys` is running**  

		pgrep -laf xbindkeys  
  
  If there’s no output, try `xbindkeys` manually or create a `.desktop` file in `~/.config/autostart/` or via GUI to start on startup.

- **Test Manual Brightness**  

    	brightnessctl s 50  
    	
  If you can set brightness manually, your bindings or permissions may be misconfigured. *(The above command probably requires sudo.)*

### 8.2 Tablet Mode Doesn’t Disable the Keyboard

- **Ensure `tablet-mode-handler.sh` is executable**  
    
    	chmod +x ~/bin/tablet-mode-handler.sh

- **Check Sudoers**  
  The script uses `libinput list-devices` which requires sudo. Confirm this script has passwordless sudo with `sudo visudo`
  
- **Ensure autostart rule is enabled**

### 8.3 No Speaker, aux audio (headphone jack), or tablet-facing camera

- **[Known Device Limitation](#limitations)**  
  The internal speakers, microphone, and headphone jack don’t work out-of-the-box on the Samsung Chromebook Plus v2 (or potentially at all). Use Bluetooth. Attempt advanced fixes at your own risk.

### 8.4 Multi-Finger Gestures Not Working

- **Confirm Touché daemon is running**  
	There should be a system service daemon running:

		systemctl status touchegg

	A debug process can be started with

		touchegg --debug  
		
Check stdout to see if gestures are detected. If not, verify that `~/.config/touchegg/touchegg.conf` is loaded and autostart rule is present and enabled.

- It's been my experience that installing new UI packages can break Touché processes or cause them to glitch temporarily. A reboot should fix this.
- Refer to Touché [documentation](https://github.com/JoseExposito/touchegg) for more guidance. 
  
### 8.5 Webcam Issues

- **Check Video Devices**  

    	v4l2-ctl --list-devices
    	
	The webcam should be something like
	
		720p HD Camera: 720p HD Camera (usb-0000:00:14.0-9):
			/dev/video0
			/dev/video1
			/dev/media0
	
	The device ids listed can vary across boots. The first /dev/video* entry should be the correct one.

- **Test with GUVCView or Cheese**  
   	Replacing /dev/video0 with the path from above:
    	
    	guvcview -d /dev/video0
    
  or open `cheese` or `ffplay` and manually select the 720p HD Camera, which should be the webcam. Specifying a device id in terminal with `cheese` and `ffplay` does not work in my experience. (There may be multiple entries with this device naming. Be sure to check each of them. Only one is expected to work.)

- **Symlink**  
  If you are using an application that requires a consistent device id, enable `webcam-link.desktop` autostart rule to consistently link the device id to `/dev/webcam` on startup.

### 8.6 Key Mappings Revert After Reboot

- **Ensure XModMap autostart**  
  - Verify `XModMap.desktop` is enabled in **Session and Startup**.
- **Ensure xbindkeys autostart**  
  - Verify that an autostart entry for **xbindkeys** is enabled in **Session and Startup**.  
  - On my system, `xbindkeys` created this automatically during installation. If that didn’t happen for you, you’ll need to manually add one that calls `xbindkeys_autostart` (which should handle stuff config updates and other process handling stuff, making it less likely to need to restart if there's some crash). 
  
### 8.7 Back button key, Forward button key, Refresh key, other top-row keys not working
* If this is only happening when running Chrome:
  - Google Chrome may intercept top-row keys. Be sure you are running with the proper flags. See [Installation instructions](#installation) for how to have Chrome launch with these flags by default. Updating Chrome could require you to redo this step.
* If this is happening all the time:
	- There might be an issue with your `Xmodmap` or `xbindkeys` configuration. Refer to other sections.

### 8.8 XYZ is having package issues
Make sure necessary packages are installed. Consider running `sudo apt update` and/or `sudo apt upgrade`.

The features have package dependenceis as follows:
| Functionality                     | Package Dependencies                                           |
|----------------------------------|----------------------------------------------------------------|
| Keymappings                      | xbindkeys, xdotool, xmodmap, brightnessctl, xfce4-screenshooter |
| Tablet mode                       | libinput-tools                                                 |
| Gesture navigation with animations | touchegg, yad, x11-utils, imagemagick, xdotool                |
| Detect and symlink camera        | v4l-utils                                                      |

For all but touchegg, you should be able to just use the default Xubuntu packages and install with `sudo apt install`. Some versions of `xbindkeys` might not create/enable an autostart rule on install, which would mean you need to add one that calls `xbindkeys_autostart`.

### 8.9 Gesture navigation issues
- Make sure you have added the touchegg repository and installed properly. The default package provided by Xubuntu will not work with all features of this project. See [installation](#installation) for more guidance.
- Make sure ~/.config/touchegg/touchegg.conf is present and contains the gestures, making sure it is not just the default config.
- Make sure touchegg dependencies are installed and up to date
- Confirm the touchegg daemon is running with `systemctl status touchegg`
- Run `touchegg --verbose` to confirm that a touchegg process is able to attach to the daemon, and see if gestures are detected in stdout.

<a name="lid-close-recovery"></a>
### 8.10 My mouse is moving but everything is unresponsive
This will happen if you close your lid before suspending or shutting down. The easiest but less safe thing to do is a hard shutdown by holding down the power button. However, it's pretty easy to do a safer shutdown/reboot, which will give your programs an opportunity to close gracefully (if they can), potentially triggering some auto-recovery features like in open documents with unsaved changes:

1. Go to a different tty terminal.
   - Press `Ctrl+Alt+Refresh Key`
   - If that does not work, press `Ctrl+Alt+FullScreen Key`.
   - If neither of those worked, then either 1) your issue is unrelated to the lid closing problem or 2) the lid closing caused more problems than expected.
     - If (2), I would be curious to know this. Start an issue describing what happened, if you are so inclined.
2. You should be in a full screen terminal now. Login with your usual credentials.
3. Call `sudo shutdown` or `sudo reboot`.

#### Advanced recovery for also saving Xfce session

Some users make great use of saving window sessions on logout. If this is not you, and/or if losing your window session state is not a big deal in this particular instance, the instructions in this section are probably not worth doing as opposed to just `sudo shutdown` or `sudo reboot`.

From the new tty terminal you entered in step 2, you could alternatively tell your frozen session to logout before the reboot, which would trigger an Xfce session save if that option is persistently enabled for you. If it is not, you could also set it via terminal and then do the logout.

To log out your session, most likely this command will work:

	DISPLAY=:0 xfce4-session-logout --logout

If that doesn't work, it may be that your frozen sessions display is not `:0`. **This is pretty unusual**, but would be the case if you had multiple display sessions going on your machine (that would have be a pretty intentional thing on your part). You can figure out which display you are logged in on with a command such as `ps aux | grep Xorg | grep -v grep`. Determine which row is the session that crashed (most likely there will be only one row), and the display is indicated with something like `Xorg :<number> vt<other-number>`; your display is `:<number>`. Run the command with `:<number>` instead of `:0`.

To enable session saving before triggering the logout:

	xfconf-query -c xfce4-session -p /general/SaveOnExit -s true

From here, the recommended action is still to shutdown or reboot, but your window session will have been saved. In my experience so far, not many applications actually support Xfce window session saving on this Xubuntu version on Nautilus, so I am assuming that you would only do this if you happen to heavily use this feature already and know from past experience that many of your applications support this feature. 

#### Even more advanced, if you were doing something really important that has headless components/engagement options you want to try to recover/continue from

Given that you are in a terminal session now, you should be able to access headless or headless components of applications you were running before, and engage with them through command-line the same way you would otherwise. If this applies to you, I am going to assume you have the skills to attempt your own recovery from here. Headless applications very possibly did not crash, so you could query their status and work from that.

A simple note, running `sudo systemctl restart lightdm` has worked in restarting the display, if you want to simply have your display back and attempt a GUI-based recovery.

While you could operate as normal from there, I would still recommend rebooting at your earliest convenience; I am not sure what other issues the lid closing could have caused, and restarting lightdm could probably also cause some unexpected behavior.

### 8.11 Vertical screen flip script (`toggle-tent-mode.sh`) is not working

Most likely, the device id of your touchscreen is too dissimilar to the regex in the script. This could happen if your model or purchasing region varies too much from mine (I preseume - I don't really know how manufacturing works in this regard), or if you are using this project on a non-Nautilus for some reason (why are you doing that? I'd actually be very curious to know.)

Run the script directly in terminal. If that was the issue, you should see an error message that walks
you through fixing it locally.

### 8.12 Touchscreen is behaving strangely

If you use the tent-mode or portrait-mode scripts while connected to or before connecting to an external display, this can cause the transformation of the touchscreen input to be incorrect. This would look like the cursor not correctly aligning with your finger on the touch screen, or the direction you slide your finger not aligning with the cursor.

Running the tent-mode or portrait-mode scripts again until you are back into your desired orientation should fix the issue. If for some reason that does not work, a logout or reboot should work. If that does not work, then it is probably a different issue altogether.

### 8.12 Notable Debugging Tools/Commands

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

- **Works Out of the Box**: The front-facing webcam (labeled something like *720p HD Camera*) typically works fine without the `detect-webcam.sh` script. However, you might see *several* `/dev/videoX` devices in some apps, and only one of them is the real camera feed.

- **Symlink Behavior**:  
  If you do enable `detect-webcam.sh`, you can then run:
  
      guvcview -d /dev/webcam
  
  to confirm it opens your live camera feed.  
  - **Cheese & ffplay** didn't accept an explicit `/dev/webcam` argument for me, but they still detected the camera automatically so that it could be manually selected from a list.

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
	+ The only times I noticed (mildly) concerning lag was when I was running a heavy apt install with multiple other things open.

- **Battery Life**:  
  - I don’t have precise or everyday-use measurements yet because I’ve been consistently doing heavy installs and testing.  
  - It might drain a bit faster than ChromeOS did, but still significantly better than my i7 ultrabook in comparable usage.  
  - Under typical (light) usage, you could still see very good battery life—just not necessarily identical to how it was ChromeOS at my machine's prime.
- **Sleep-mode battery life**
  - Based on the extremely limited data of "I left my machine on sleep mode overnight once," the battery went down about 15% being suspended overnight.
  - Remember that if you want to enter sleep mode, do it **before closing the lid**, as this breaks stuff. Recovery options from this breakage described [here](#lid-close-recovery).
- **External Displays**
  - I have hooked this into a docking station and KVM switch, and it works great on the display port output. I have not yet tried multiple external displays.
- **Miscellaneous**:  
  - Krita and Xournal++ seem to work great though for stylus drawing and note taking, including pressure-sensitivity and palm-rejection working out of the box. Much more smooth than the Android apps I was using most recently.
  - I tried OpenBoard, but had trouble getting dependencies to work.
  - GIMP runs smoothly but stylus stuff like pressure sensitivity did not work out of the box, and I haven't made a strong effort to get it to work. In settings, the stylus did not seem to be detected in Input Devices, so potentially more configuration is needed.
  - I successfully was able to install browsers Google Chrome, Firefox, Tor Browser, Opera, Vivaldi, Brave, and Falkon, but did not use them beyond confirming that keymappings and gestures worked.
  - Ghostwrite has been working great for writing this README.
  - Basic dev tools needed for interacting with github (i.e. gh for authorization, mousepad for text editing, meld for diff viewing) have worked great. I have not attempted heavier development.

<a name="uefi"></a>
## 12. UEFI Firmware Installation (Non-Comprehensive Summary)

[⬆️ Back to top](#top)  
[🔗 Back to TOC](#toc)

*This is **not** a full guide. Before proceeding with any firmware changes, thoroughly read [MrChromebox’s documentation](https://docs.mrchromebox.tech/docs/getting-started.html). The steps below are only additional notes specific to the Samsung Chromebook Plus v2 (Nautilus), and are not meant as a full guide by any means.*

1. **Tools Needed**  
   - A small screwdriver  
   - A thin-edged tool (e.g., a small plastic pry tool or a blunt knife) to help gently pop off the back cover  
   - A USB-C flash drive  
   - A USB-C charger that can power the device *without* its battery connected (**Note**: higher-watt chargers are unlikely to work; your safest option is the official Google charger. You could test this out before making irreversible software changes, but doing so could still void warranties potentially.)

2. **Checking Device Compatibility**  
   - Verify that your Chromebook is the Samsung Chromebook Plus v2 (codename “Nautilus”).  
   - If unsure, open `chrome://version` in Chrome to confirm.  
   - At time of this writing, Nautilus is supported by the MrChromebox tools. You can double check [here](https://docs.mrchromebox.tech/docs/supported-devices.html)

3. **Developer Mode**  
   - Enabling Developer Mode **will** wipe the device. Be sure to backup important files.  
   - After doing so, you’ll boot into a Developer Mode environment (not the standard ChromeOS desktop).

4. **Disabling Hardware Write Protection**  
   - You disable write protection at the hardware level by removing the bottom cover and disconnecting the battery.  
   - With the battery unplugged, you must power the device via a suitable USB-C charger.  
   - The first minute of [this Youtube video](https://www.youtube.com/watch?v=dKZEH0U9Mto) may be helpful.

5. **Installing the Firmware**  
   - Have USB-C flash drive handy for creating a backup of your existing firmware (strongly recommended, will likely make fixes easier if things go wrong). The firmware tool walks you through this.  
   - Run the MrChromebox firmware utility script. It will require a reboot to disable firmware write protection, then proceed with installing the UEFI ROM.
   - Overall the MrChromebox software hand-holds you through the process very well in my opinion.

6. **Alternative: RW_LEGACY + dual-boot**  
   - If you prefer dual-booting ChromeOS and Linux, you can install RW_LEGACY firmware instead (MrChromebox also provides tools for this), which does not appear require disabling hardware write protection (I think).  
   - This project assumes on full UEFI firmware replacement, but it might work with dual-booting Xubuntu as well.  
   - I did not attempt this at all, so I have no first-hand experience.

**Important:** If you read this far into this section but have *not* gone through MrChromebox’s documentation in detail, you are *not* prepared to do this responsibly. These steps only provide brief additional notes for Nautilus devices (and Nautilus devices only); the official MrChromebox documentation remains your primary reference.

---

