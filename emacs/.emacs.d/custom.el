(provide 'custom)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(aw-scope 'frame)
 '(company-backends '((company-clang company-c-headers)))
 '(company-c-headers-path-user
   '("./Inc" "." "/usr/include/glib-2.0" "/usr/lib64/glib-2.0/include"))
 '(company-clang-arguments
   '("-I./inc" "-I../inc" "-I/usr/include/glib-2.0" "-I/usr/lib64/glib-2.0/include"))
 '(company-show-numbers t)
 '(company-statistics-mode t)
 '(company-transformers '(company-sort-by-statistics))
 '(custom-safe-themes
   '("1e67765ecb4e53df20a96fb708a8601f6d7c8f02edb09d16c838e465ebe7f51b" default))
 '(global-company-mode t)
 '(linum-disabled-modes-list
   '(eshell-mode wl-summary-mode compilation-mode org-mode text-mode dired-mode doc-view-mode image-mode pdf-view-mode))
 '(package-selected-packages
   '(lua-mode org-ref annotate julia-mode rmsbolt disaster company-lsp company yasnippet helm-projectile helm evil-leader evil edbi edbi-database-url edbi-django edbi-sqlite emacsql emacsql-sqlite3 rjsx-mode tuareg bison-mode tex-site acutex auctex cuda-mode switch-window ivy-explorer counsel swiper ccls projectile lsp-treemacs flycheck lsp-ui lsp-mode yaml-mode counsel-gtags glsl-mode elpy pdf-tools gh-md markdown-mode company-go go-mode origami company-statistics company-quickhelp company-c-headers use-package multi-term paganini-theme hl-todo magit package-build))
 '(safe-local-variable-values
   '((indent-tabs-mode nil)
	 (tab-width 2)
	 (c-basic-offset 2)
	 (company-clang-arguments "-I/usr/include" "-I../Inc" "-I../inc")
	 (company-clang-arguments "-I/usr/include" "-I../Inc" "-I../Drivers/STM32F4xx_HAL_Driver/Inc" "-I../Drivers/CMSIS/Include" "-I../Drivers/CMSIS/Device/ST/STM32F4xx/Include" "-DUSE_HAL_DRIVER" "-DSTM32F410Rx"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-added ((((type tty)) (:foreground "green"))))
 '(magit-diff-added-highlight ((((type tty)) (:foreground "LimeGreen"))))
 '(magit-diff-context-highlight ((((type tty)) (:foreground "default"))))
 '(magit-diff-file-heading ((((type tty)) nil)))
 '(magit-diff-removed ((((type tty)) (:foreground "red"))))
 '(magit-diff-removed-highlight ((((type tty)) (:foreground "IndianRed"))))
 '(magit-section-highlight ((((type tty)) nil))))
