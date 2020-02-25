(defconst shell-private-packages
  '(company
    projectile
    shell-pop
    eshell-prompt-extras
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

(defun shell-private/post-init-projectile ()
  (spacemacs/set-leader-keys
    "p'" 'spacemacs/projectile-shell-pop
    "p$t" 'projectile-multi-term-in-root)
  (spacemacs/declare-prefix "p$" "projects/shell"))

(defun shell-private/init-shell-pop ()
  (use-package shell-pop
    :defer t
    :init
    (progn
      (make-shell-pop-command eshell)
      (make-shell-pop-command ansi-term shell-pop-term-shell)

      (spacemacs/set-leader-keys
        "'"   'spacemacs/default-pop-shell
        "ase" 'spacemacs/shell-pop-eshell
        "ast" 'spacemacs/shell-pop-ansi-term)
      (spacemacs/declare-prefix "'" "open shell")
      (spacemacs/declare-prefix "as" "shells"))))

(defun shell-private/init-eshell-prompt-extras ()
  (use-package eshell-prompt-extras
    :commands epe-theme-lambda
    :init
    (setq eshell-highlight-prompt nil
          eshell-prompt-function 'epe-theme-lambda)))
