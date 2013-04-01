
;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          xmpp.lisp
;;;; Purpose:       A pane for the XMPP messages.
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************



(in-package :climc)



(clim:define-application-frame xmpp-app (clim:standard-application-frame
                                         redisplay-frame-mixin)
  ()
  (:panes
   (xmpp-pane :application
              :min-width 500
              :min-height 200
              :incremental-redisplay t)
   (ok-bt (make-button "Ok" 'close-box-callback)))
  (:layouts
   (default
       (clim:vertically (:equalize-width nil :equalize-height nil
                         :width 500 :height 200)
         xmpp-pane ok-bt))))


(defun display-xmpp-message (text)
  (let ((pane (clim:get-frame-pane *xmpp-app* 'xmpp-pane)))
    (clim:with-text-family (pane :sans-serif)
;;;       (let (msg)
;;;         (with-output-to-string (os)
;;;           (print-object message os)
;;;           (setf msg (get-output-stream-string os)))
;;;         (write-string msg pane)))
      (write-string text pane)
      (terpri pane))))
      
      