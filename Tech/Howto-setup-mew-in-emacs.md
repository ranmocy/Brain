---
title: Howto setup Mew in Emacs
created-at: 2012-06-27T22:38:20+08:00
updated-at: 2013-04-14T10:41:17+08:00
category: Tech
---

Homepage of Mew. http://www.Mew.org/

0. Setup stunnel
If you want to use Gmail or any other who force you to use SSL, you have to install stunnel.

    brew install stunnel

1. Get it.
Download from http://www.mew.org/en/download/
Current newest version: http://www.mew.org/Release/mew-6.5.tar.gz

2. Install it.

    tar zxf mew-6.5.tar.gz
    cd mew-6.5
    ./configure
    make
    make install

Or move it to your emacs folder and add it to your load-path

    (add-to-list load-path "/path/to/your/mew/")

CHECKPOINT:
  Now you should be able to (require 'mew) in your Emacs.

3. Setup your mew

Add-to-file `set-mew.el` and load it from your emacs configure.

    (autoload 'mew "mew" nil t)
    (autoload 'mew-send "mew" nil t)
    (setq mew-icon-directory
          (expand-file-name "etc" (file-name-directory (locate-library "mew.el"))))
    (setq mew-use-cached-passwd t)

    ;; Optional setup (Read Mail menu):
    (if (boundp 'read-mail-command)
        (setq read-mail-command 'mew))

    ;; Optional setup (e.g. C-xm for sending a message):
    (autoload 'mew-user-agent-compose "mew" nil t)
    (if (boundp 'mail-user-agent)
        (setq mail-user-agent 'mew-user-agent))
    (if (fboundp 'define-mail-user-agent)
        (define-mail-user-agent
          'mew-user-agent
          'mew-user-agent-compose
          'mew-draft-send-message
          'mew-draft-kill
          'mew-send-hook))

    (setq mew-pop-size 0)
    (setq mew-smtp-auth-list nil)
    (setq toolbar-mail-reader 'Mew)
    (set-default 'mew-decode-quoted 't)
    (when (boundp 'utf-translate-cjk)
      (setq utf-translate-cjk t)
      (custom-set-variables
       '(utf-translate-cjk t)))
    (if (fboundp 'utf-translate-cjk-mode)
        (utf-translate-cjk-mode 1))

    (defvar mew-cite-fields '("From:" "Subject:" "Date:"))
    (defvar mew-cite-format "From: %s\nSubject: %s\nDate: %s\n\n")
    (defvar mew-cite-prefix "> ")

    (setq mew-ssl-verify-level 0)
    (setq mew-use-cached-passwd t)

    (setq mew-signature-file "~/Mail/signature")
    (setq mew-signature-as-lastpart t)
    (setq mew-signature-insert-last t)
    (add-hook 'mew-before-cite-hook 'mew-header-goto-body)
    (add-hook 'mew-draft-mode-newdraft-hook 'mew-draft-insert-signature)

    ;; (setq mew-refile-guess-alist
    ;;       '(("To:"
    ;;          ("@octave.org"                       . "+math/octave")
    ;;          ("@freebsd.org"                      . "+unix/freebsd"))
    ;;         ("Cc:"
    ;;          ("@octave.org"                       . "+math/octave")
    ;;          ("@freebsd.org"                      . "+unix/freebsd"))
    ;;         (nil . "+inbox")))
    (setq mew-refile-guess-control
          '(mew-refile-guess-by-folder
            mew-refile-guess-by-alist))

    (setq mew-summary-form
          '(type (5 date) " " (14 from) " " t (0 subj)))
    (setq mew-summary-form-extract-rule '(name))

    ;; Password
    (setq mew-use-master-passwd t)

    ;;(setq mew-ssl-verify-level 0)
    (setq mew-prog-ssl "/usr/local/bin/stunnel")

Mew will read `~/.mew.el` when it's launched.

Add-to-file `~/.mew.el` :

    ;; setup mail info
    (setq mew-config-alist
          '(
            (default
              (mailbox-type          imap)
              (proto                 "%")
              (prog-ssl              "/usr/local/bin/stunnel")
              (imap-server           "imap.gmail.com")
              (imap-ssl-port         "993")
              (imap-user             "ranmocy@gmail.com")
              (name                  "Ranmocy Sheng")
              (user                  "ranmocy")
              (mail-domain           "gmail.com")
              (imap-ssl              t)
              (imap-size             0)
              (imap-delete           t)
              (imap-queue-folder     "%queue")
              (imap-trash-folder     "%Trash")
              ;; This must be in concile with your IMAP box setup
              (smtp-ssl              t)
              (smtp-auth-list        ("PLAIN" "LOGIN" "CRAM-MD5"))
              (smtp-user             "ranmocy@gmail.com")
              (smtp-server           "smtp.gmail.com")
              (smtp-ssl-port         "465")
              )))

OPTIONS:
If you want to read HTML email in mew:

Install emacs-w3m:

require `setup-emacs-w3m`

Add-to `set-mew.el`

    ;; HTML support
    (setq mew-mime-multipart-alternative-list '("Text/Html" "Text/Plain" "*."))
    (condition-case nil
        (require 'mew-w3m)
      (file-error nil))
    (setq mew-use-text/html t)

# Now-you-can #
1. Run `M-x mew` to run mew in your Emacs.
2. Press `i` to check new email in your Inbox.
3. Press `SPACE` on your email to read it, and it should support HTML format.

# Finish setup-mew-in-emacs #
