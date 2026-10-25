{ pkgs, lib, config, ... }:
{
  options = {
    my-emacs.enable = lib.mkEnableOption "Enable emacs config";
  };

  config = lib.mkIf config.my-emacs.enable {
    programs.emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [
        doom-themes doom-modeline
        orderless corfu vertico marginalia cape kind-icon
        which-key
        pdf-tools auctex cdlatex yasnippet
        magit
        nix-mode
      ];

    };

    home.file."emacs-init" = {
      target = ".emacs.d/init.el";
      text = ''
;; -*- lexical-binding: t -*-
(use-package emacs
  :config
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (load custom-file)

  (setq inhibit-startup-screen t)

  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)

  (set-frame-font "Cascadia Code-12")

  (let ((backup-dir (expand-file-name "backup/" user-emacs-directory)))
    (unless (file-exists-p backup-dir)
      (make-directory backup-dir))
    (setq backup-directory-alist `(("." . ,backup-dir))))
  
  (setq auto-save-file-name-transforms
	`((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t))))
(use-package doom-themes
  :config
  (load-theme 'doom-one t))
(use-package doom-modeline
  :config
  (doom-modeline-mode t))
(use-package corfu
  :demand t
  :hook (after-init . global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary 'separator)
  (corfu-on-exact-match 'show)
  :bind
  (("C-;" . completion-at-point))
  :config
  (keymap-unset corfu-map "TAB")
  (keymap-unset corfu-map "RET")
  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1)
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file))
(use-package vertico
  :demand t
  :diminish
  :bind (:map minibuffer-local-map
	      ("C-n" . vertico-next)
	      ("C-p" . vertico-previous)
	      ("C-;" . vertico-insert))
  :custom
  (vertico-cycle t)
  :config
  (vertico-mode t))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
	      ("C-h" . vertico-directory-delete-word)))

(use-package marginalia
  :custom
  (marginalia-align 'right)
  :config
  (marginalia-mode t))
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode))

(use-package auctex
  :hook ((LaTeX-mode . TeX-fold-mode)
	 (LaTeX-mode . turn-on-reftex))
  :custom
  (TeX-source-correlate-mode t)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	TeX-source-correlate-start-server t)

  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

(use-package cdlatex
  :hook (LaTeX-mode . cdlatex-mode)
  :bind (:map cdlatex-mode-map
	      ("<tab>" . cdlatex-tab))
  :config
  (setq cdlatex-use-dollar-to-ensure-math nil
	cdlatex-insert-auto-labels-in-env-templates nil)

  (setq cdlatex-math-modify-alist
	'((?B "\\mathbb" nil t nil nil)))

  (setq cdlatex-math-symbol-alist
	'((?: ("\\colon")))))

(use-package yasnippet
  :hook
  (post-self-insert . my/yas-try-expanding-auto-snippets)
  :config
  (yas-global-mode 1)
  (setq yas-triggers-in-field t)

  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ``(require-snippet-condition . auto)))
        (yas-expand)))))

(use-package cdlatex
  :hook ((cdlatex-tab . yas-expand)
         (cdlatex-tab . cdlatex-in-yas-field))
  :config
  (use-package yasnippet
    :bind (:map yas-keymap
		("<tab>" . yas-next-field-or-cdlatex)
		("TAB" . yas-next-field-or-cdlatex))
    :config
    (defun cdlatex-in-yas-field ()
      ;; Check if we're at the end of the Yas field
      (when-let* ((_ (overlayp yas--active-field-overlay))
                  (end (overlay-end yas--active-field-overlay)))
        (if (>= (point) end)
            ;; Call yas-next-field if cdlatex can't expand here
            (let ((s (thing-at-point 'sexp)))
              (unless (and s (assoc (substring-no-properties s)
                                    cdlatex-command-alist-comb))
                (yas-next-field-or-maybe-expand)
                t))
          ;; otherwise expand and jump to the correct location
          (let (cdlatex-tab-hook minp)
            (setq minp
                  (min (save-excursion (cdlatex-tab)
                                       (point))
                       (overlay-end yas--active-field-overlay)))
            (goto-char minp) t))))

    (defun yas-next-field-or-cdlatex nil
      (interactive)
      "Jump to the next Yas field correctly with cdlatex active."
      (if
          (or (bound-and-true-p cdlatex-mode)
              (bound-and-true-p org-cdlatex-mode))
          (cdlatex-tab)
        (yas-next-field-or-maybe-expand)))))
'';
    };
  };
}
