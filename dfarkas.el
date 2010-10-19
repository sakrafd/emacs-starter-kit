;;; dfarkas.el --- Some helpful dfarkas code
;; DESCRIPTION: dfarkas settings

(setq initial-frame-alist '(
                    (top . 40) (left . 50)
                    (width . 250) (height . 68)
                    )
  )


(add-to-list 'load-path (concat dotfiles-dir "/vendor"))

;; Save backups in one place
;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
  (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))

(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))



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


;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

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

;; Javascript
;; TODO javascript-indent-level 2

;; Rinari
(add-to-list 'load-path (concat dotfiles-dir "/vendor/jump.el"))
(add-to-list 'load-path (concat dotfiles-dir "/vendor/rinari"))

(require 'rinari)

(define-key rinari-minor-mode-map [(control meta shift down)] 'rinari-find-rspec)
(define-key rinari-minor-mode-map [(control meta shift left)] 'rinari-find-controller)
(define-key rinari-minor-mode-map [(control meta shift up)] 'rinari-find-model)
(define-key rinari-minor-mode-map [(control meta shift right)] 'rinari-find-view)

;; (autoload 'applescript-mode "applescript-mode" "major mode for editing AppleScript source." t)
;; (setq auto-mode-alist
;;       (cons '("\\.applescript$" . applescript-mode) auto-mode-alist))


(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)

(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
(define-key haml-mode-map [(control meta down)] 'haml-forward-sexp)
(define-key haml-mode-map [(control meta up)] 'haml-backward-sexp)
(define-key haml-mode-map [(control meta left)] 'haml-up-list)
(define-key haml-mode-map [(control meta right)] 'haml-down-list)

(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))

(add-to-list 'auto-mode-alist '("\\.sake\\'" . ruby-mode))

;; XCODE
(require 'objc-c-mode)
(require 'xcode)
(define-key objc-mode-map [(meta r)] 'xcode-compile)
(define-key objc-mode-map [(meta K)] 'xcode-clean)
(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key  [(meta O)] 'ff-find-other-file)))
(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key (kbd "C-c <right>") 'hs-show-block)
            (local-set-key (kbd "C-c <left>")  'hs-hide-block)
            (local-set-key (kbd "C-c <up>")    'hs-hide-all)
            (local-set-key (kbd "C-c <down>")  'hs-show-all)
            (hs-minor-mode t)))         ; Hide and show blocks

;; Font
;; (set-face-font 'default "-apple-inconsolata-medium-r-normal--20-0-72-72-m-0-iso10646-1")

;; Color Themes
(add-to-list 'load-path (concat dotfiles-dir "/vendor/color-theme"))
(require 'color-theme)
(color-theme-initialize)

;; Functions

(require 'line-num)

;; Full screen toggle
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                         'fullboth)))
(global-set-key (kbd "M-n") 'toggle-fullscreen)


;; Keyboard

;; Split Windows
(global-set-key [f6] 'split-window-horizontally)
(global-set-key [f7] 'split-window-vertically)
(global-set-key [f8] 'delete-window)

;; Some Mac-friendly key counterparts
(global-set-key (kbd "M-s") 'save-buffer)
(global-set-key (kbd "M-z") 'undo)
(global-set-key (kbd "M-l") 'goto-line)

;; Keyboard Overrides
(define-key textile-mode-map (kbd "M-s") 'save-buffer)
(define-key text-mode-map (kbd "M-s") 'save-buffer)

(global-set-key [(meta up)] 'beginning-of-buffer)
(global-set-key [(meta down)] 'end-of-buffer)

(global-set-key [(meta shift right)] 'ido-switch-buffer)
(global-set-key [(meta shift up)] 'recentf-ido-find-file)
(global-set-key [(meta shift down)] 'ido-find-file)
(global-set-key [(meta shift left)] 'magit-status)

(global-set-key [(meta H)] 'delete-other-windows)

(global-set-key [(meta D)] 'backward-kill-word) ;; (meta d) is opposite

(global-set-key [(meta N)] 'cleanup-buffer)

(global-set-key [(control \])] 'indent-rigidly)

;; Other

(prefer-coding-system 'utf-8)

(server-start)

;; Experimentation
;; TODO Move to separate theme file.

;;; theme-start
(defun dfarkas-reload-theme ()
  "Reload init.el and the color-theme-dfarkas"
  (interactive)
  (save-buffer)
  (eval-buffer)
  (color-theme-dfarkas))

(global-set-key [f8] 'dfarkas-reload-theme)

;; theme-colors
;; yellow: #ffffcc
;; blue:   #6688ee
;; green:  #52c62b
;; lightest grey: #f1f1f1
;; greys: #aa, #bb, #cc
;; light blue:    #c2cff1
(defun color-theme-dfarkas ()
  "Attempt at a modern theme."
  (interactive)
  (color-theme-install
   '(color-theme-dfarkas
     ((background-color . "black")
      (background-mode . dark)
      (border-color . "black")
      (cursor-color . "red")
      (foreground-color . "Gray80")
      (mouse-color . "white"))
     ((align-highlight-change-face . highlight)
      (align-highlight-nochange-face . secondary-selection)
      (apropos-keybinding-face . underline)
      (apropos-label-face . italic)
      (apropos-match-face . secondary-selection)
      (apropos-property-face . bold-italic)
      (apropos-symbol-face . bold)
;;      (display-time-mail-face . mode-line)
      (ebnf-except-border-color . "Black")
      (ebnf-line-color . "Black")
      (ebnf-non-terminal-border-color . "Black")
      (ebnf-repeat-border-color . "Black")
      (ebnf-special-border-color . "Black")
      (ebnf-terminal-border-color . "Black")
      (gnus-article-button-face . bold)
      (gnus-article-mouse-face . highlight)
      (gnus-carpal-button-face . bold)
      (gnus-carpal-header-face . bold-italic)
      (gnus-cite-attribution-face . gnus-cite-attribution-face)
      (gnus-mouse-face . highlight)
      (gnus-selected-tree-face . modeline)
      (gnus-signature-face . gnus-signature-face)
      (gnus-summary-selected-face . gnus-summary-selected-face)
      (help-highlight-face . underline)
      (list-matching-lines-face . bold)
      (ps-line-number-color . "black")
      (ps-zebra-color . 0.95)
      (tags-tag-face . default)
      (vc-annotate-very-old-color . "#0046FF")
      (view-highlight-face . highlight)
      (widget-mouse-face . highlight))
     (default ((t (:stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :family "outline-courier new"))))
     (Info-title-1-face ((t (:bold t :weight bold :family "helv" :height 1.728))))
     (Info-title-2-face ((t (:bold t :family "helv" :weight bold :height 1.44))))
     (Info-title-3-face ((t (:bold t :weight bold :family "helv" :height 1.2))))
     (Info-title-4-face ((t (:bold t :family "helv" :weight bold))))
     (bbdb-company ((t (:italic t :slant italic))))
     (bbdb-field-name ((t (:bold t :weight bold))))
     (bbdb-field-value ((t (nil))))
     (bbdb-name ((t (:underline t))))
     (bold ((t (:bold t :weight bold))))
     (bold-italic ((t (:italic t :bold t :slant italic :weight bold))))
     (border ((t (:background "black"))))
     (change-log-acknowledgement-face ((t (:italic t :slant oblique :foreground "AntiqueWhite3"))))
     (change-log-conditionals-face ((t (:foreground "Aquamarine"))))
     (change-log-date-face ((t (:italic t :slant oblique :foreground "BurlyWood"))))
     (change-log-email-face ((t (:foreground "Aquamarine"))))
     (change-log-file-face ((t (:bold t :family "Verdana" :weight bold :foreground "LightSkyBlue" :height 0.9))))
     (change-log-function-face ((t (:foreground "Aquamarine"))))
     (change-log-list-face ((t (:foreground "LightSkyBlue"))))
     (change-log-name-face ((t (:bold t :weight bold :foreground "Gold"))))
     (clear-case-mode-string-face ((t (:bold t :family "Arial" :box (:line-width 2 :color "grey" :style released-button) :foreground "black" :background "grey" :weight bold :height 0.9))))
     (comint-highlight-input ((t (:bold t :weight bold))))
     (comint-highlight-prompt ((t (:foreground "cyan"))))
     (cursor ((t (:background "yellow"))))
     (custom-button-face ((t (:background "lightgrey" :foreground "black" :box (:line-width 2 :style released-button)))))
     (custom-button-pressed-face ((t (:background "lightgrey" :foreground "black" :box (:line-width 2 :style pressed-button)))))
     (custom-changed-face ((t (:background "blue" :foreground "white"))))
     (custom-comment-face ((t (:background "dim gray"))))
     (custom-comment-tag-face ((t (:foreground "gray"))))
     (custom-documentation-face ((t (nil))))
     (custom-face-tag-face ((t (:bold t :family "helv" :weight bold :height 1.1))))
     (custom-group-tag-face ((t (:bold t :family "helv" :foreground "light blue" :weight bold :height 1.1))))
     (custom-group-tag-face-1 ((t (:bold t :family "helv" :foreground "pink" :weight bold :height 1.1))))
     (custom-invalid-face ((t (:background "red" :foreground "yellow"))))
     (custom-modified-face ((t (:background "blue" :foreground "white"))))
     (custom-rogue-face ((t (:background "black" :foreground "pink"))))
     (custom-saved-face ((t (:underline t))))
     (custom-set-face ((t (:background "white" :foreground "blue"))))
     (custom-state-face ((t (:foreground "lime green"))))
     (custom-variable-button-face ((t (:bold t :underline t :weight bold))))
     (custom-variable-tag-face ((t (:bold t :family "helv" :foreground "light blue" :weight bold :height 1.2))))
     (date ((t (:foreground "green"))))
     (diary-face ((t (:bold t :foreground "IndianRed" :weight bold))))
     (diff-added-face ((t (nil))))
     (diff-changed-face ((t (nil))))
     (diff-context-face ((t (:foreground "grey70"))))
     (diff-file-header-face ((t (:bold t :background "grey60" :weight bold))))
     (diff-function-face ((t (:foreground "grey70"))))
     (diff-header-face ((t (:background "grey45"))))
     (diff-hunk-header-face ((t (:background "grey45"))))
     (diff-index-face ((t (:bold t :weight bold :background "grey60"))))
     (diff-nonexistent-face ((t (:bold t :weight bold :background "grey60"))))
     (diff-removed-face ((t (nil))))
     (erc-action-face ((t (:bold t :weight bold))))
     (erc-bold-face ((t (:bold t :weight bold))))
     (erc-default-face ((t (nil))))
     (erc-direct-msg-face ((t (:foreground "pale green"))))
     (erc-error-face ((t (:bold t :foreground "IndianRed" :weight bold))))
     (erc-highlight-face ((t (:bold t :foreground "pale green" :weight bold))))
     (erc-host-danger-face ((t (:foreground "red"))))
     (erc-input-face ((t (:foreground "light blue"))))
     (erc-inverse-face ((t (:background "steel blue"))))
     (erc-notice-face ((t (:foreground "light salmon"))))
     (erc-pal-face ((t (:foreground "pale green"))))
     (erc-prompt-face ((t (:bold t :foreground "light blue" :weight bold))))
     (erc-underline-face ((t (:underline t))))
     (eshell-ls-archive-face ((t (:bold t :foreground "IndianRed" :weight bold))))
     (eshell-ls-backup-face ((t (:foreground "Grey"))))
     (eshell-ls-clutter-face ((t (:bold t :foreground "DimGray" :weight bold))))
     (eshell-ls-directory-face ((t (:bold t :foreground "MediumSlateBlue" :weight bold))))
     (eshell-ls-executable-face ((t (:bold t :foreground "Coral" :weight bold))))
     (eshell-ls-missing-face ((t (:bold t :foreground "black" :weight bold))))
     (eshell-ls-picture-face ((t (:foreground "Violet"))))
     (eshell-ls-product-face ((t (:foreground "LightSalmon"))))
     (eshell-ls-readonly-face ((t (:foreground "Aquamarine"))))
     (eshell-ls-special-face ((t (:bold t :foreground "Gold" :weight bold))))
     (eshell-ls-symlink-face ((t (:bold t :foreground "White" :weight bold))))
     (eshell-ls-text-face ((t (:foreground "medium aquamarine"))))
     (eshell-ls-todo-face ((t (:bold t :foreground "aquamarine" :weight bold))))
     (eshell-ls-unreadable-face ((t (:foreground "DimGray"))))
     (eshell-prompt-face ((t (:foreground "red"))))
     (face-1 ((t (:stipple nil :foreground "royal blue" :family "andale mono"))))
     (face-2 ((t (:stipple nil :foreground "DeepSkyBlue1" :overline nil :underline nil :slant normal :family "Inconsolata"))))
     (face-3 ((t (:stipple nil :foreground "NavajoWhite3"))))
     (fg:erc-color-face0 ((t (:foreground "white"))))
     (fg:erc-color-face1 ((t (:foreground "beige"))))
     (fg:erc-color-face10 ((t (:foreground "pale goldenrod"))))
     (fg:erc-color-face11 ((t (:foreground "light goldenrod yellow"))))
     (fg:erc-color-face12 ((t (:foreground "light yellow"))))
     (fg:erc-color-face13 ((t (:foreground "yellow"))))
     (fg:erc-color-face14 ((t (:foreground "light goldenrod"))))
     (fg:erc-color-face15 ((t (:foreground "lime green"))))
     (fg:erc-color-face2 ((t (:foreground "lemon chiffon"))))
     (fg:erc-color-face3 ((t (:foreground "light cyan"))))
     (fg:erc-color-face4 ((t (:foreground "powder blue"))))
     (fg:erc-color-face5 ((t (:foreground "sky blue"))))
     (fg:erc-color-face6 ((t (:foreground "dark sea green"))))
     (fg:erc-color-face7 ((t (:foreground "pale green"))))
     (fg:erc-color-face8 ((t (:foreground "medium spring green"))))
     (fg:erc-color-face9 ((t (:foreground "khaki"))))
     (fixed-pitch ((t (:family "courier"))))
     (font-lock-builtin-face ((t (:foreground "darkolivegreen"))))
     (font-lock-comment-face ((t (:italic t :foreground "dark green" :slant oblique)))) ;; comment text
     (font-lock-constant-face ((t (:bold t :foreground "dark khaki" :weight bold)))) ;; symbol names
     (font-lock-doc-face ((t (:italic t :slant oblique :foreground "BurlyWood"))))
     (font-lock-doc-string-face ((t (:italic t :slant oblique :foreground "BurlyWood"))))
     (font-lock-function-name-face ((t (:bold t :foreground "#888" :weight bold :height 0.9 :family "Verdana")))) ;; function name
     (font-lock-keyword-face ((t (:foreground "SteelBlue")))) ;; keyword def-end-class-etc...
     (font-lock-preprocessor-face ((t (:bold t :foreground "Gold" :weight bold))))
     (font-lock-reference-face ((t (:foreground "SteelBlue"))))
     (font-lock-string-face ((t (:italic t :foreground "slategrey" :slant oblique)))) ;; string
     (font-lock-type-face ((t (:bold t :foreground "firebrick" :weight bold :height 0.9 :family "Verdana")))) ;; class names 
     (font-lock-variable-name-face ((t (:foreground "Brown4"))))  ;; @variables and defaults
     (font-lock-warning-face ((t (:bold t :foreground "chocolate" :weight bold))))
     (fringe ((t (:family "outline-courier new" :width normal :weight normal :slant normal :underline nil :overline nil :strike-through nil :box nil :inverse-video nil :stipple nil :background "grey4" :foreground "Wheat"))))
     (gnus-cite-attribution-face ((t (:italic t :slant italic))))
     (gnus-cite-face-1 ((t (:foreground "light blue"))))
     (gnus-cite-face-10 ((t (:foreground "medium purple"))))
     (gnus-cite-face-11 ((t (:foreground "turquoise"))))
     (gnus-cite-face-2 ((t (:foreground "light cyan"))))
     (gnus-cite-face-3 ((t (:foreground "light yellow"))))
     (gnus-cite-face-4 ((t (:foreground "light pink"))))
     (gnus-cite-face-5 ((t (:foreground "pale green"))))
     (gnus-cite-face-6 ((t (:foreground "beige"))))
     (gnus-cite-face-7 ((t (:foreground "orange"))))
     (gnus-cite-face-8 ((t (:foreground "magenta"))))
     (gnus-cite-face-9 ((t (:foreground "violet"))))
     (gnus-emphasis-bold ((t (:bold t :weight bold))))
     (gnus-emphasis-bold-italic ((t (:italic t :bold t :slant italic :weight bold))))
     (gnus-emphasis-highlight-words ((t (:background "black" :foreground "yellow"))))
     (gnus-emphasis-italic ((t (:italic t :slant italic))))
     (gnus-emphasis-underline ((t (:underline t))))
     (gnus-emphasis-underline-bold ((t (:bold t :underline t :weight bold))))
     (gnus-emphasis-underline-bold-italic ((t (:italic t :bold t :underline t :slant italic :weight bold))))
     (gnus-emphasis-underline-italic ((t (:italic t :underline t :slant italic))))
     (gnus-group-mail-1-empty-face ((t (:foreground "aquamarine1"))))
     (gnus-group-mail-1-face ((t (:bold t :foreground "aquamarine1" :weight bold))))
     (gnus-group-mail-2-empty-face ((t (:foreground "aquamarine2"))))
     (gnus-group-mail-2-face ((t (:bold t :foreground "aquamarine2" :weight bold))))
     (gnus-group-mail-3-empty-face ((t (:foreground "aquamarine3"))))
     (gnus-group-mail-3-face ((t (:bold t :foreground "aquamarine3" :weight bold))))
     (gnus-group-mail-low-empty-face ((t (:foreground "aquamarine4"))))
     (gnus-group-mail-low-face ((t (:bold t :foreground "aquamarine4" :weight bold))))
     (gnus-group-news-1-empty-face ((t (:foreground "PaleTurquoise"))))
     (gnus-group-news-1-face ((t (:bold t :foreground "PaleTurquoise" :weight bold))))
     (gnus-group-news-2-empty-face ((t (:foreground "turquoise"))))
     (gnus-group-news-2-face ((t (:bold t :foreground "turquoise" :weight bold))))
     (gnus-group-news-3-empty-face ((t (nil))))
     (gnus-group-news-3-face ((t (:bold t :weight bold))))
     (gnus-group-news-4-empty-face ((t (nil))))
     (gnus-group-news-4-face ((t (:bold t :weight bold))))
     (gnus-group-news-5-empty-face ((t (nil))))
     (gnus-group-news-5-face ((t (:bold t :weight bold))))
     (gnus-group-news-6-empty-face ((t (nil))))
     (gnus-group-news-6-face ((t (:bold t :weight bold))))
     (gnus-group-news-low-empty-face ((t (:foreground "DarkTurquoise"))))
     (gnus-group-news-low-face ((t (:bold t :foreground "DarkTurquoise" :weight bold))))
     (gnus-header-content-face ((t (:italic t :foreground "forest green" :slant italic))))
     (gnus-header-from-face ((t (:foreground "spring green"))))
     (gnus-header-name-face ((t (:foreground "SeaGreen"))))
     (gnus-header-newsgroups-face ((t (:italic t :foreground "yellow" :slant italic))))
     (gnus-header-subject-face ((t (:foreground "SeaGreen3"))))
     (gnus-signature-face ((t (:italic t :slant italic))))
     (gnus-splash-face ((t (:foreground "Brown"))))
     (gnus-summary-cancelled-face ((t (:background "black" :foreground "yellow"))))
     (gnus-summary-high-ancient-face ((t (:bold t :foreground "SkyBlue" :weight bold))))
     (gnus-summary-high-read-face ((t (:bold t :foreground "PaleGreen" :weight bold))))
     (gnus-summary-high-ticked-face ((t (:bold t :foreground "pink" :weight bold))))
     (gnus-summary-high-unread-face ((t (:bold t :weight bold))))
     (gnus-summary-low-ancient-face ((t (:italic t :foreground "SkyBlue" :slant italic))))
     (gnus-summary-low-read-face ((t (:italic t :foreground "PaleGreen" :slant italic))))
     (gnus-summary-low-ticked-face ((t (:italic t :foreground "pink" :slant italic))))
     (gnus-summary-low-unread-face ((t (:italic t :slant italic))))
     (gnus-summary-normal-ancient-face ((t (:foreground "SkyBlue"))))
     (gnus-summary-normal-read-face ((t (:foreground "PaleGreen"))))
     (gnus-summary-normal-ticked-face ((t (:foreground "pink"))))
     (gnus-summary-normal-unread-face ((t (nil))))
     (gnus-summary-selected-face ((t (:underline t))))
     (header-line ((t (:family "Arial" :background "grey20" :foreground "grey75" :box (:line-width 3 :color "grey20" :style released-button) :height 0.9))))
     (highlight ((t (:background "darkolivegreen"))))
     (info-header-node ((t (:italic t :bold t :weight bold :slant italic :foreground "white"))))
     (info-header-xref ((t (:bold t :weight bold :foreground "cyan"))))
     (info-menu-5 ((t (:foreground "red1"))))
     (info-menu-header ((t (:bold t :family "helv" :weight bold))))
     (info-node ((t (:italic t :bold t :foreground "white" :slant italic :weight bold))))
     (info-xref ((t (:bold t :foreground "cyan" :weight bold))))
     (isearch ((t (:background "palevioletred2"))))
     (isearch-lazy-highlight-face ((t (:background "paleturquoise4"))))
     (italic ((t (:italic t :slant italic))))
     (makefile-space-face ((t (:background "hotpink"))))
     (menu ((t (nil))))
     (message-cited-text-face ((t (:foreground "red"))))
     (message-header-cc-face ((t (:bold t :foreground "green4" :weight bold))))
     (message-header-name-face ((t (:foreground "DarkGreen"))))
     (message-header-newsgroups-face ((t (:italic t :bold t :foreground "yellow" :slant italic :weight bold))))
     (message-header-other-face ((t (:foreground "#b00000"))))
     (message-header-subject-face ((t (:foreground "green3"))))
     (message-header-to-face ((t (:bold t :foreground "green2" :weight bold))))
     (message-header-xheader-face ((t (:foreground "blue"))))
     (message-mml-face ((t (:foreground "ForestGreen"))))
     (message-separator-face ((t (:foreground "blue3"))))
     (modeline ((t (:background "grey" :foreground "black" :box (:line-width 2 :color "grey" :style released-button) :height 0.9 :family "Arial"))))
     (modeline-mousable-minor-mode ((t (:background "grey" :foreground "black" :box (:line-width 2 :color "grey" :style released-button) :height 0.9 :family "Arial"))))
     (modeline-mousable ((t (:background "grey" :foreground "black" :box (:line-width 2 :color "grey" :style released-button) :height 0.9 :family "Arial"))))
     (modeline-buffer-id ((t (:background "grey" :foreground "black" :box (:line-width 2 :color "grey" :style released-button) :height 0.9 :family "Arial"))))
     (mouse ((t (:background "white"))))
     (primary-selection ((t (:background "DarkSlateGray"))))
     (region ((t (:background "DarkSlateGray"))))
     (scroll-bar ((t (nil))))
     (secondary-selection ((t (:background "SkyBlue4"))))
     (tool-bar ((t (:background "grey75" :foreground "black" :box (:line-width 1 :style released-button)))))
     (trailing-whitespace ((t (:background "white"))))
     (underline ((t (:underline t))))
     (variable-pitch ((t (:family "helv"))))
     (widget-button-face ((t (:bold t :weight bold))))
     (widget-button-pressed-face ((t (:foreground "red"))))
     (widget-documentation-face ((t (:foreground "lime green"))))
     (widget-field-face ((t (:background "dim gray"))))
     (widget-inactive-face ((t (:foreground "light gray"))))
     (widget-single-line-field-face ((t (:background "dim gray"))))
     (zmacs-region ((t (:background "DarkSlateGray")))))))

;;; theme-end

;; Activate theme
(color-theme-dfarkas)

;; personal-layout
(defun personal-layout ()
  "Arrange windows to my personal layout."
  (interactive)
  (delete-other-windows)
  (split-window-horizontally)
  (windmove-right)
  (split-window-vertically)
  (windmove-left))

(personal-layout)

;; C-tab to go through buffer like everywhere else

(global-set-key [C-tab] 'next-buffer)
(global-set-key [C-S-iso-lefttab] 'previous-buffer)

;; use M-{up,right,down,left} for windmove
(windmove-default-keybindings 'meta)


(provide 'dfarkas)
;; dfarkas.el ends here
