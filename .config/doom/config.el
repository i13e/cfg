;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; ;; credit to sunnyhasija/Academic-Doom-Emacs-Config and tecosaur
;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ian Breckenridge"
      user-mail-address "ianb@ianb.io")


(setq auto-save-default t
      make-backup-files t
      undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      make-backup-files t                         ;
      confirm-kill-emacs nil                      ;
      inhibit-compacting-font-caches t            ; When there are lots of glyphs, keep them in memory
      truncate-string-ellipsis "…")               ; Unicode ellispis are nicer than "...", and also save /precious/ space

(delete-selection-mode 1)                         ; Replace selection when inserting text
(display-time-mode 1)                             ; Enable time in the mode-line
(global-subword-mode 1)                           ; Iterate through CamelCase words

(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))                           ; On laptops it's nice to know how much power you have

(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))
(setq +ivy-buffer-preview t)

(defun doom-modeline-conditional-buffer-encoding ()
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(map! :map evil-window-map
      "SPC" #'rotate-layout
      "<left>"     #'evil-window-left
       "<down>"     #'evil-window-down
       "<up>"       #'evil-window-up
       "<right>"    #'evil-window-right
       ;; Swapping windows
       "C-<left>"       #'+evil/window-move-left
       "C-<down>"       #'+evil/window-move-down
       "C-<up>"         #'+evil/window-move-up
       "C-<right>"      #'+evil/window-move-right)

(setq frame-title-format
    '(""
      (:eval
       (if (s-contains-p org-roam-directory (or buffer-file-name ""))
           (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
         "%b"))
      (:eval
       (let ((project-name (projectile-project-name)))
         (unless (string= "-" project-name)
           (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

;;(setq comp-deferred-compilation t)
;;(setq package-native-compile t)

(setq scroll-margin 0
      scroll-conservatively 100
      scroll-preserve-screen-position t
      auto-window-vscroll nil)

;(after! centaur-tabs
 ; (centaur-tabs-mode -1)
  ;(setq centaur-tabs-height 36
   ;     centaur-tabs-set-icons t
    ;    centaur-tabs-modified-marker "o"
     ;   centaur-tabs-close-button "×"
      ;  centaur-tabs-set-bar 'above)
       ; centaur-tabs-gray-out-icons 'buffer
  ;(centaur-tabs-change-fonts "monospace" 160))
;; (setq x-underline-at-descent-line t)

(setq doom-font (font-spec :family "monospace" :size 15)
      doom-variable-pitch-font (font-spec :family "sans" :size 15)
      doom-big-font (font-spec :family "monospace" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(setq doom-theme 'doom-nord)

(setq display-line-numbers-type t)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


(setq org-directory "~/docs/code/org/"
      org-agenda-files '("~/code/org/agenda.org")
      org-default-notes-file (expand-file-name "notes.org" org-directory)
      org-archive-location (concat org-directory ".archive/%s::")
      org-roam-directory (concat org-directory "notes/")
      org-roam-db-location (concat org-roam-directory ".org-roam.db")
      org-startup-folded 'overview
      org-log-done 'time
      org-ellipsis " […]"
      org-journal-encrypt-hournal t
      org-journal-file-format "%Y%m%d.org"
      org-hide-emphasis-markers t)



;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;;
;; elfeed
;;
;; (setq +doom-dashboard-banner-file (expand-file-name "logo.png" doom-private-dir))
(setq fancy-splash-image (concat doom-private-dir "splash.png"))

;;shortcut functions
(defun bjm/elfeed-show-all ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-all"))
(defun bjm/elfeed-show-emacs ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-emacs"))
(defun bjm/elfeed-show-daily ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-daily"))

;(defun browse-url-mpv (url &optional new-window)
;    (start-process "mpv" "*mpv*" "mpv" url))

;(setq browse-url-browser-function '(("https:\\/\\/www\\.youtube." . browse-url-mpv)
 ;                                   ("." . browse-url-generic-program))
  ;    browse-url-generic-program "/usr/bin/qutebrowser" )
;(require 'disp-table)
;(require 'nano-theme-dark)
;(require 'nano-help)
;(require 'nano-modeline)
;(require 'nano-layout)
;; refresh database
(defun bjm/elfeed-load-db-and-open ()
  (interactive)
  (elfeed-db-load)
  (elfeed)
  (elfeed-search-update--force))
(defun bjm/elfeed-save-db-and-bury ()
  (interactive)
  (elfeed-db-save)
  (quit-window))


(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.
(setq-default history-length 1000)
(setq-default prescient-history-length 1000)
