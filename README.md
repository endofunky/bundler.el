# bundler.el

Interact with [Bundler](http://gembundler.com/) from Emacs.

## Overview

1) `bundle-open` wraps *bundle open* which, if the given gem is installed
   and has been required correctly, will open the gem's source directory
   with *dired*.

2) `bundle-console` starts an inferior ruby process in the context of the
   current bundle using 'bundle console' (requires inf-ruby to be installed).

3) `bundle-install`, `bundle-update`, `bundle-check` run the corresponding
   Bundler commands with `async-shell-command` and _\*Bundler\*_ as the
   target buffer. This exists so the output won't mess with the default
   buffer used by *M-&* and `async-shell-command`.

## Installation

    $ cd ~/.emacs.d/vendor
    $ git clone git://github.com/tobiassvn/bundler.el.git

In your Emacs config:

    (add-to-list 'load-path "~/.emacs.d/vendor/bundler.el")
    (require 'bundler)

## License

Copyright 2011 (c) Tobias Svensson <tob@tobiassvensson.co.uk>

Released under the same license as GNU Emacs.
