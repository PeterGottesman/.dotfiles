;; My copy/paste functions

(setq x-select-enable-clipboard nil)

(define-minor-mode system-clipboard-mode
  "Use the system clipboard"
  :lighter " sysclip"
  (if system-clipboard-mode
      (setq x-select-enable-clipboard t)
    (setq x-select-enable-clipboard nil)))
