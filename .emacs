;; global config
(show-paren-mode)
(column-number-mode)
(menu-bar-mode -1)
(delete-selection-mode 1)
(setq-default indent-tabs-mode nil)
(setq backup-directory-alist '(("." . "~/.backups")))
(recentf-mode)
(ido-mode)

;; my own varibles and keys
(setq org-tags-column 52)
; show recent files when switching buffers 
; [http://wikemacs.org/index.php/Ido#Virtual_Buffers]
(setq ido-use-virtual-buffers t)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files '("~/org/"))

;; my own functions(advices)
(defadvice kill-ring-save (before line-copy activate compile)
  "When called interactively with no active region, copy the current line."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
       (list (line-beginning-position) (line-end-position)))))

;; load el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/abyssly/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq el-get-sources
      '(
        (:name magit
               :after (global-set-key (kbd "C-x C-z") 'magit-status))

        (:name undo-tree
               :after (global-undo-tree-mode))

        (:name jedi
               :after (progn
                        (add-hook 'python-mode-hook 'jedi:setup)
                        (setq jedi:setup-keys t)
                        (setq jedi:complete-on-dot t)))

        (:name smex
               :after (progn
                        (global-set-key (kbd "M-x") 'smex)
                        (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

        (:name google-translate
               :after (progn
                        (setq google-translate-default-source-language "en")
                        (setq google-translate-default-target-language "zh-CN")))
        ))

(setq my-packages (append '(el-get markdown-mode)
                          (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync my-packages)
