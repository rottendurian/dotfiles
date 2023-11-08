;; 1. Packages
(require 'package)

(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")) ;; ELPA and NonGNU ELPA are default in Emacs28
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") ;; w/o this Emacs freezes when refreshing ELPA
(package-initialize)
(setq package-enable-at-startup nil)

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-verbose nil)


;; 2. GC
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-percentage 0.1))) ;; Default value for `gc-cons-percentage'

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))


;; 3. Evil mode (vim bindings)
(use-package evil
	:init
	(setq evil-want-keybinding nil)
	(setq evil-vsplit-window-right t)
	(setq evil-split-window-below t)
	(evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer))
  :custom (evil-collection-setup-minibuffer t)
  (evil-collection-init))


;; 4. Undo tree
(use-package undo-tree
  :init
  (global-undo-tree-mode 1))

(setq undo-tree-history-directory-alist '(("." . "~/.config/emacs/undo")))
;; backups go in here
(setq backup-directory-alist `(("." . "~/.config/emacs/saves")))


;; rainbow mode (ex. #ffffff).
(use-package rainbow-mode
  :hook org-mode prog-mode)


;; 5. Doom packages (theming)
(use-package doom-themes
  :defer t
  :init
  (load-theme 'doom-one t)
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")


;; hide ui stuff
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; line numbers
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(setq display-line-numbers 'relative)
(setq-default display-line-numbers-type 'relative)


;; functions needed for some keybinds
(defun  center-forward-paragraph()
  "scroll down half a page while keeping the cursor centered"
  (interactive)
  (let ((ln (line-number-at-pos (point)))
	(lmax (line-number-at-pos (point-max))))
    (cond ((= ln 1) (move-to-window-line nil))
	  ((= ln lmax) (recenter (window-end)))
	  (t (progn
               (move-to-window-line -1)
               (recenter))))))

(defun center-backward-paragraph ()
  "scroll up half a page while keeping the cursor centered"
  (interactive)
  (let ((ln (line-number-at-pos (point)))
	(lmax (line-number-at-pos (point-max))))
    (cond ((= ln 1) nil)
	  ((= ln lmax) (move-to-window-line nil))
	  (t (progn
               (move-to-window-line 0)
               (recenter))))))

(with-eval-after-load "org"
  (define-key org-mode-map (kbd "C-k") 'center-backward-paragraph)
  (define-key org-mode-map (kbd "C-j") 'center-forward-paragraph))


;; quick switch
(load-file "~/.config/emacs/quick-switch.el")

;; keybinds
(use-package general
  :config
  (general-evil-setup)

  (global-set-key (kbd "C-1") (lambda () (interactive) (quick-switch-to-buffer 0)))
  (global-set-key (kbd "C-2") (lambda () (interactive) (quick-switch-to-buffer 1)))
  (global-set-key (kbd "C-3") (lambda () (interactive) (quick-switch-to-buffer 2)))
  (global-set-key (kbd "C-4") (lambda () (interactive) (quick-switch-to-buffer 3)))
  (global-set-key (kbd "C-5") (lambda () (interactive) (quick-switch-to-buffer 4)))
  (global-set-key (kbd "C-6") (lambda () (interactive) (quick-switch-to-buffer 5)))
  (global-set-key (kbd "C-7") (lambda () (interactive) (quick-switch-to-buffer 6)))
  (global-set-key (kbd "C-8") (lambda () (interactive) (quick-switch-to-buffer 7)))
  (global-set-key (kbd "C-9") (lambda () (interactive) (quick-switch-to-buffer 8)))
  (global-set-key (kbd "C-0") (lambda () (interactive) (quick-switch-to-buffer 9)))

  (global-set-key (kbd "C-!") (lambda () (interactive) (quick-switch-add-buffer 0)))
  (global-set-key (kbd "C-@") (lambda () (interactive) (quick-switch-add-buffer 1)))
  (global-set-key (kbd "C-#") (lambda () (interactive) (quick-switch-add-buffer 2)))
  (global-set-key (kbd "C-$") (lambda () (interactive) (quick-switch-add-buffer 3)))
  (global-set-key (kbd "C-%") (lambda () (interactive) (quick-switch-add-buffer 4)))
  (global-set-key (kbd "C-^") (lambda () (interactive) (quick-switch-add-buffer 5)))
  (global-set-key (kbd "C-&") (lambda () (interactive) (quick-switch-add-buffer 6)))
  (global-set-key (kbd "C-*") (lambda () (interactive) (quick-switch-add-buffer 7)))
  (global-set-key (kbd "C-(") (lambda () (interactive) (quick-switch-add-buffer 8)))
  (global-set-key (kbd "C-)") (lambda () (interactive) (quick-switch-add-buffer 9)))

  (define-key evil-motion-state-map (kbd "u") 'undo-tree-undo)

  (define-key evil-motion-state-map (kbd "g c") 'comment-line)

  (global-set-key (kbd "C-h") 'beginning-of-line-text)           ;; start of line
  (global-set-key (kbd "C-k") 'center-backward-paragraph)   ;; up
  (global-set-key (kbd "C-j") 'center-forward-paragraph)    ;; down
  (global-set-key (kbd "C-l") 'end-of-line)                 ;; end of line\

  (define-key evil-motion-state-map (kbd "C-k") 'center-backward-paragraph)   ;; up
  (define-key evil-motion-state-map (kbd "C-j") 'center-forward-paragraph)    ;; down
  (define-key evil-insert-state-map (kbd "C-k") 'center-backward-paragraph)   ;; up
  (define-key evil-insert-state-map (kbd "C-j") 'center-forward-paragraph)    ;; down
  
  ;; set up 'SPC' as the global leader key
  (general-create-definer leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode
  
  (leader-keys
    "." '(find-file :wk "Find file")
    "f c" '((lambda () (interactive) (find-file "~/.config/emacs/init.el")) :wk "Edit emacs config")
    ;; "f r" '(counsel-recentf :wk "Find recent files")
    "g c" '(comment-line :wk "Comment lines")
    "p" '(lambda () (interactive) (execute-kbd-macro (kbd "\"+p")))
    "P" '(lambda () (interactive) (execute-kbd-macro (kbd "\"+P")))
    "y" '(lambda () (interactive) (execute-kbd-macro (kbd "\"+y")))
    "f f" '(fzf :wk "fuzzy find file")
    "F" '(fzf-directory default-directory :wk "fuzzy find file")
    "f g" '(fzf-grep-in-dir :wk "grep search dir")
    "u" '(lambda () (interactive) (undo-tree-visualize)))

  (leader-keys
    "b" '(:ignore t :wk "buffer")
    "b b" '(switch-to-buffer :wk "Switch buffer")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-this-buffer :wk "Kill this buffer")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer"))

  (leader-keys
    "h" '(:ignore t :wk "Help")
    "h f" '(describe-function :wk "Describe function")
    "h v" '(describe-variable :wk "Describe variable")
	"h k" '(describe-key :wk "Describe keybind")
    "h t" '(load-theme :wk "Load theme"))

  (leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t t" '(visual-line-mode :wk "Toggle truncated lines")
    "t s" '(shell :wk "open a eshell")
    "t b" '(shell-command :wk "run a shell command"))

  (leader-keys
    "d" '(:ignore t :wk "Dired")
    "d d" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current"))
  

  (global-set-key (kbd "C-=") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
  (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
  )


;; gives sudo edit permissions if we need it
(use-package sudo-edit
  :config
  (leader-keys
    "fu" '(sudo-edit-find-file :wk "Sudo find file")
    "fU" '(sudo-edit :wk "Sudo edit file")))


;; fuzzy finding
(use-package fzf
  :bind
    ;; Don't forget to set keybinds!
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        ;; fzf/grep-command "rg --no-heading -nH"
        fzf/grep-command "grep -nrH"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        fzf/window-height 15))

;; completitions
(defun basic-completion-style ()
  (setq completion-auto-wrap t
        completion-auto-select 'second-tab
        completion-auto-help 'always
        completion-show-help nil
        completions-format 'one-column
        completions-max-height 10))

(defun icomplete-vertical-style ()
  (setq completion-auto-wrap t
        completion-auto-help nil
        completions-max-height 15
        completion-styles '(initials flex)
        icomplete-in-buffer t
        max-mini-window-height 10)

  (icomplete-mode 1)
  (icomplete-vertical-mode 1))

(defun fido-style ()
  (setq completion-auto-wrap t
        completion-auto-help nil
        completions-max-height 15
        completion-styles '(flex)
        icomplete-in-buffer t
        max-mini-window-height 10)

  (fido-mode 1)
  (fido-vertical-mode 1))

;; Bind C-r to show minibuffer history entries
;; (keymap-set minibuffer-mode-map "C-c" #'minibuffer-complete-history)


;; fonts
(set-face-attribute 'default nil 
	            :height 150
	            :font "Fira Code Medium")

(setq inhibit-startup-screen t)

;; Don't warn for large files (shows up when launching videos)
(setq large-file-warning-threshold nil)

;; Don't warn for following symlinked files
(setq vc-follow-symlinks t)

;; Don't warn when advice is added for functions
(setq ad-redefinition-action 'accept)


(setq-default tab-width 4)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 4 200 4))
(setq c-basic-offset 4) 

(defun fix-syntax-tree ()
  "treats - and _ as parts of words"
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w"))
;; treats "-" "_" as parts of words
(add-hook 'after-change-major-mode-hook
          (lambda () (fix-syntax-tree)))

;; frame stuff and transparency 
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "3cdd0a96236a9db4e903c01cb45c0c111eb1492313a65790adb894f9f1a33b2d" "13096a9a6e75c7330c1bc500f30a8f4407bd618431c94aeab55c9855731a95e1" "88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "631c52620e2953e744f2b56d102eae503017047fb43d65ce028e88ef5846ea3b" "5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" default))
 '(package-selected-packages '(evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
