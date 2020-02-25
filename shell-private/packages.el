(defconst shell-private-packages
  '(company
    (eshell :location built-in)
    (comint :location built-in)))

(defun shell-private/init-comint ()
  (setq comint-prompt-read-only t)
  (add-hook 'comint-mode-hook 'spacemacs/disable-hl-line-mode))

(defun shell-private/init-eshell ()
  (use-package eshell
    :defer t
    :init
    (progn
      (when shell-protect-eshell-prompt
        (add-hook 'eshell-after-prompt-hook 'protect-eshell-prompt)))
    :config
    (progn
      (defalias 'eshell/e 'find-file-other-window)

      (setenv "PAGER" "cat")

      ;; Visual commands
      (require 'em-term)
      (mapc (lambda (x) (add-to-list 'eshell-visual-commands x))
            '("el" "elinks" "htop" "less" "ssh" "tmux" "top")))))

(defun shell-private/pre-init-company ()
  (spacemacs|use-package-add-hook eshell
    :post-init
    (progn
      (spacemacs|add-company-backends :backends company-capf :modes eshell-mode)
      (add-hook 'eshell-directory-change-hook
                'toggle-shell-auto-completion-based-on-path))))
