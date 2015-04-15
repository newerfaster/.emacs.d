(require 'cask "~/.cask/cask.el")
(cask-initialize)

;;;;;;;;;;;;;;;;;;;;;;
; making it vim-like ;
;;;;;;;;;;;;;;;;;;;;;;

(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Magit ... make it sensible for a vim user ... this was not straightfoward
; the strategy employed is to nuke magit-mode's keymap and set evil-motion-state-map
; as its parent keymap, and then to hook each magit-*-mode, nuke its keymap,
; and define bindings to my liking (and I'm discovering and fixing inadequacies as I go)

; for debugging keybindings
(defun say-poo () (interactive) (message "Poo!"))

(use-package magit
  :init
  (progn
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; bindings to enter various magit modes
    (evil-leader/set-key "gs" 'magit-status)
    (evil-leader/set-key "gd" 'magit-diff-unstaged)
    (evil-leader/set-key "qc" (lambda () (interactive) (call-interactively 'magit-stage-all) (call-interactively 'magit-commit)))
    
    ;(evil-leader/set-key "gcm" 'magit-commit)
    ;(evil-leader/set-key "gco" 'magit-checkout)
    (evil-leader/set-key "gl" 'magit-log)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; load my evil overrides for magit-*-mode
    (load "~/.emacs.d/evil-magit.el")
    (set-evil-magit-bindings)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; start commit with insert mode
    (evil-set-initial-state 'git-commit-mode 'insert)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; silence the warning that buffers out of sync with the index will be auto-reverted
    (setq magit-last-seen-setup-instructions "1.4.0"))
  :config
  (progn
    (set-evil-magit-bindings)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; shells, embedded external tools, aliases for environment variables

; FIXME ... this is very specific to me and I should find another way of doing this
(load "/home/blake/.sensitive.el")

(load "~/.emacs.d/mysql.el")

(use-package inf-mongo
  :config
  (progn
    (evil-leader/set-key ",mipro" (lambda () (interactive) (inf-mongo mongo-iris-prod-read-only)))
    (evil-leader/set-key ",mid" (lambda () (interactive) (inf-mongo mongo-iris-dev)))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; uber emacs features

(use-package ace-jump-mode
  :init
  (define-key evil-normal-state-map (kbd "SPC") 'ace-jump-two-chars-mode)
  :config
  (progn
    (defun ace-jump-two-chars-mode (query-char query-char-2)
      "AceJump two chars mode"
      (interactive (list (read-char "First Char:")
                         (read-char "Second:")))
    
      (if (eq (ace-jump-char-category query-char) 'other)
        (error "[AceJump] Non-printable character"))
    
      ;; others : digit , alpha, punc
      (setq ace-jump-query-char query-char)
      (setq ace-jump-current-mode 'ace-jump-char-mode)
      (ace-jump-do (regexp-quote (concat (char-to-string query-char)
                                         (char-to-string query-char-2)))))
    ))

; FIXME want it ... but disabled it because it fucks with comments when I move over them with evil motions
;(use-package aggressive-indent
;  :init
;  (progn
;    (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
;    (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
;    (add-hook 'css-mode-hook #'aggressive-indent-mode)))


(use-package projectile
  :init
  (progn
    (projectile-global-mode)
    (setq projectile-completion-system 'grizzl)
    ; annoying, this does not work at all, making ,pf USELESS and ,pg bad
    ; (add-to-list 'projectile-globally-ignored-files "*.~undo-tree~")
    ;(setq projectile-use-native-indexing t)
    )
  :config
  (progn
    (evil-leader/set-key "pf" 'projectile-find-file)
    (evil-leader/set-key "pa" 'projectile-ag)
    (evil-leader/set-key "pk" 'projectile-kill-buffers)))


(use-package evil
  :demand t
  :init
  (progn
    (load "~/.emacs.d/make-everything-evil.el")
    (global-set-key (kbd "<f5>" ) 'evil-mode) ; handy until I fix all the major modes which do not have evil-motion
    (use-package evil-leader
      :init (global-evil-leader-mode)
      :config
      (progn
        (evil-leader/set-leader ",")
        ;(evil-leader/in-all-states) ; not working, try again
        ;(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
        ;(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
        ;(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
        ;(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
        ;(evil-leader/set-key-for-mode 'clojure-mode "ral" 'cljr-add-missing-libspec)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rai" 'cljr-add-import)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rar" 'cljr-add-require)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rci" 'cljr-cycle-if)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rdk" 'cljr-destructure-keys)
        ;(evil-leader/set-key-for-mode 'clojure-mode "ril" 'cljr-introduce-let)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rel" 'cljr-expand-let)
        ;(evil-leader/set-key-for-mode 'clojure-mode "ref" 'cljr-extract-function)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rfu" 'cljr-find-usages)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rml" 'cljr-move-to-let)
        ;(evil-leader/set-key-for-mode 'clojure-mode "rpf" 'cljr-promote-function )
        ;(evil-leader/set-key-for-mode 'clojure-mode "rrs" 'cljr-rename-symbol)
        (evil-leader/set-key-for-mode 'clojure-mode "ee" 'cider-eval-last-sexp)
        (evil-leader/set-key-for-mode 'clojure-mode "eb" 'cider-eval-buffer)
        (evil-leader/set-key-for-mode 'clojure-mode "er" 'cider-eval-region)
        (evil-leader/set-key-for-mode 'clojure-mode "ef" 'cider-eval-defun-at-point)
        (evil-leader/set-key-for-mode 'emacs-lisp-mode "ee" 'eval-last-sexp)
        (evil-leader/set-key-for-mode 'emacs-lisp-mode "eb" 'eval-buffer)
        (evil-leader/set-key-for-mode 'emacs-lisp-mode "er" 'eval-region)
        (evil-leader/set-key-for-mode 'emacs-lisp-mode "ef" 'eval-defun)
        (evil-leader/set-key "b." 'previous-buffer)
        (evil-leader/set-key "b," 'next-buffer)
        (evil-leader/set-key "bl" 'buffer-menu)
        (evil-leader/set-key "wd" 'delete-window)
        (evil-leader/set-key "wo" 'delete-other-windows)
        (evil-leader/set-key "bk" 'kill-buffer-and-window)
        (evil-leader/set-key "bd" 'kill-buffer)
        (evil-leader/set-key ",x" 'smex)
        (evil-leader/set-key ",,x" 'smex-major-mode-commands) ; not sure I like these bindings being evil-only, they should be global
        (evil-leader/set-key ",w" 'make-frame)
        (evil-leader/set-key ",do" 'delete-other-windows)
	))
    (use-package evil-surround
      :init (global-evil-surround-mode 1)))
  :config
  (progn
    (setq evil-cross-lines t)
    (setq evil-move-cursor-back nil)
    (setq-default truncate-lines t)))

(setq undo-tree-auto-save-history t)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)


;;;;;;;;;;;;;;;;;;
;; autocomplete ;;
;;;;;;;;;;;;;;;;;;

(use-package company
  :init (global-company-mode)
;(add-hook 'cider-repl-mode-hook #'company-mode)
;(add-hook 'cider-mode-hook #'company-mode)
  :config
  (progn
    (eval-after-load 'company
      '(push 'company-robe company-backends))

    (defun indent-or-complete ()
      (interactive)
      (if (looking-at "\\_>")
          (company-complete-common)
        (indent-according-to-mode)))

    (global-set-key "\t" 'indent-or-complete)))

;;;;;;;;;;;
; visuals ;
;;;;;;;;;;;

(load-theme 'solarized-dark t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-relative-line-numbers-mode) ; unfortunately breaks autocomplete

(let ((font "Menlo:pixelsize=24"))
  (set-face-attribute 'default nil :font font)
  (set-frame-font font nil t))

;;;;;;;;;;;
; clojure ;
;;;;;;;;;;;

(use-package evil-smartparens
  :init
  (progn
    (add-hook 'clojure-mode-hook #'evil-smartparens-mode)
    (add-hook 'clojure-mode-hook #'smartparens-strict-mode)
    (add-hook 'emacs-lisp-mode-hook #'evil-smartparens-mode)
    (add-hook 'emacs-lisp-mode-hook #'smartparens-strict-mode))
  :config
  (progn
    (sp-with-modes '(clojure-mode emacs-lisp-mode)
      (sp-local-pair "'" nil :actions nil)))) ; for lisp modes do not treat single-quote as a pairing

; yasnippet (required for certain features of clj-refactor)
;(use-package yasnippet
;  :init
;  (progn
;    (yas-global-mode 1)
;    (use-package clojure-snippets)))

;(use-package clj-refactor
;  :init
;  (progn
;    (add-hook 'clojure-mode-hook (lambda ()
;                                   (clj-refactor-mode 1)
;                                   (setq cljr-magic-requires t) ; turned this off because it is _crazy_ slow even with an empty file!
;                                   ;(evil-leader/set-leader ",")
;					;(evil-leader/set-key "" 'cljr-)
;                                   ;(evil-leader/set-key "" 'cljr-)
;                                   ;(evil-leader/set-key "" 'cljr-)
;                                   ))))

(use-package clojure-mode
  :mode ("\\.edn$" . clojure-mode)
  :init
  (progn
    (use-package cider
      :init
      (progn
        (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
        (add-hook 'cider-repl-mode-hook 'subword-mode)
        ;(use-package slamhound)
	)
      :config
      (progn
        (setq nrepl-hide-special-buffers t)
        (setq cider-popup-stacktraces-in-repl t)
        (setq cider-repl-history-file "~/.emacs.d/nrepl-history")
        (setq cider-repl-pop-to-buffer-on-connect nil)
        (setq cider-repl-use-clojure-font-lock t)
        (setq cider-auto-select-error-buffer nil)
        (setq cider-prompt-save-file-on-load nil))))
  :config
  (progn
    (global-set-key [f9] 'cider-jack-in)

    (setq clojure--prettify-symbols-alist
          '(("fn"  . ?λ)
            ("comp" . ?∘)
            ("filter" . ?Ƒ)
            ("not=" . ?≠)
            ("some" . ?∃)
            ("none?" . ?∄)
            ("map" . ?∀)
            ("true" . ?𝐓)
            ("false" . ?𝐅)
            ("->" . ?→)
            ("cons" . ?«)
            ("->>" . ?⇒)
            ("and" . ?∧)
            ("or" . ?∨)
            ("<=" . ?≤)
            (">=" . ?≥)
            ("<!" . ?⪡)
            (">!" . ?⪢ )
            ("<!!" . ?⫷ )
            (">!!" . ?⫸ )
            ;("" . ?◉ )
            ;("" . ?⧬ )
            ;("" . ?⧲ )
            ("partial" . ?⋈ )
            ;("" . ?⚇ )
            ;("" . ?◍ )
            ;⟅ ⟆ ⦓ ⦔ ⦕ ⦖ ⸦ ⸧ ⸨ ⸩ ｟ ｠ ⧘ ⧙ ⧚ ⧛ ︷ ︸
            ;∾ ⊺ ⋔ ⫚ ⟊ ⟔ ⟓ ⟡ ⟢ ⟣ ⟤ ⟥
            ("loop" . ?◎ )
            ("recur" . ?◉ )
            ("reduce" . ?∑ )
            ("chan" . ?≋ )
            ;("" . ? )
            ("complement" . ?∁)
            ("identical?" . ?≡)))

    (defun toggle-nrepl-buffer ()
      "Toggle the nREPL REPL on and off"
      (interactive)
      (if (string-match "cider-repl" (buffer-name (current-buffer)))
          (delete-window)
        (cider-switch-to-relevant-repl-buffer)))

    (defun cider-project-reset ()
      (interactive)
      (cider-interactive-eval "(reloaded.repl/reset)"))

    (evil-leader/set-key "cd" 'cider-doc)
    (evil-leader/set-key "cc" 'cider-connect)
    (evil-leader/set-key "ct" 'cider-test-run-tests)
    (evil-leader/set-key "cr" 'toggle-nrepl-buffer)
    (evil-leader/set-key "cR" 'cider-project-reset)))

(dolist (mode '(clojure-mode clojurescript-mode cider-mode))
  (eval-after-load mode
    (font-lock-add-keywords
     mode '(("(\\(fn\\)[\[[:space:]]"  ; anon funcs 1
             (0 (progn (compose-region (match-beginning 1)
                                       (match-end 1) "λ")
                       nil)))
            ("\\(#\\)("                ; anon funcs 2
             (0 (progn (compose-region (match-beginning 1)
                                       (match-end 1) "ƒ")
                       nil)))
            ("\\(#\\){"                 ; sets
             (0 (progn (compose-region (match-beginning 1)
                                       (match-end 1) "∈")
                       nil)))))))

(add-hook 'emacs-lisp-mode-hook 'prettify-symbols-mode)
(add-hook 'clojure-mode-hook 'prettify-symbols-mode)


;;;;;;;;;;;;
;;; ruby ;;;
;;;;;;;;;;;;

(use-package robe
  :init
  (progn
    (defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
      (rvm-activate-corresponding-ruby))

    (evil-define-key 'normal robe-mode-map (kbd "g f") 'robe-jump)
    (evil-define-key 'normal robe-mode-map (kbd "g d") 'robe-doc)
    
    (add-hook 'robe-mode-hook 'ac-robe-setup) ; TODOcompletion with company
    (add-hook 'ruby-mode-hook 'robe-mode))
  :config
  (progn
    (diminish 'robe-mode " R0β3")))

(use-package rinari
  :init
  (progn
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; python ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package elpy
  :config
  (progn
    (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w"))) ; TODO do this for - in lisp etc (makes _ a word char)
    (evil-leader/set-key "wo" 'pyenv-workon)
    (add-hook 'python-mode-hook #'(lambda () (elpy-enable))))) ; doing this in a hook because I'm afraid of enabling elpy as soon as emacs starts

;(use-package jedi
;  :config
;  (progn
;    (add-hook 'python-mode-hook 'jedi:setup)
;    (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w"))) ; TODO do this for - in lisp etc (makes _ a word char)
;    (setq jedi:complete-on-dot t)))


;;;;;;;;;;;;;;;;;;;
; custom set crap ;
;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
