---
title: Howto Add Custom Keys to iTerm2
created_at: 2014-11-02T20:16:39-0800
updated_at: 2014-11-02T20:16:39-0800
category: Tech
---

If you want to:

* add key-bindings to manipulate input by word
* add `option-del` to delete word
* add your own custom keys to iTerms

then please read on.

1. Open iTerm2's Preferences
2. Switch to `Profiles` tab
3. Select your profile on the left and switch to tab `Keys` on the right
4. Add your custom keys by click on `+` button
5. Focus on input `Keyboard Shortcut` in the new dialog and press the target key
6. Select action `Send Hex Code` or `Send Escape Sequence`
7. Add the hex code

For the most common Hex Code:

* **Move backward**: `Send Escape Sequence` + `b`
* **Move forward**: `Send Escape Sequence` + `f`
* **Backspace word**: `0x1b 0x08`
* **Delete word(forward)**: `Send Escape Sequence` + `d`

Here is the [Full ASCII Table](http://www.neurophys.wisc.edu/comp/docs/ascii/ascii-printable.html)
