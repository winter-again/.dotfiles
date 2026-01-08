;; NOTE: create this blank file so emacs doesn't complain
;; define custom file so Emacs doesn't touch this file
(setq custom-file "~/.config/emacs/emacs-custom.el")
(load custom-file)
;; set where Emacs saves backups to, could also just disable
(setq backup-directory-alist '(("." . "~/.local/share/emacs_backups")))

;; disable startup screen
;; (setq inhibit-startup-screen t)

;; remove tool bar, menu bar, scroll bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
;; font
(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font Mono-13"))
;; disable cursor blink
(blink-cursor-mode 0)
;; cursor line
(global-hl-line-mode 1)
;; line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
;; scrolling
;; value > 100 means redisplay will never recenter point (line-by-line scrolling)
(setq scroll-conservatively 101
  scroll-margin 4)

;; disable case-sensitivity for file and buf matching
(setq read-file-name-completion-ignore-case t
  read-buffer-completion-ignore-case t
  completion-ignore-case t)

;; add MELPA; GNU ELPA and NonGNU ELPA are already defaults
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;; automatically update package list iff there is no existing list
(unless package-archive-contents
  (package-refresh-contents))
;; if set, won't need every package to declare :ensure t
;; (setq use-package-always-ensure t)

;; theme
(use-package gruvbox-theme 
  :ensure t
  :config
  ;; gruvbox-dark-medium is fine too
  (load-theme 'gruvbox-dark-hard))

;; evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil) ;; expected by evil-collection
  (setq evil-want-C-u-scroll t) ;; use C-u for scrolling up
  (setq evil-want-empty-ex-last-command nil) ;; don't populate ex prompt with last command
  :config
  ;; window navigation
  ;; TODO: C-j and C-k don't work in org mode
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

  (define-key evil-motion-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-motion-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-motion-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-motion-state-map (kbd "C-l") 'evil-window-right)

  (define-key global-map (kbd "C-h") #'evil-window-left)
  (define-key global-map (kbd "C-j") #'evil-window-down)
  (define-key global-map (kbd "C-k") #'evil-window-up)
  (define-key global-map (kbd "C-l") #'evil-window-right)

  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state) ;; use C-g to escape to normal mode
  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;; use single esc to quit prompts
(keymap-global-set "<escape>" 'keyboard-escape-quit)
;; remap Meta-X
(keymap-global-set "C-x C-m" 'execute-extended-command)

;; org-mode; based on Prot config
(use-package org
  :ensure nil ;; don't try to install because built-in
  :config
  (setq org-M-RET-may-split-line '((default . nil))) ;; Meta-ret only creates a new item
  (setq org-insert-heading-respect-content t) ;; don't send heading content to the new heading
  (setq org-log-done 'time) ;; log done time
  (setq org-log-into-drawer t) ;; log the state changes inside of LOGBOOK section instead of polluting content
  (setq org-directory "~/Documents/org/")
  (setq org-agenda-files (list org-directory))
  (setq org-return-follows-link t) ;; don't think this works

  (add-hook 'org-mode-hook 'org-bullets-mode) ;; pretty bullets
  (add-hook 'org-mode-hook 'org-autolist-mode) ;; continue lists
  (add-hook 'org-mode-hook 'smartparens-mode) ;; smart parens
  (add-hook 'org-mode-hook 'org-appear-mode) ;; visibility of hidden elements under cursor
  (add-hook 'org-mode-hook 'org-indent-mode) ;; virtual/soft indent
  (add-hook 'org-mode-hook 'visual-line-mode)) ;; smart soft wrapping
;; make these org-related keybinds globally available
(keymap-global-set "C-c l" #'org-store-link)
(keymap-global-set "C-c a" #'org-agenda)
(keymap-global-set "C-c c" #'org-capture)
(keymap-global-set "C-c g d" #'org-open-at-point)
;; hard indentation
;; (setq org-adapt-indentation t
      ;; org-hide-leading-starts t
      ;; org-odd-levels-only t)

(use-package org-appear
  :ensure t
  :after org
  :init
  (setq org-hide-emphasis-markers t)
  (setq org-appear-autolinks t))

;; nicer looking bullets
(use-package org-bullets
  :ensure t
  :after org)

;; automatically continue lists and checkboxes on <ret>
;; no current support for evil o/O motions
(use-package org-autolist
  :ensure t
  :after org)

;; smart parens
;; TODO: figure out proper config
(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config))

(use-package org-roam
  :ensure t
  :after org
  :config
  (setq org-roam-directory "~/Documents/org/roam") ;; must ensure this dir exists
  ;; allow completions (CAP) even outside of brackets
  (setq org-roam-completion-everywhere t)
  ;; add column for some tags in node search menu, etc.
  (setq org-roam-node-display-template
    (concat "${title:*} "
      (propertize "${tags:10}" 'face 'org-tag)))
  ;; TODO: this doesn't seem to have effect, maybe not avail in v2?
  ;; (setq org-roam-auto-replace-fuzzy-links nil)
  (org-roam-db-autosync-mode))
;; global keymaps for common functions
(keymap-global-set "C-c n l" 'org-roam-buffer-toggle)
(keymap-global-set "C-c n f" 'org-roam-node-find)
(keymap-global-set "C-c n i" 'org-roam-node-insert)

;; vertico: completion in minibuffer
;; works nicely with org-roam-node-insert
(use-package vertico
  :ensure t
  :custom
  (vertico-resize nil) ;; don't grow/shrink minibuffer
  (vertico-cycle t) ;; enable cycling for next/prev
  :init
  (vertico-mode))

;; marginalia: rich annotations in the minibuffer
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))
;; icons with marginalia
(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))
;; icons in dired
(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)
;; corfu for in-buffer completion
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t) ;; auto-completion
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  ;; (corfu-quit-no-match 'separator) ;; quit completion eagerly
  ;; (corfu-quit-at-boundary t)
  (corfu-preview-current nil) ;; disable current candidate preview, likely not needed if not preselecting
  (corfu-preselect 'prompt) ;; no preselect
  :init
  (setq completion-styles '(flex basic))
  (global-corfu-mode))
;; from corfu page
(use-package emacs
  :ensure nil
  :custom
  ;; emacs 30+: disable ispell completion func
  (text-mode-ispell-word-completion nil))
;; TODO: is this working?
;; fuzzy matching with corfu integration
;; (use-package fussy
;;   :ensure t
;;   :config
;;   (advice-add 'corfu--capf-wrapper :before 'fussy-wipe-cache)
;;   (add-hook 'corfu-mode-hook
;;           (lambda ()
;;             (setq-local fussy-max-candidate-limit 5000
;;                         fussy-default-regex-fn 'fussy-pattern-first-letter
;;                         fussy-prefer-prefix nil)))
;;   (fussy-setup))

;; NOTE: this might be slow with autocomplete; consider basic completion style:
;; https://github.com/minad/corfu?tab=readme-ov-file#auto-completion
;; orderless completion style (out-of-order pattern matching)
;; (use-package orderless
;;   :ensure t
;;   :custom
;;   ;; Configure a custom style dispatcher (see the Consult wiki)
;;   ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
;;   ;; (orderless-component-separator #'orderless-escapable-split-on-space)
;;   (completion-styles '(orderless basic))
;;   (completion-category-defaults nil)
;;   (completion-category-overrides '((file (styles partial-completion)))))

;; TODO: need some keybind?
;; additional Capf backends and `completion-in-region` commands
;; supplies `cape-file` and `cape-dabbrev`
(use-package cape
  :ensure t
  :init
  ;; order matters; first func that returns result wins
  (add-hook 'completion-at-point-functions #'cape-dabbrev) ;; words from current buffer
  (add-hook 'completion-at-point-functions #'cape-file)) ;; file names
