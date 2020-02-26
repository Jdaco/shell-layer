(defun protect-eshell-prompt ()
  "Protect Eshell's prompt like Comint's prompts.

E.g. `evil-change-whole-line' won't wipe the prompt. This
is achieved by adding the relevant text properties."
  (let ((inhibit-field-text-motion t))
    (add-text-properties
     (point-at-bol)
     (point)
     '(rear-nonsticky t
                      inhibit-line-move-field-capture t
                      field output
                      read-only t
                      front-sticky (field inhibit-line-move-field-capture)))))

(defun toggle-shell-auto-completion-based-on-path ()
  "Deactivates automatic completion on remote paths.
Retrieving completions for Eshell blocks Emacs. Over remote
connections the delay is often annoying, so it's better to let
the user activate the completion manually."
  (if (file-remote-p default-directory)
      (setq-local company-idle-delay nil)
    (setq-local company-idle-delay auto-completion-idle-delay)))

(defmacro make-shell-pop-command (func &optional shell)
  "Create a function to open a shell via the function FUNC.
SHELL is the SHELL function to use (i.e. when FUNC represents a terminal)."
  (let* ((name (symbol-name func)))
    `(defun ,(intern (concat "shell-pop-" name)) (index)
       ,(format (concat "Toggle a popup window with `%S'.\n"
                        "Multiple shells can be opened with a numerical prefix "
                        "argument. Using the universal prefix argument will "
                        "open the shell in the current buffer instead of a "
                        "popup buffer.") func)
       (interactive "P")
       (require 'shell-pop)
       (if (equal '(4) index)
           ;; no popup
           (,func ,shell)
         (shell-pop--set-shell-type
          'shell-pop-shell-type
          (backquote (,name
                      ,(concat "*" name "*")
                      (lambda nil (,func ,shell)))))
         (shell-pop index)))))

(defun default-pop-shell ()
  "Open the default shell in a popup."
  (interactive)
  (call-interactively (intern (format "shell-pop-%S" shell-default-shell))))

(defun projectile-shell-pop ()
  "Open a term buffer at projectile project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (call-interactively 'default-pop-shell)))

(defun disable-hl-line-mode ()
  "Locally disable global-hl-line-mode"
  (interactive)
  (setq-local global-hl-line-mode nil))
