(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
    (load custom-file))

(require 'package)
(add-to-list 'package-archives
    '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 27)
    (package-initialize))

(unless (package-installed-p 'use-package)
    (package-install 'use-package))

(use-package exec-path-from-shell
    :ensure t
    :init (exec-path-from-shell-initialize)
)

(use-package neotree
    :ensure t
    :config
    (neotree-toggle)
    (neotree-dir "~/Projects")
    (switch-to-buffer-other-window "*scratch*")
    (global-set-key [f8] 'neotree-toggle)
)

(use-package lsp-mode
    :ensure t
    :commands lsp
)

(use-package lsp-ui
    :ensure t
    :commands lsp-ui-mode
)

(use-package go-mode
    :ensure t
    :hook
    (go-mode . lsp-deferred)
)

(use-package eglot
    :ensure t
    :hook (go-mode . eglot-ensure)
)

(use-package flycheck-golangci-lint
    :ensure t
    :hook (go-mode . flycheck-golangci-lint-setup)
)

(use-package dumb-jump
    :ensure t
    :hook (go-mode xref-backend-functions dumb-jump-xref-activate)
)

(use-package godoctor
    :ensure t
)

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(global-display-line-numbers-mode t)

(defun tabs-to-spaces()
    (setq tab-width 4)
    (setq indent-tabs-mode nil)
)
(add-hook 'go-mode-hook 'tabs-to-spaces)

;; keep backup files outside of the project
(let ((backup-dir (concat user-emacs-directory "backup")))
    (when (not (file-exists-p backup-dir))
        (make-directory backup-dir t))
    (setq backup-directory-alist `(("." . ,backup-dir))
        backup-by-copying t
        delete-old-versions t
        version-control t
        kept-new-versions 5
        kept-old-versions 2))
