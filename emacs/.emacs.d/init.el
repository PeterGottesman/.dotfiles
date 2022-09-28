;;; -*- Mode: Emacs-Lisp -*-

;; Prevent TLS version issues (I think...)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(setenv "GOPATH" (concat (getenv "HOME") "/go"))

(setenv "PATH" (concat (getenv "GOPATH") "/bin:" (getenv "PATH") ":/usr/local/bin"))

(add-to-list 'exec-path (getenv "PATH"))

(package-initialize)
(require 'package)
(add-to-list 'package-archives
			 '("melpa" . "http://melpa.org/packages/") t)

(when (not package-archive-contents)
  (package-refresh-contents))

;; C indentation
(setq-default c-default-style "linux"
              c-basic-offset 4
              tab-width 4
			  indent-tabs-mode nil)

;; Set case indentation eq. to c-basic-offset
(c-set-offset 'case-label '+)

;; Backup settings
(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/backups"))
      ;; auto-save-file-name-transforms '((".*" ,"~/.emacs.d/backups/\\1" t))
      delete-old-versions t
      kept-new-versions 3
      kept-old-versions 2
      version-control t)

;; Line numbers
(global-linum-mode t)

;; Disable menu/toolbar/scroll bar
(progn (menu-bar-mode -1)
	   (tool-bar-mode -1)
	   (scroll-bar-mode -1)
	   (setq inhibit-startup-message t)
	   (setq inhibit-splash-screen t))

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
  (add-to-list 'evil-emacs-state-modes 'dired-mode)

  ;; undo-tree no longer required in evil mode, add it manually
  (use-package undo-tree
	:config (global-undo-tree-mode t))
  (evil-set-undo-system 'undo-tree))

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

  (defun my/smerge-first-conflict ()
    (interactive)
    (goto-char (point-min))
    (smerge-start-session))

  (defun my/smerge-next-conflict-in-proj ()
    (interactive)
    (ignore-errors
      (smerge-next)

      (recenter)
      )
    (unless (looking-at smerge-begin-re)
      (if (buffer-modified-p)
          (progn
            (message "Done with buffer!")
            (goto-char (point-max)))

        (let* ((files
                (seq-intersection (magit-unmerged-files) (magit-unstaged-files)))
               (first-file
                (concat (magit-toplevel) (car files))))
          (if first-file
              (progn
                (magit-diff-visit-worktree-file first-file)
                (my/smerge-first-conflict))
          (message "Nothing left to merge!"))))))

  (defun my/magit-smerge-first ()
    (call-interactively 'magit-diff-visit-file-other-window)
    (my/magit-smerge-first))

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

    "mf" 'my/smerge-first-conflict
    "mn" 'my/smerge-next-conflict-in-proj
    "mp" 'smerge-prev
    "mm" 'smerge-keep-mine
    "mo" 'smerge-keep-other
    "ma" 'smerge-keep-all
    "mr" 'smerge-refine

	;; Helm bindings
	"x" 'helm-M-x

	;; LSP bindings
	"pd" 'lsp-ui-peek-find-definitions
	"pr" 'lsp-ui-peek-find-references

	;; describe bindings
	"hk" 'describe-key
	"hv" 'describe-variable
	"hf" 'describe-function
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
  :hook ((python-mode vhdl-mode c-mode c++-mode latex-mode go-mode) . lsp)
  :commands (lsp lsp-deferred)
  :config
  ;; Use ccls for lsp backend
  (use-package ccls
    :custom (ccls-initialization-options (list :index (list :threads 4)))
    )

  ;; Use Jedi for python lsp backend. Use this instead of
  ;; python-language-server because the latter currently is slow and
  ;; hangs when a cancellation is sent
  (use-package lsp-jedi
	:config
	(with-eval-after-load "lsp-mode"
	  (add-to-list 'lsp-disabled-clients 'pyls))
	)

  ;; Use lsp-ui to find defs/refs
  (use-package lsp-ui
    :bind (("M-." . lsp-ui-peek-find-definitions)
	       ("M-\/". lsp-ui-peek-find-references)))

  ;; Use flycheck as diagnostic
  (setq lsp-diagnostics-provider :flycheck
		lsp-enable-snippet t
		lsp-enable-on-type-formatting nil
		lsp-enable-indentation nil
		lsp-lens-enable nil)

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
                    :server-id 'lsp-vhdl-mode))
  )

(use-package conda
  :config
  (conda-env-autoactivate-mode t)
  (setq conda-env-home-directory (expand-file-name "~/mambaforge"))
  :custom (conda-anaconda-home (expand-file-name "~/mambaforge"))
  )

;; rmsbolt, like godbolt
(use-package rmsbolt)

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

  ;; Basic config
  (setq company-c-headers-path-user'("./inc" "." "../inc")
	company-show-numbers t))

;; Org-mode
(use-package org
  :init  (setq initial-buffer-choice (lambda ()
									   (org-agenda nil "n")
									   (delete-other-windows)
									   (get-buffer "*Org Agenda*")))
  :config (setq org-agenda-files '("~/agenda.org"))

  (use-package org-roam
	:config
	(setq org-roam-directory "~/work/notes"
		  org-roam-dailies-directory "dailies/"
				org-roam-db-autosync-mode t)

	;; TODO This is commented because I want to wait to see how my
	;; roam workflow looks like for projects. There is no need to be
	;; opening every org-roam note every time I start emacs, so this
	;; should not be resurrected as-is.

	;; (setq org-agenda-files (append org-agenda-files (org-roam-list-files)))

	(setq org-roam-dailies-capture-templates
		  '(("d" "default" entry
			 "* %?"
			 :target (file+head "%<%Y-%m-%d>.org"
								"#+title: %<%Y-%m-%d>\n"))))

	(defun org-roam-insert-immediate (arg &rest args)
	  (interactive "P")
	  (let ((args (cons arg args))
			(org-roam-capture-templates (list (append (car org-roam-capture-templates)
													  '(:immediate-finish t)))))
		(apply #'org-roam-node-insert args)))

	;; prepends a space before link, for use in evil mode
	(defun org-roam-insert-immediate-evil (arg &rest args)
	  (interactive "P")
	  (evil-append 1)
	  (apply #'org-roam-insert-immediate (cons arg args))
	  (evil-normal-state))

	(evil-leader/set-key
	  "rf" 'org-roam-node-find

	  ;; TODO: Replace org-roam-node-insert with a wrapper that
	  ;; doesn't switch to the new node. See System Crafter's "5 org
	  ;; roam hacks..." video. Also, insert a space before the
	  ;; inserted link.
	  "rl" 'org-roam-insert-immediate-evil
	  "rn" 'org-roam-capture
	  "rd" 'org-roam-dailies-capture-today
	  "rg" 'org-roam-graph
	  )
	)
)

(use-package cuda-mode)

;; Open org-agenda as starting screen
;; (org-agenda nil "n")
;; (setq initial-buffer-choice 'org-agenda-list)
;; (setq initial-buffer-choice (lambda ()
;; 							  (if (and (boundp 'server-process)
;; 									   (server-running-p))
;; 								  ((lambda ()
;; 									(org-agenda nil "n")
;; 									(delete-other-windows)
;; 									(get-buffer "*Org Agenda*")))
;; 									(get-buffer "*scratch*"))))

;; Font settings
(set-face-attribute 'default t
					:height 100
					:family "roboto mono")

(use-package google-c-style
  :load-path "lisp/"
  :commands (google-set-c-style google-c-style)
  :hook (c-mode-common . google-set-c-style)
  )

(provide 'init.el)
;;; init.el ends here
