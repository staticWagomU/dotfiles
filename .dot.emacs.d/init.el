(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(misterioso))
 '(init-loader-show-log-after-init 'error-only))

(setq visible-bell 1)
(set-message-beep 'silent)

;;; 消すやつ
;(menu-bar-mode 0)
(tool-bar-mode 0)
(setq inhibit-startup-message t)
(setq initial-scratch-message "");;バージョンによっては nil だと消えない時ある
(fringe-mode 0);;ムカつくから消してる

;;; 色とか見た目とか
;(set-background-color "Gray12")
;(set-foreground-color "LightGray")
;(set-cursor-color "Gray")
;(set-face-attribute 'mode-line nil :box nil :background "HotPink")
(set-scroll-bar-mode 'right)
(show-paren-mode t)
(set-scroll-bar-mode 'nil)
(blink-cursor-mode 0)
(column-number-mode t)
;(line-number-mode)
(setq-default tab-width 4)

(setq-default truncate-lines "")
(setq-default truncate-partial-width-windows "")

(global-font-lock-mode t)
(transient-mark-mode t)

;(global-linum-mode)
(setq linum-mode t)

;; Shell 名の設定
;(setq shell-file-name "c:/msys64/usr/bin/bash.exe")
;(setenv "SHELL" shell-file-name)
;(setq explicit-shell-file-name shell-file-name)

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(setq file-name-coding-system 'sjis)
(setq locale-coding-system 'utf-8)

(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)

;(recentf-mode 1)
;(setq recentf-max-menu-items 25)
;(setq recentf-max-saved-items 25)
;(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(global-set-key "\C-h" `delete-backward-char)

;(set-face-background 'show-paren-match-face "#800")
;(set-face-background 'region "#555")

(setq make-backup-files nil)

(setq completion-ignore-case t);;大文字小文字ムシ

(cond
 (window-system
  ;; フォント設定
  (set-face-attribute 'default nil :family "Cica" :height 120)
  (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Cica"))

  ;(setq w32-enable-synthesized-fonts t)
  ;; 初期フレームの設定
;  (setq initial-frame-alist
;        (append (list '(foreground-color . "white")
;                      '(background-color . "gray20")
;                      '(border-color . "gray20")
;                      '(mouse-color . "white")
;                      '(cursor-color . "white")
;                      '(height . 35)
;                      )
;                initial-frame-alist))
  (setq default-frame-alist initial-frame-alist)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
