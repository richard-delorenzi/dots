(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(global-visual-line-mode t)
 '(save-place t nil (saveplace))
 '(server-mode t)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(visual-line-fringe-indicators (quote (left-curly-arrow right-curly-arrow))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (background light)) (:foreground "Firebrick"))))
 '(font-lock-constant-face ((((class color) (background light)) (:foreground "CadetBlue" :slant italic))))
 '(font-lock-keyword-face ((t (:foreground "Purple" :weight bold))))
 '(font-lock-string-face ((t (:foreground "red" :slant italic))))
 '(font-lock-type-face ((t (:foreground "ForestGreen"))))
 '(font-lock-warning-face ((t (:foreground "Red" :weight bold)))))

;;where to find some packages
(let ((default-directory "~/.emacs.d/site-lisp/"))
      (normal-top-level-add-to-load-path '("."))
      (normal-top-level-add-subdirs-to-load-path))

;;server
(server-start)

;;; -----------------------------------------------------------------------
;;; Misc 

;;; Spelling
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checking" t)
(autoload 'global-flyspell-mode "flyspell" "On-the-fly spelling" t)

(dolist (hook '(text-mode-hook))
      (add-hook hook (lambda () (flyspell-mode 1))))
;(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
;      (add-hook hook (lambda () (flyspell-mode -1))))

;(add-hook 'c++-mode-hook
;          (lambda ()
;            (flyspell-prog-mode)
;            ; ...
;          ))


;;;GOTO line
(global-set-key [(meta g)] 'goto-line)

;;upcase 
(put 'upcase-region   'disabled nil)
(put 'downcase-region 'disabled nil)

;; When you scroll down with the cursor, emacs will move down the buffer one 
;; line at a time, instead of in larger amounts.
(setq scroll-step 1)

;; Titlebar - show more info in taskbar/icon than just "Emacs"
(setq-default frame-title-format (list "%b  -  %f"))
(setq-default icon-title-format (list "%b"))

;;make the y or n suffice for a yes or no question
(fset 'yes-or-no-p 'y-or-n-p)

;; don't automatically add new lines when scrolling down at the bottom
;; of a buffer 
(setq next-line-add-newlines nil)

;;archive files
(require 'jka-compr)
(jka-compr-install)

;;undo redo
;(require 'redo)
;(require 'undo-tree)
;(global-undo-tree-mode)
(require 'redo+)
(global-set-key [(control \?)] 'redo)
;(global-set-key (kbd "C-?") 'redo)

;;backups
(setq make-backup-files t)
(setq version-control t)
(setq kept-old-versions 1)
(setq kept-new-versions 2)
(setq delete-old-versions t)
;(require 'backup-dir) ;package missing
;(setq bkup-backup-directory-info '(( t "~/.autosave" ok-create full-path )))

;;bookmarks
(setq bookmark-save-flag 1)

;;templates
;(require 'template) ;package missing
;(template-initialize)

;;Macros - (pfe calls these templates)
;(require 'kbd-macro-definitions) ;package missing

;;;Set font - need to hook into open frame thing 
;(defun MyNiceFontThisFrame ( ) "function to set a readable font"
;  (set-default-font "-outline-Lucida Console-normal-r-normal-normal-13-97-96-96-c-*-iso10646-1")
;)
;(defun MyNiceFont ( frame ) "function to set a readable font"
;  (select-frame frame)
;  (MyNiceFontThisFrame)
;)
;(MyNiceFontThisFrame)
;(add-hook 'after-make-frame-functions 'MyNiceFont)

;; ----------------------------------------------------------------------
;; Programmer stuf

;;compile
(global-set-key [(pause)] 'compile)

;; search
(setq search-highlight t)
(setq query-replace-highlight t)
(setq search-whitespace-regexp "[ \t\r\n]+")

;;;syntax hilite
(global-font-lock-mode 1)
(setq font-lock-maximum-decoration t)


;;;show paren, brace, and curly brace "partners" at all times
;(setq show-paren-style 'parentheses)
(setq blink-matching-paren t)
(show-paren-mode t)

;;hideshow mode
(add-hook 'c-mode-hook          'hs-minor-mode 1)
(add-hook 'c++-mode-hook        'hs-minor-mode 1)
(add-hook 'perl-mode-hook       'hs-minor-mode 1)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode 1)

;; C style
(defconst my-c-style
  '((c-basic-offset             . 4 )
    (c-tab-always-indent        . t)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist     . ((substatement-open after)
				   (brace-list-open)))
    (c-hanging-colons-alist     . ((member-init-intro before)
				   (inher-intro)
				   (case-label after)
				   (label after)
				   (access-label after)))
    (c-cleanup-list             . (scope-operator
				   empty-defun-braces
				   defun-close-semi))
    (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
								   (substatement-open . 0)
				   (case-label        . +)
				   (block-open        . 0)
				   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t)
  )
  "My C Programming Style"
)

;; Customizations for all modes in CC Mode.
(defun my-c-mode-common-hook ()

  ;; add my personal style and set it for the current buffer
  (c-add-style "PERSONAL" my-c-style t)

  ;;colouring
  (font-lock-mode t)

  ;; offset customizations not in my-c-style
  (c-set-offset 'member-init-intro '++)
  (c-set-offset 'label '+)
  (c-set-offset 'inline-open '0)
  (c-set-offset 'block-open '0)

  ;; other customizations
  (setq tab-width 4
		;; this will make sure spaces are used instead of tabs
		indent-tabs-mode nil)
  
  ;; keybindings for all supported languages.  We can put these in
  ;; c-mode-base-map because c-mode-map, c++-mode-map, objc-mode-map,
  ;; java-mode-map, idl-mode-map, and pike-mode-map inherit from it.
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map [\S-spc] "_")
  ;(function-menu 'USE-MENUBAR)
)
     
(add-hook 'c-mode-common-hook   'my-c-mode-common-hook)
(add-hook 'c++-mode-common-hook 'my-c-mode-common-hook)

;; =================================================================
;; - EIFFEL
;; =================================================================
;(setq auto-mode-alist (cons '("\\.e$" . eiffel-mode) auto-mode-alist))
;(autoload 'eiffel-mode "eiffel3" "Mode for Eiffel programs" t) 
(add-to-list 'auto-mode-alist '("\\.e\\'" . eiffel-mode))
(autoload 'eiffel-mode "eiffel-mode" "Major mode for Eiffel programs" t)

;; =================================================================
;; - Visual Basic - yuck
;; =================================================================

(autoload 'visual-basic-mode "visual-basic" "Visual-Basic" t)
(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|cls\\)$" . 
				 visual-basic-mode)) auto-mode-alist))

;; =================================================================
;; - json
;; =================================================================

(add-to-list 'auto-mode-alist '("\\.json\\'" . 
				 javascript-mode))



;; =================================================================
;; Version Control Systems
;; =================================================================

;;- PVCS Support. Get me to work, if you can!!!
;;PVCS. You will need pvcs.el.
; (require 'pvcs)
; (setq vc-default-back-end (quote RCS))
; (setq vc-consult-headers nil)
; (setq vc-mistrust-permissions t)
; (load-library "easymenu")
; (load-library "pvcs")
; (pvcs-mode t)

;;subversion support
(require 'psvn)

;; =================================================================

;;fontlock with types
(defun my-ctypes-load-hook ()
  (ctypes-read-file "~/.ctypes_std_c" nil t t))
(add-hook 'ctypes-load-hook 'my-ctypes-load-hook)
;(require 'ctypes) ;package missing
;(ctypes-auto-parse-mode 1)

;;;reindent
(defun indent-buffer () "reindent whole buffer" 
  (interactive)
  (point-to-register 'a)
  (mark-whole-buffer)
  (call-interactively 'untabify)
  (call-interactively 'indent-region)
  (register-to-point 'a)
)

;; ----------------------------------------------------------------------
;; Window managment

(defun split-window-fork ()
  (concat
   "spawns a new frame so that a 2-way split window in one frame becomes "
   "2 top-level frames.  Has the same action as ")
  (interactive)
  (progn
    (let ((current_window (selected-window))
	  (other_window (next-window (selected-window)))
	  (current_buffer (window-buffer (selected-window)))
	  (other_buffer (window-buffer (next-window (selected-window)))))
      (make-frame)
      (select-window other_window)
      (delete-other-windows))))

;; ----------------------------------------------------------------------
;; MS Window stuf

;;open file popup
(load-library "menu-bar")

;;;convert a buffer from dos ^M end of lines to unix end of lines
(defun dos2unix ()
  (interactive)
    (goto-char (point-min))
      (while (search-forward "\r" nil t) (replace-match "")))
;;;vice versa
(defun unix2dos ()
  (interactive)
    (goto-char (point-min))
      (while (search-forward "\n" nil t) (replace-match "\r\n")))

;;begin buffer-switching methods, which I bind to Ctrl-TAB and Ctrl-Shift-TAB
;; ----------------------------------------------------------------------
;;     Original yic-buffer.el
;;     From: choo@cs.yale.edu (young-il choo)
;;     Date: 7 Aug 90 23:39:19 GMT
;;
;;     Modified 
;; ----------------------------------------------------------------------

(defun yic-ignore (str)
  "return true if str matches a buffer name we want to skip"
  (or
   ;;buffers I don't want to switch to 
   (string-match "\\*Buffer List\\*" str)
   (string-match "^TAGS" str)
   (string-match "^\\*Messages\\*$" str)
   (string-match "^\\*Completions\\*$" str)
   (string-match "^ " str)
   ))

(defun yic-next (list)
  "Switch to next buffer in list skipping unwanted ones."
  (let* 
    ( (ptr list) buffer buffername go )
    (while (and ptr (null go))
      (setq buffer (car ptr)  buffername (buffer-name buffer))
      (if (null (yic-ignore buffername))	;skip over
	  (setq go buffer)
	  (setq ptr (cdr ptr))
	)
      )
    (if go
	(switch-to-buffer go))))

(defun yic-prev-buffer ()
  "Switch to previous buffer in current window."
  (interactive)
  (yic-next (reverse (buffer-list))))

(defun yic-next-buffer ()
  "Switch to the other buffer (2nd in list-buffer) in current window."
  (interactive)
  (bury-buffer (current-buffer))
  (yic-next (buffer-list)))
;;end of yic buffer-switching methods

;;; Switch buffers
(global-set-key [\C-tab] 'yic-next-buffer)
(global-set-key [\C-\S-tab] 'yic-prev-buffer) 

;;; Navigate buffer
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [\C-home] 'beginning-of-buffer)
(global-set-key [\C-end] 'end-of-buffer)

;;;edit
(global-set-key [\C-backspace] 'backward-kill-word)
(global-set-key [\S-tab] 'indent-region)

;;; cut and paste
;;(global-set-key [\C-\S-insert] (lambda () (interactive) (yank-pop -1) ) )  ;;paste loop backwards

;;;misc
(global-set-key [\C-x\C-c] 'intelligent-close)

(global-set-key [f2] "text" )


;;--------------------------------------------------------------------------------------
;;Cool functions - to bind to keys

;;This method, when bound to C-x C-c, allows you to close an emacs frame the 
;;same way, whether it's the sole window you have open, or whether it's
;;a "child" frame of a "parent" frame.  If you're like me, and use emacs in
;;a windowing environment, you probably have lots of frames open at any given
;;time.  Well, it's a pain to remember to do Ctrl-x 5 0 to dispose of a child
;;frame, and to remember to do C-x C-x to close the main frame (and if you're
;;not careful, doing so will take all the child frames away with it).  This
;;is my solution to that: an intelligent close-frame operation that works in 
;;all cases (even in an emacs -nw session).
(defun intelligent-close ()
  "quit a frame the same way no matter what kind of frame you are on"
  (interactive)
  (if (eq (car (visible-frame-list)) (selected-frame))
      ;;for parent/master frame...
      (if (> (length (visible-frame-list)) 1)
		  ;;close a parent with children present
		  (delete-frame (selected-frame))
		;;close a parent with no children present
		(save-buffers-kill-emacs))
    ;;close a child frame
    (delete-frame (selected-frame))))

;;a no-op function to bind to if you want to set a keystroke to null
(defun void ()
  "this is a no-op"
  (interactive))

;;--------------------------------------------------------------------------------------
;;useful or not functions
(defun ascii-table ()
  "Print the ascii table. Based on a defun by Alex Schroeder <asc@bsiag.com>"
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 254))
  (let ((i 0))
    (while (< i 254)
      (setq i (+ i 1))
      (insert (format "%4d %c\n" i i))))
  (beginning-of-buffer))

;;insert date into buffer
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%a %b %e, %Y %l:%M %p")))

;;;Windows fonts
;(if (or (eq window-system 'w32) (eq window-system 'win32)) ;Windows NT/95
;	(defun insert-x-style-font()
;	  "Insert a string in the X format which describes a font the user can select from the windows font selector."
;	  (interactive)
;	  (insert (prin1-to-string (w32-select-font)))
;))




;;dont close
(global-set-key "\C-x\C-c" 'void)

;;
;(fset 'kbd-macro-std-constructors
;   [?\C-  ?\C-e ?\C-w ?p ?r ?i ?v ?a ?t ?e ?: ?  ?/ ?/ ?d ?i ?s ?a ?b ?l ?e ?  ?c ?o ?p ?y ?, ?c ?o ?n ?s ?t ?r ?u ?c ?t ?o ?r ?, ?  left left left left left left left left left left left left left left right backspace ?  right right right right right right right right right right right right right ?a ?s ?s ?i ?g ?n ?m ?e ?n ?t ?  ?o ?p ?e ?r ?a ?t ?o ?r return ?\C-y ?( ?c ?o ?n ?s ?t ?  ?\C-y ?& ?  ?p ?_ ?o ?t ?h ?e ?r ?) ?\; return ?\C-y ?& ?  ?o ?p ?e ?r ?a ?t ?o ?r ?= ?( ?c ?o ?n ?s ?t ?  ?\C-y ?& ?  ?p ?_ ?o ?t ?h ?e ?r ?) ?\; return ?p ?u ?b ?l ?i ?c ?: ?  ?/ ?/ ?d ?e ?s ?t ?r ?u ?c ?t ?o ?t backspace ?r return ?v ?i ?r ?t ?u ?a ?l ?  ?| ?\C-y ?\C-/ backspace ?| backspace ?| backspace ?| backspace ?\\ backspace ?\\ backspace ?@ backspace ?! backspace ?# backspace ?~ ?\C-y ?( ?) return ?{ ?}])


;;search
(setq grep-find-command "find . -type f \\( -iname '*.cpp' -o -iname '*.h' \\) -print0 | xargs -0 -e grep -i -n -E ")

;;python
    ;(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
    ;(setq interpreter-mode-alist (cons '("python" . python-mode);
;                                       interpreter-mode-alist))
    ;(autoload 'python-mode "python-mode" "Python editing mode." t)


;;python Maybe
;(setq ipython-command "C:\\Python24\\python c:\\Python24\\Scripts\\ipython")
;(require 'ipython) 

(add-to-list 'load-path "~/.emacs.d/vendor/mustache-mode.el")
(require 'mustache-mode)





