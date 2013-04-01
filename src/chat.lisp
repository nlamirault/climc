;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          chat.lisp
;;;; Purpose:       Chat for the IM client.
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************



(in-package :climc)

;;(declaim (optimize (debug 3)))


(defun close-chat-callback (button)
  "Callback to close the chat box."
  (let* ((chat-frame (clim:gadget-client button))
;;;          (chat (gethash (email-of (contact-of chat-frame))
;;;                         (calls-of *im-client*))))
         )
    (stop-im (im-of *im-client*))
;;;     (when (and chat 
;;;                (sb-thread:thread-alive-p chat)) (car chat)))
;;;       (sb-thread:terminate-thread c(car chat)))
    (remhash (email-of (contact-of chat-frame))
             (calls-of *im-client*))
    (close-box-callback button)))


(defun input-message-callback (gadget)
  "Callback invoked by the text input gadget when the user hits enter"
  (let ((chat-frame (clim:gadget-client gadget)))
    (when (contact-of chat-frame)
      (send-message (im-of *im-client*) 
                    (email-of (contact-of chat-frame))
                    (clim:gadget-value gadget))
      (let ((pane (clim:get-frame-pane chat-frame 'chat-pane)))
        (clim:with-text-family (pane :sans-serif)
          (write-string (format nil "~A ~A"
                                (iso-time)
                                (clim:gadget-value gadget))
                        pane))
        (terpri pane)
        (setf (clim:gadget-value gadget) "")))))


(clim:define-application-frame chat (clim:standard-application-frame
                                     redisplay-frame-mixin)
  ((contact :initform nil
            :initarg :contact
            :accessor contact-of))
  (:panes
   (chat-pane :application
              :min-width 500
              :min-height 200
              :incremental-redisplay t
              :display-function #'display-chat)
   (message-text-field :text-field
                       :value ""
                       :min-width 500
                       :activate-callback 'input-message-callback)
   (ok-bt (make-button "Quit" 'close-chat-callback)))
  ;;(:geometry :width 400 :height 300)
  (:layouts
   (default
       (clim:vertically ()
         chat-pane
         (clim:labelling (:label "Message")
           message-text-field)
         ok-bt))))


(defmethod display-chat ((frame chat) stream)
  (declare (ignore frame))
  )


(defmethod display-message ((frame chat) stream)
  (declare (ignore frame))
  )
