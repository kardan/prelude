;;; kardan-conf.el --- Kardans's configuration

;;; Commentary:

;; Keep this minimal

;;; Code:
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)


(add-to-list 'package-archives
			 '("marmalade" . "http://marmalade-repo.org/packages/") t)


(declare-function prelude-require-packages "prelude-packages.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Packages and PATH
;;;

(prelude-require-packages '(ag
                            aggressive-indent
                            dockerfile-mode
                            doom-themes
                            fish-mode
                            flatland-theme
                            flycheck-clj-kondo
                            kaocha-runner
                            rjsx-mode))

(setenv "PATH" (concat (getenv "PATH") ":~/.npm-packages/bin"))
(setq exec-path (append exec-path '("~/.npm-packages/bin")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Look n feel
;;;

(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

(setq initial-scratch-message ";;
;;     ▄█   ▄█▄    ▄████████    ▄████████ ████████▄     ▄████████ ███▄▄▄▄
;;     ███ ▄███▀   ███    ███   ███    ███ ███   ▀███   ███    ███ ███▀▀▀██▄
;;     ███▐██▀     ███    ███   ███    ███ ███    ███   ███    ███ ███   ███
;;    ▄█████▀      ███    ███  ▄███▄▄▄▄██▀ ███    ███   ███    ███ ███   ███
;;   ▀▀█████▄    ▀███████████ ▀▀███▀▀▀▀▀   ███    ███ ▀███████████ ███   ███
;;     ███▐██▄     ███    ███ ▀███████████ ███    ███   ███    ███ ███   ███
;;     ███ ▀███▄   ███    ███   ███    ███ ███   ▄███   ███    ███ ███   ███
;;     ███   ▀█▀   ███    █▀    ███    ███ ████████▀    ███    █▀   ▀█   █▀
;;     ▀                        ███    ███ ")


(defun style ()
  "Look n feel"
  ;; General
  (toggle-scroll-bar -1)

  ;; Text
  (mac-auto-operator-composition-mode t)
  (setq-default line-spacing 0.4)
  (set-frame-font "Operator Mono Lig Medium 14")

  ;; Dark Theme, To fix issue with fringe in material load flatland first.
  (load-theme 'flatland t)
  (load-theme 'doom-material t)
  (set-face-attribute 'region nil :background "#111")

  ;; Light theme
  ;; (load-theme 'flatui)
  )

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (with-selected-frame frame
                  (style))))
  (style))


(setq history-delete-duplicates t)

(defvar aggressive-indent-excluded-modes)
(global-aggressive-indent-mode 1)
(add-to-list 'aggressive-indent-excluded-modes 'Dockerfile)

(add-hook 'prog-mode-hook 'hs-minor-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Org mode
;;;

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (sql . t)
   (shell . t)
   (clojure . t)))

(defun my-org-confirm-babel-evaluate (lang body)
  (not (member lang '("emacs-lisp" "sql" "clojure" "shell"))))
(defvar org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Clojure
;;;

(require 'flycheck-clj-kondo)

(defun clojure-mode-config()
  "Clojure config"
  (defvar clojure-indent-style 'align-arguments)
  (defvar cider-overlays-use-font-lock t))

(add-hook 'clojure-mode-hook #'clojure-mode-config)

(defun browse-spec (spec)
  (interactive (list (cider-symbol-at-point)) )
  (let ((last-sexp (nrepl-dict-get (cider-nrepl-sync-request:eval
                                    (cider-symbol-at-point)) "value")))
    (cider-browse-spec last-sexp)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Custom Keybindings
;;;

(global-set-key (kbd "C-ï") 'helm-do-ag)

(global-set-key (kbd "C-M-<return>") 'hs-toggle-hiding)
(global-set-key (kbd "C-M-<down>") 'hs-show-all)
(global-set-key (kbd "C-M-<up>") 'hs-hide-all)

;;; Kardan-conf.el ends here
