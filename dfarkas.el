;;; dfarkas.el --- Some helpful dfarkas code
;; DESCRIPTION: dfarkas settings

(setq initial-frame-alist '(
                    (top . 40) (left . 50)
                    (width . 350) (height . 68)
                    )
  )

;; Apply shell environment to emacs
;; http://paste.lisp.org/display/111574
(defun env-line-to-cons (env-line)
  "Convert a string of the form \"VAR=VAL\" to a
cons cell containing (\"VAR\" . \"VAL\")."
  (if (string-match "\\([^=]+\\)=\\(.*\\)" env-line)
    (cons (match-string 1 env-line) (match-string 2 env-line))))

(defun interactive-env-alist (&optional shell-cmd env-cmd)
  "Launch /usr/bin/env or the equivalent from a login
shell, parsing and returning the environment as an alist."
  (let ((cmd (concat (or shell-cmd "$SHELL -lc")
                     " "
                     (or env-cmd "/usr/bin/env"))))
    (mapcar 'env-line-to-cons
            (remove-if
             (lambda (str)
               (string-equal str ""))
             (split-string (shell-command-to-string cmd) "[\r\n]")))))

(defun setenv-from-cons (var-val)
  "Set an environment variable from a cons cell containing
two strings, where the car is the variable name and cdr is
the value, e.g. (\"VAR\" . \"VAL\")"
  (setenv (car var-val) (cdr var-val)))

(defun setenv-from-shell-environment (&optional shell-cmd env-cmd)
  "Apply the environment reported by `/usr/bin/env' (or env-cmd)
as launched by `$SHELL -lc' (or shell-cmd) to the current
environment."
  (mapc 'setenv-from-cons (interactive-env-alist shell-cmd env-cmd)))

(setenv-from-shell-environment)
(setq exec-path (split-string (getenv "PATH") path-separator))


(add-to-list 'load-path (concat dotfiles-dir "/vendor"))


;; prompt to save scratch file
(defvar scratch-buffer-file-name "~/sktch.el"
  "file name for *scratch* buffer")

(defun synch-scratch-with-file ()
  "replace *scratch* buffer with the file scratch-buffer-file-name"
  (save-window-excursion
    (find-file scratch-buffer-file-name)
    (kill-buffer "*scratch*")
    (rename-buffer "*scratch*")
    (lisp-interaction-mode)))
(synch-scratch-with-file)


(require 'dfarkas/meta)

(require 'dfarkas/plain-text)

;; Snippets
(add-to-list 'load-path (concat dotfiles-dir "/vendor/yasnippet.el"))
(require 'yasnippet)
(yas/initialize)
(yas/load-directory (concat dotfiles-dir "/vendor/yasnippet.el/snippets"))

;; Commands
(require 'unbound)

;; Minor Modes
(add-to-list 'load-path (concat dotfiles-dir "/vendor/textmate.el"))
(require 'textmate)
(textmate-mode)
(require 'whitespace)
(add-hook 'ruby-mode-hook 'whitespace-mode)

;; Major Modes

(add-to-list 'load-path (concat dotfiles-dir "/vendor/ruby-complexity"))
(add-to-list 'auto-mode-alist '("Capfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Isolate\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru\\'"   . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.sake\\'" . ruby-mode))

(require 'linum)
(require 'ruby-complexity)

(require 'dfarkas/js)

;; Remove scrollbars and make hippie expand
;; work nicely with yasnippet
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(require 'hippie-exp)
(setq hippie-expand-try-functions-list
      '(yas/hippie-try-expand
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        ;;        try-expand-dabbrev-from-kill
        ;;         try-complete-file-name
        ;;         try-complete-file-name-partially
        ;;         try-complete-lisp-symbol
        ;;         try-complete-lisp-symbol-partially
        ;;         try-expand-line
        ;;         try-expand-line-all-buffers
        ;;         try-expand-list
        ;;         try-expand-list-all-buffers
        ;;        try-expand-whole-kill
        ))

(defun indent-or-complete ()
  (interactive)
  (if (and (looking-at "$") (not (looking-back "^\\s-*")))
      (hippie-expand nil)
    (indent-for-tab-command)))
(add-hook 'find-file-hooks (function (lambda ()
                                       (local-set-key (kbd "TAB") 'indent-or-complete))))

;; dabbrev-case-fold-search for case-sensitive search

(require 'dfarkas/rinari)

(add-to-list 'load-path (concat dotfiles-dir "/vendor/rspec-mode"))
(require 'rspec-mode)

(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)


(require 'dfarkas/haml)
(require 'dfarkas/xcode)
(require 'dfarkas/keyboard)

;; gist
(require 'gist)

(prefer-coding-system 'utf-8)

;; Color Theme
(add-to-list 'load-path (concat dotfiles-dir "/vendor/color-theme"))
(require 'color-theme)
(color-theme-initialize)

;; Use the solarized-dark color theme
;;(add-to-list 'load-path (concat user-specific-dir "/color-theme-solarized"))
;;(require 'color-theme-solarized)
;;(color-theme-solarized-dark)
(load (concat dotfiles-dir "dfarkas/theme.el"))
(color-theme-dfarkas)

;; personal-layout
(defun personal-layout ()
  "Arrange windows to my personal layout."
  (interactive)
  (delete-other-windows)
  (split-window-horizontally)
  (split-window-horizontally)
  (windmove-right)
  (windmove-right)
  (split-window-vertically)
  (windmove-left)
  (windmove-left))

(personal-layout)


    ;; --------------------------------------------------------
    ;; nice little alternative visual bell; Miles Bader <miles /at/ gnu.org>

    (defcustom echo-area-bell-string "*DING* " ;"♪"
     "Message displayed in mode-line by `echo-area-bell' function."
     :group 'user)
    (defcustom echo-area-bell-delay 0.1
     "Number of seconds `echo-area-bell' displays its message."
     :group 'user)

    ;; internal variables
    (defvar echo-area-bell-cached-string nil)
    (defvar echo-area-bell-propertized-string nil)

    (defun echo-area-bell ()
     "Briefly display a highlighted message in the echo-area.

    The string displayed is the value of `echo-area-bell-string',
    with a red background; the background highlighting extends to the
    right margin.  The string is displayed for `echo-area-bell-delay'
    seconds.

    This function is intended to be used as a value of `ring-bell-function'."

     (unless (equal echo-area-bell-string echo-area-bell-cached-string)
       (setq echo-area-bell-propertized-string
             (propertize
              (concat
               (propertize
                "x"
                'display
                `(space :align-to (- right ,(+ 2 (length echo-area-bell-string)))))
               echo-area-bell-string)
              'face '(:background "red")))
       (setq echo-area-bell-cached-string echo-area-bell-string))
     (message echo-area-bell-propertized-string)
     (sit-for echo-area-bell-delay)
     (message ""))

    (setq ring-bell-function 'echo-area-bell)


(provide 'dfarkas)
;; dfarkas.el ends here
