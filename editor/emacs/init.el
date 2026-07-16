;;; init.el --- Minimal GNU Emacs configuration -*- lexical-binding: t; -*-

;; ---------------------------------------------------------------------------
;; Basic UI
;; ---------------------------------------------------------------------------

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq initial-scratch-message nil)

(setq ring-bell-function 'ignore)

(column-number-mode)
(line-number-mode)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda ()
                   (display-line-numbers-mode 0))))

(setq use-short-answers t)

(global-hl-line-mode 1)

(setq scroll-conservatively 101)

(setq make-backup-files nil)

(setq auto-save-default nil)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(global-auto-revert-mode 1)

(show-paren-mode 1)

;; ---------------------------------------------------------------------------
;; Editing
;; ---------------------------------------------------------------------------

(delete-selection-mode 1)

(save-place-mode 1)

(savehist-mode 1)

(recentf-mode 1)

;; ---------------------------------------------------------------------------
;; Completion
;; ---------------------------------------------------------------------------

(fido-vertical-mode 1)

;; ---------------------------------------------------------------------------
;; Programming
;; ---------------------------------------------------------------------------

(setq-default fill-column 80)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(add-hook 'prog-mode-hook #'electric-pair-mode)

;; ---------------------------------------------------------------------------
;; Guile / Scheme
;; ---------------------------------------------------------------------------

(add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))

;; Tell Emacs where Guix-installed Elisp packages live.
;; EMACSLOADPATH is set by Guix automatically, but this makes it explicit
;; and ensures packages in the home profile are found at startup.
(let ((guix-profile (expand-file-name "~/.guix-home/profile")))
  (when (file-directory-p guix-profile)
    (let ((site-lisp (expand-file-name "share/emacs/site-lisp" guix-profile)))
      (when (file-directory-p site-lisp)
        (add-to-list 'load-path site-lisp)))))

;; ---------------------------------------------------------------------------
;; Geiser (interactive Guile/Scheme REPL)
;; ---------------------------------------------------------------------------

(with-eval-after-load 'geiser-guile
  ;; Point Geiser at the Guix system Guile so it picks up all Guix modules.
  ;; Adjust the path if `guix repl` lives elsewhere on your system.
  (setq geiser-guile-binary "guile"))

;; Associate Guix config files with scheme-mode + Geiser.
(with-eval-after-load 'geiser
  ;; Automatically use Guile for .scm files (not Chicken, Racket, etc.).
  (setq geiser-default-implementation 'guile)
  ;; Load path entries so Geiser's REPL can find Guix modules directly.
  ;; Add your channel source tree here if you want M-. to jump into it.
  (setq geiser-guile-load-path
        (list (expand-file-name "~/Projects/guix-channel"))))

;; ---------------------------------------------------------------------------
;; Emacs-Guix
;; ---------------------------------------------------------------------------

;; emacs-guix is installed via the home profile; require it after load-path
;; is set up above. The `t' at the end makes the require non-fatal in case
;; the package isn't present in a given session.
(with-eval-after-load 'scheme
  (require 'guix-devel nil t))

;; Enable Guix development helpers in scheme-mode buffers (syntax
;; highlighting for build phases, prettified store paths, etc.).
(with-eval-after-load 'guix-devel
  (add-hook 'scheme-mode-hook #'guix-devel-mode))

;; ---------------------------------------------------------------------------
;; Ielm / scratch defaults
;; ---------------------------------------------------------------------------

;; Make *scratch* use scheme-mode so you have a Lisp scratch buffer
;; that works with Geiser. Remove this if you prefer elisp there.
(setq initial-major-mode 'scheme-mode)
