;;; -*- Mode: Emacs-Lisp -*-

;; Prevent TLS version issues (I think...)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Include /usr/local/bin in path
;; Need for OSX
(add-to-list 'exec-path "/usr/local/bin")
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))

(package-initialize)
(require 'package)
(add-to-list 'package-archives
			 '("melpa" . "http://melpa.org/packages/") t)

(when (not package-archive-contents)
  (package-refresh-contents))

;; C indentation
(setq-default c-default-style "linux"
              c-basic-offset 4
              tab-width 4)

;; Set case indentation eq. to c-basic-offset
(c-set-offset 'case-label '+)

;; Backup settings
(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms `((".*" ,"~/.emacs.d/backups/\\1" t))
      delete-old-versions t
      kept-new-versions 3
      kept-old-versions 2
      version-control t)

;; Line numbers
(global-linum-mode t)

;; Gui bad
(if (display-graphic-p)
	(progn (menu-bar-mode -1)
		   (tool-bar-mode -1)
		   (scroll-bar-mode -1)
		   (setq inhibit-startup-message t)
		   (setq inhibit-splash-screen t)))

;; Theming
(load-theme 'wombat)

;; Put customize outputs in a separate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Set up use-package
(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Use evil mode globally
(use-package evil
  :config (evil-mode 1)
  ;; Default to emacs mode in dired mode
  (add-to-list 'evil-emacs-state-modes 'dired-mode))

;; Set evil-leader key mappings
(use-package evil-leader
  :config
  ;; Globally use evil leader
  (global-evil-leader-mode)

  ;; Use C-g to exit to normal mode. If the default is used
  ;; (ESC/Meta), emacs waits for whatever key might come after ESC
  ;; (meta) for a second, which causes either a slow down, or a lot of
  ;; mistakes
  ;; Adapted from https://www.emacswiki.org/emacs/Evil#toc16
  (define-key evil-visual-state-map [remap keyboard-quit] 'evil-change-to-previous-state)
  (define-key evil-insert-state-map [remap keyboard-quit] 'evil-normal-state)
  (define-key evil-replace-state-map [remap keyboard-quit] 'evil-normal-state)

  ;; Set leader to 'g'
  (evil-leader/set-leader "g")

  ;; Leader keymap
  (evil-leader/set-key

	;; Moving around
	;; files/buffers
	"f" 'helm-find-files
	"b" 'switch-to-buffer
	"kk" 'kill-buffer

	;; Toggle whitespace mode
	"w" 'whitespace-mode

	;; Magit bindings
	"m" nil ;; Unmap g m
	"ms" 'magit-status
	"ml" 'magit-log
	"mc" 'magit-clone
	;; TODO: Stage all changes, show diff, confirm append
	;; If yes, append, if no unstage _newly staged_ changes

	;; Helm bindings
	"x" 'helm-M-x

	;; LSP bindings
	"pd" 'lsp-ui-peek-find-definitions
	"pr" 'lsp-ui-peek-find-references
	))

;; Magit
(use-package magit
  :commands (magit-status magit-blame magit-checkout))

(use-package projectile
  :init (projectile-mode))

;; Helm mode
(use-package helm
  :init (helm-mode)
  (helm-autoresize-mode 1)
  :config
  ;; Set max/min size of helm window (%)
  (setq helm-autoresize-min-height 0
		helm-autoresize-max-height 20))

(use-package helm-projectile
  :requires helm projectile
  :init (helm-projectile-on)
  :config (setq projectile-completion-system 'helm))

;; Highlight todo (in all caps) globally
(use-package hl-todo
  :init (global-hl-todo-mode))

;; pdf-tools
(if (display-graphic-p)
	(use-package pdf-tools
	  :init (pdf-tools-install)))

;; multi-term
;; f12 to open/close, use zsh
(use-package multi-term
  :bind ("<f12>" . 'multi-term-dedicated-toggle)
  :config (setq multi-term-program "/bin/zsh"
		        multi-term-dedicated-close-back-to-open-buffer-p t))

;; Latex Tools
(use-package tex-site
  :ensure auctex
  :hook (latex-mode . reftex-mode)
  ;; Add xelatex to auctex
  :config (eval-after-load "tex"
            '(add-to-list 'TeX-command-list
     		              '("XeLaTeX" "xelatex -interaction=nonstopmode %s"
  			                TeX-run-command t t :help "Run xelatex"))))

;; flycheck setup
(use-package flycheck
  :init (global-flycheck-mode))

;; lsp-mode
(use-package lsp-mode
  :defer t
  :hook ((vhdl-mode c-mode c++-mode latex-mode) . lsp)
  :commands (lsp lsp-deferred)
  :config
  ;; Use ccls for lsp backend
  (use-package ccls)

  ;; Use lsp-ui to find defs/refs
  (use-package lsp-ui
    :bind (("M-." . lsp-ui-peek-find-definitions)
	       ("M-\/". lsp-ui-peek-find-references)))

  ;; Use flycheck as diagnostic
  (setq lsp-diagnostic-package :flycheck
		lsp-enable-snippet t)

  ;; TODO Set up latex lsp client
  ;; (lsp-register-client
  ;;  (make-lsp-client :new-connection (lsp-stdio-connection "digestif")
  ;;                   :major-modes '(latex-mode plain-tex-mode)
  ;;                   :server-id 'digestif))
  ;; (add-to-list 'lsp-language-id-configuration '(latex-mode . "latex"))

  ;; built in lsp ghdl client did not work, just make my own
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("ghdl-ls"))
                    :major-modes '(vhdl-mode)
                    :priority -1
                    :server-id 'lsp-vhdl-mode)))

;; Snippets
;; Stored in ~/.emacs.d/snippets/*-mode/*.yasnippet
(use-package yasnippet
  :init (yas-global-mode 1)
  )

;; Autocompletion
(use-package company
  :bind ("C-\\" . company-complete)
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  
  ;; Allow company to autocomplete header names
  ;; Does lsp-mode provide this functionality?
  (use-package company-c-headers)

  ;; Rank completions based on history
  (use-package company-statistics
    :init (add-hook 'after-init-hook 'company-statistics-mode))

  ;; Use lsp company backend
  (use-package company-lsp)

  ;; Basic config
  (setq company-c-headers-path-user'("./inc" "." "../inc")
	company-show-numbers t
	company-backends '((company-lsp company-c-headers))))
