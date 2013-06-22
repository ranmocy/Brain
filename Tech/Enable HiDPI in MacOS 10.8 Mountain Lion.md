---
title: Enable HiDPI in MacOS 10.8 Mountain Lion
created-at: 2013-03-11 15:47:53 +0800
updated-at: 2013-03-11 15:47:53 +0800
category: Tech
---

HiDPI is try to use 2x2 pixel to present 1x1 pixel

The traditional way to enable it is to use Quartz Debug.
But actually you can use `defaults` to do so.

    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES;
    sudo defaults delete /Library/Preferences/com.apple.windowserver DisplayResolutionDisabled;

Then, logout and log back to take effect.

Now go to Apple menu --> System Preferences --> Displays --> Display --> Scaled.
You'll see a bunch of "HiDPI" resolutions in the list to choose from.
