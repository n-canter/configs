(setq user-full-name "Max Shegai")
(setq user-mail-address "max.shegai@gmail.com")


; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(add-to-list 'package-archives
                       '("melpa" . "http://melpa.org/packages/"))

; list the packages you want
(setq package-list '(drag-stuff
                    neotree
                    auto-complete
                    exec-path-from-shell
                    flycheck
                    evil-nerd-commenter
                    projectile
                    clang-format
		    helm
		    helm-core
		    helm-go-package
		    helm-gtags
                    helm-projectile
                    ggtags
                    magit
                    go-mode
                    go-autocomplete
                    go-eldoc
                    go-guru
                    monokai-theme
  ))
; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


(add-to-list 'load-path "~/.emacs.d/lisp/")
(load "protobuf-mode")
(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))


;startup

(load-theme 'monokai t)

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

(toggle-frame-fullscreen)

(setq make-backup-files nil)

;(set-frame-font "InconsolataLGC-16")
(set-face-attribute 'default nil :font "InconsolataLGC-13" )
(set-frame-font "InconsolataLGC-13" nil t)

(add-hook 'prog-mode-hook 'drag-stuff-mode)
(global-set-key (kbd "M-p") 'drag-stuff-up)
(global-set-key (kbd "M-n") 'drag-stuff-down)

(global-set-key (kbd "C-?") 'help-command)
(global-set-key (kbd "M-?") 'mark-paragraph)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)
(global-set-key (kbd "C-c C-i") 'helm-imenu)
(global-set-key [f8] 'neotree-toggle)

(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(global-set-key [f9] 'show-file-name) 

(evilnc-default-hotkeys)

(global-linum-mode 1)
(global-flycheck-mode)
(setq column-number-mode t)

(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)
(setq visible-bell 1)

(display-battery-mode 1)
(display-time-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq-default indent-tabs-mode nil)
(setq tab-width 4)

(setq exec-path (cons "/usr/local/go/bin" exec-path))
(add-hook 'before-save-hook 'gofmt-before-save)

(defun my-go-mode-hook ()
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving                                                    
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 4)
  (setq indent-tabs-mode 1)
  ; Godef jump key binding                                                      
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-,") 'pop-tag-mark)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)



(add-hook 'go-mode-hook 'go-eldoc-setup)

(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(with-eval-after-load 'go-mode
   (require 'go-autocomplete))
(require 'auto-complete-config)
(ac-config-default)

(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
        (revert-buffer t t t) )))
  (message "Refreshed open files.") )




(require 'helm-config)
(helm-mode 1)
(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
(global-set-key (kbd "M-x") 'helm-M-x)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(require 'go-projectile)


(add-hook 'python-mode-hook 'anaconda-mode)

(defun my-c-mode-common-hook ()
 (setq c++-tab-always-indent t)
 (setq c-basic-offset 4)                  ;; Default is 2
 (setq c-indent-level 4)                  ;; Default is 2

 (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
 (setq tab-width 4)
 (setq indent-tabs-mode 1)  ; use spaces only if nil
 (local-set-key (kbd "C-c f") 'clang-format-buffer))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(require 'ggtags)
(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)



