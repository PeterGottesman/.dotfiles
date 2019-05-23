(provide 'compilation)

(defun my-compile-recompile ()
  (interactive)
  (save-window-excursion
    (recompile)))
