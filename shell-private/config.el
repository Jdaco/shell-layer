(defvar shell-protect-eshell-prompt t
  "If non-nil then eshell's prompt is protected. This means that
movement to the prompt is inhibited like for `comint-mode'
prompts and the prompt is made read-only")

(defvar shell-default-shell (if (eq window-system 'w32)
                                'eshell
                                'ansi-term)
  "Default shell to use in Spacemacs. Possible values are `eshell', `shell',
`term', `ansi-term' and `multi-term'.")
