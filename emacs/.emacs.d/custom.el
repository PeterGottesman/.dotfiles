(provide 'custom)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(company-backends (quote ((company-clang company-c-headers))))
 '(company-c-headers-path-user
   (quote
    ("./Inc" "." "/usr/include/glib-2.0" "/usr/lib64/glib-2.0/include")))
 '(company-clang-arguments
   (quote
    ("-I./inc" "-I../inc" "-I/usr/include/glib-2.0" "-I/usr/lib64/glib-2.0/include")))
 '(company-show-numbers t)
 '(company-statistics-mode t)
 '(company-transformers (quote (company-sort-by-statistics)))
 '(custom-safe-themes
   (quote
    ("1e67765ecb4e53df20a96fb708a8601f6d7c8f02edb09d16c838e465ebe7f51b" default)))
 '(global-company-mode t)
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (elpy pdf-tools gh-md markdown-mode company-go go-mode origami company-statistics company-irony company-quickhelp company-c-headers use-package multi-term paganini-theme hl-todo magit package-build)))
 '(safe-local-variable-values
   (quote
    ((company-clang-arguments "-I/usr/include" "-I/home/peter/programming/LoR/Inc")
     (company-clang-arguments "-I/usr/include" "-I/home/peter/programming/ECS/Inc")
     (company-clang-arguments "-I/usr/include" "-I/home/peter/programming/visualizer/Inc")
     (company-clang-arguments "-I/usr/include" "-I../Inc" "-I../inc")
     (company-clang-arguments "-I/usr/include" "-I../Inc" "-I../Drivers/STM32F4xx_HAL_Driver/Inc" "-I../Drivers/CMSIS/Include" "-I../Drivers/CMSIS/Device/ST/STM32F4xx/Include" "-DUSE_HAL_DRIVER" "-DSTM32F410Rx")))))
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
