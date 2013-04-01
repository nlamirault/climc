;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          commands.lisp
;;;; Purpose:       McClim commands for the IM client.
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************



(in-package :climc)


;; -----
;; Menu
;; -----

                     
(define-im-client-command (com-quit :name t :menu nil :keystroke (#\q :control))
    ()
   (clim:frame-exit *im-client*))


(define-im-client-command (com-xmpp-debug :name t :menu nil :keystroke (#\x :control))
    ()
   (when *xmpp-app*
     (sb-thread:make-thread (lambda ()
                              (clim:run-frame-top-level *xmpp-app*))
                            :name "Climc Xmpp Debug")))


(define-im-client-command (com-add-contact :name t :menu nil :keystroke (#\a :control))
    ()
   (clim:frame-exit *im-client*))

;; ----------
;; Selection
;; ----------


(define-im-client-command com-select-contact
    ((contact 'contact :gesture :select))
  (let ((frame
         (clim:make-application-frame 'chat
                                      :height 200
                                      :width 600
                                      :calling-frame *im-client*
                                      :contact contact
                                      :doc-title (format nil "Chat with ~A"
                                                         (email-of contact)))))
    (setf (gethash (email-of contact) (calls-of *im-client*))
          frame)
    (clim:run-frame-top-level frame)))

