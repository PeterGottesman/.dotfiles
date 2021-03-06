;;; -*- Mode: Emacs-Lisp -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(package-initialize)
(require 'package)
(require 'use-package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(when (not package-archive-contents)
  (package-refresh-contents))

(setq-default c-default-style "linux"
              c-basic-offset 4
              tab-width 4)
(c-set-offset 'case-label '+)

;; turn all tabs into spaces
;; use this or maybe smarttabs at some point
(setq-default indent-tabs-mode nil)

(setq ess-fancy-comments nil
      backup-directory-copying t
      backup-directory-alist '(("." . "~/.emacs.d/backups"))
      auto-save-file-name-transforms `((".*" ,"~/.emacs.d/backups/\\1" t))
      delete-old-versions t
      kept-new-versions 3
      kept-old-versions 2
      version-control t
      use-package-always-ensure t)

(use-package pdf-tools
  :init (pdf-tools-install))

(use-package magit
  :commands (magit-status magit-blame magit-checkout)
  :bind ("<f1>" . magit-status))

(use-package hl-todo)

(define-globalized-minor-mode my-hl-todo-mode-global hl-todo-mode
  (lambda () (hl-todo-mode t)))

(use-package rjsx-mode
  :config (setq js-indent-level 2)
	   (add-to-list 'auto-mode-alist
			'(".*\\.js\\'" . rjsx-mode)))

(use-package multi-term
  :bind ("<f12>" . 'multi-term-dedicated-toggle)
  :config (setq multi-term-program "/bin/zsh"
		multi-term-dedicated-close-back-to-open-buffer-p t))

(use-package tex-site
  :ensure auctex
  :hook (latex-mode . reftex-mode)
  :config (setq-default TeX-engine 'xetex))
  ;; :config (add-to-list 'TeX-command-list
  ;;    		       '("XeLaTeX" "xelatex -interaction=nonstopmode %s"
  ;; 			 TeX-run-command t t :help "Run xelatex"))

(use-package lsp-mode
  :defer t
  :hook ((vhdl-mode c-mode c++-mode latex-mode) . lsp)
  :commands (lsp lsp-deferred)
  :config
  (use-package ccls)
  (setq lsp-prefer-flymake nil)

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "digestif")
                    :major-modes '(latex-mode plain-tex-mode)
                    :server-id 'digestif))
  (add-to-list 'lsp-language-id-configuration '(latex-mode . "latex"))
  (add-to-list 'lsp-language-id-configuration '(cuda-mode . "cuda"))

  ;; built in lsp vhdl client did not work, just make my own
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("ghdl-ls"))
                    :major-modes '(vhdl-mode)
                    :priority -1
                    :server-id 'lsp-vhdl-mode))
  )

(use-package lsp-ui
  :bind (("M-." . lsp-ui-peek-find-definitions)
	 ("M-\/". lsp-ui-peek-find-references)))

(use-package company
  :bind ("C-\\" . company-complete)
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-c-headers)
  (use-package company-statistics
    :init (add-hook 'after-init-hook 'company-statistics-mode))
  (use-package company-lsp)
  (setq company-c-headers-path-user'("./inc" "." "../inc")
	company-show-numbers t
	company-backends '((company-yasnippet company-lsp company-c-headers))))

(use-package flycheck)
(use-package treemacs)
(use-package projectile)

(use-package yasnippet
  :init (yas-global-mode 1)
  )

;; I used this at Cisco, maybe configure it here if lsp tag navigation
;; doesn't work out
;; (use-package counsel-gtags)

;; (use-package ggtags
;;   :bind (("M-n" . ggtags-find-tag-dwim)
;; 	 ("M-." . ggtags-find-definition)
;; 	 ("M-\/". ggtags-find-reference))
;;   :init (add-hook 'c-mode-common-hook
;; 		  (lambda ()
;; 		    (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;; 		      (ggtags-mode 1))))
;;   (global-set-key (kbd "M-,") 'xref-pop-marker-stack)) ; For Emacs <25

  
(use-package ace-window
  :config (setq aw-scope 'frame)
  :bind ("C-x o" . ace-window)
  )

(use-package origami
  :bind (("C-c k" . origami-toggle-node)
	 ("C-c C-k" . origami-toggle-all-nodes))
  :init (global-origami-mode)
  )

;; Python
(use-package pyvenv)
(use-package elpy
  :bind (("C-c i" . elpy-shell-switch-to-shell))
  :init (elpy-enable)
  :config (setq python-shell-interpreter "jupyter"
	       python-shell-interpreter-args "console --simple-prompt"
	       python-shell-prompt-detect-failure-warning nil)
	 (add-to-list 'python-shell-completion-native-disabled-interpreters
		      "jupyter")
	 )


;; Extends tcl-mode to include xdc keywords
(use-package vivado-mode
  :load-path "lisp/"
  :config (add-to-list 'auto-mode-alist '("\\.xdc\\'" . vivado-mode)
  (add-hook 'vivado-mode-hook '(lambda () (font-lock-mode 1))))
  )

(use-package flex
  :load-path "lisp/"
  )

(use-package compilation
  :load-path "lisp/"
  :bind (("C-c C-c" . my-compile-recompile))
  )

(use-package copy-paste
  :load-path "lisp/"
  :bind (("C-c y" . system-clipboard-mode))
  )

(use-package linum-off
  :load-path "lisp/"
  )

(use-package markdown-mode)
(use-package paganini-theme)

;; learn to use these
(use-package ivy
  :init(ivy-mode)
  )

(use-package avy)

(use-package org
  :config (setq org-list-allow-alphabetical t
		org-agenda-files (list "~/documents/todo.org")))

(global-set-key (kbd "<f2>") 'whitespace-mode)
(global-set-key (kbd "S-<f2>") 'whitespace-cleanup)

(delete-selection-mode t)
(global-linum-mode t)
(menu-bar-mode -1)
(my-hl-todo-mode-global t)

;; Set appearance
(load-theme 'wombat t)

(set-face-attribute 'default nil :height 72)
(set-face-attribute 'default nil :family "Roboto Mono")
(set-face-attribute 'ivy-current-match nil :height 100)
(set-face-attribute 'ivy-minibuffer-match-highlight nil :height 100)
(set-face-attribute 'ivy-highlight-face nil :height 100)

;; Turn off file variables
;; ;; See: https://www.emacswiki.org/emacs/FileLocalVariables#toc2
;; (setq enable-local-variables nil
;;       enable-local-eval nil)

(add-hook 'go-mode-hook
	  (lambda ()
	    (set (make-local-variable 'company-backends) '(company-go))
	    (company-mode)
	    (setq tab-width 4)))

(setq tramp-shell-prompt-pattern "^[^$>\n]*[#$%>] *\\(\[[0-9;]*[a-zA-Z] *\\)*")
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(put 'downcase-region 'disabled nil)

;;;; CSE 443 Alpha language ;;;;

(setq alpha-compiler "/home/peter/programming/UB/443/cse443--team-1-the-favorite-team/pr03/compiler")

(define-derived-mode alpha-mode fundamental-mode "α-mode"
  "A major mode for editing Sample files."
  (flycheck-mode)
  )

 ;;;###autoload
(add-to-list 'auto-mode-alist '("\\.alpha\\'" . alpha-mode))

(flycheck-define-checker alpha-pr03
  "Flycheck checker for alpha"
  :command
  ("/home/peter/programming/UB/443/cse443--team-1-the-favorite-team/pr03/compiler" source)
  :error-patterns
  ((error line-start "LINE " line ":" column " **ERROR: " (message) line-end))
  :modes alpha-mode
  )

(add-to-list 'flycheck-checkers 'alpha-pr03)
(put 'upcase-region 'disabled nil)
