;; bundler.el --- Interact with Bundler from Emacs
;;
;; Copyright (c) 2011 Tobias Svensson <tob@tobiassvensson.co.uk>
;;
;; Released under the same license as GNU Emacs.

;; Keywords: bundler ruby
;; Created: 31 Dec 2011
;; Author: Tobias Svensson <tob@tobiassvensson.co.uk>
;; Version: 1

;; This file is NOT part of GNU Emacs.

;; Commentary:

;; Interact with Bundler from Emacs.
;;
;; 1) bundle-open
;;
;;    Wraps 'bundle open' which, if the given gem is installed and has been
;;    required correctly, will open the gem's source directory with dired.
;;
;; 2) bundle-console
;;
;;    Starts an inferior ruby process in the context of the current bundle
;;    using 'bundle console' (requires inf-ruby to be installed).
;;
;; 3) bundle-install, bundle-update, bundle-check
;;
;;    Runs the corresponding Bundler command with async-shell-command and
;;    *Bundler* as the target buffer. This exists so the output won't mess
;;    with the default buffer used by M-& and async-shell-command.

;; Installation:
;;
;; $ cd ~/.emacs.d/vendor
;; $ git clone git://github.com/tobiassvn/bundler.el.git
;;
;; In your emacs config:
;;
;; (add-to-list 'load-path "~/.emacs.d/vendor/bundler.el")
;; (require 'bundler)

;; Depends on inf-ruby
(require 'inf-ruby)

;; Commands
;; --------

(defun bundle-open (gem-name)
  "Queries for a gem name and opens the location of the gem in dired."
  (interactive (list (read-from-minibuffer "Bundled gem: "
                                           (first query-replace-defaults))))
    (if (= (length gem-name) 0)
        (message "No gem name given.")
      (let ((gem-location (bundle-gem-location gem-name)))
        (if (= (length gem-location) 0)
            (message "Gem not found or Gemfile missing.")
          (dired gem-location)))))

(defun bundle-console ()
  "Run an inferior Ruby process in the context of the current bundle."
  (interactive)
  (run-ruby "bundle console"))

(defun bundle-check ()
  "Run bundle check for the current bundle."
  (interactive)
  (bundle-command "bundle check"))

(defun bundle-install ()
  "Run bundle install for the current bundle."
  (interactive)
  (bundle-command "bundle install"))

(defun bundle-update ()
  "Run bundle update for the current bundle."
  (interactive)
  (bundle-command "bundle update"))

;; Utilities
;; ---------

(defun bundle-command (cmd)
  "Run cmd in an async buffer."
  (async-shell-command cmd "*Bundler*"))

(defun bundle-gem-location (gem-name)
  "Returns the location of the given gem or an empty string"
  "if it has not been resolved."
  (let ((bundler-stdout
         (shell-command-to-string
          (format "bundle show %s" (shell-quote-argument gem-name)))))
    (if (or (string-match "Could not locate Gemfile" bundler-stdout)
            (string-match "Could not find gem" bundler-stdout))
        ""
      (concat (replace-regexp-in-string "\n" "" bundler-stdout) "/"))))

(provide 'bundler)
