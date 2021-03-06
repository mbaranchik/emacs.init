;;; -*- lexical-binding: t -*-

;;(load "/usr/local/Cellar/clang-format/2018-01-11/share/clang/clang-format.el")

;;(straight-use-package `(clang-format-on-save
;;  :local-repo ,(concat user-emacs-directory "lisp")))

(use-package clang-format+)

(if use-flycheck
  (use-package flycheck
    :demand
    :hook (prog-mode . flycheck-mode)))

(if use-flymake
  (use-package flymake
    :demand
    :hook (prog-mode . flymake-mode)))

;; Enable LSP
(when use-lsp
  (use-package lsp-mode
    :commands lsp
    :hook
    ((c-mode c++-mode python-mode sh-mode) . (lambda () (hack-local-variables) (lsp) (which-function-mode)))
    (lsp-mode . lsp-enable-which-key-integration)
    :config
    (setq lsp-headerline-breadcrumb-segments '(symbols))
    (set-config-var 'lsp-headerline-breadcrumb-enable nil "EMACS_LSP_BREADCRUMB")
    (setq lsp-enable-semantic-tokens nil)
    (setq lsp-enable-file-watchers nil)
    (push "[/\\\\]\\.cquery_cached_index\\'" lsp-file-watch-ignored-directories)
    (push "[/\\\\][^/\\\\]*\\.\\(so\\|d\\|o\\)$" lsp-file-watch-ignored-files)
    (when (equal my-lsp-c++-backend "cquery")
      (use-package cquery))
    (when (equal my-lsp-c++-backend "ccls")
      (use-package ccls))
    ;; TODO: pyright hangs
    ;;(use-package lsp-pyright)
    ;;(setq lsp-disabled-clients '(pyls))
    ;;(setq lsp-pyright-log-level "trace")
    ;;(setq lsp-pyright-diagnostic-mode "workspace")
    ;;(setq lsp-pyright-python-executable-cmd "/usr/local/bin/python3.9")
    (when use-ivy
      (use-package lsp-ivy))
    (when use-helm
      (use-package helm-lsp))
    )
  )

(when use-eglot
  ;;(use-package project
  ;;  :straight (:type built-in)
  ;;  )
  (use-package markdown-mode)
  (unless (fboundp 'project-root)
    (defun project-root (project)
      (car (project-roots project)))
    )
  (use-package eglot
;;    :straight (eglot
;;               :type git
;;               :flavor melpa
;;               :host github
;;               :repo "joaotavora/eglot")
    :commands eglot-ensure
    :hook
    ((c-mode c++-mode python-mode sh-mode) . (lambda () (hack-local-variables) (eglot-ensure) (which-function-mode)))
    :config
    (when (equal my-lsp-c++-backend "cquery")
      (use-package cquery))
    (when (equal my-lsp-c++-backend "ccls")
      (use-package ccls))
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;

