;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          climc.lisp
;;;; Purpose:       The McClim Instant Messaging client.
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; This file, part of climc, is Copyright (c) 2008 by Nicolas Lamirault
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************


(in-package :climc)


(defun launch-climc (account &optional emails)
  "Start the IM client.
`ACCOUNT' is a cons which contains username and password.
`CONTACTS' is a list of emails."
  #+nil
  (loop for port in climi::*all-ports*
     do (climi::destroy-port port))
  (setf clim:*default-text-style* (clim:make-text-style
                                   :sans-serif :roman :normal)
        *im-client* (clim:make-application-frame 'im-client
                                                 :height 400 :min-height 400
                                                 :width 250
                                                 :calls (make-hash-table :test #'equal)
                                                 :doc-title "Climc"))
  (when *debug*
    (setf *xmpp-app* (clim:make-application-frame 'xmpp-app
                                                  :height 400 :min-height 400
                                                  :width 550
                                                  :doc-title "XMPP debug")))
  (with-slots (im contacts chat) *im-client*
    (setf im (make-instance 'im
                            :username (car account)
                            :password (cdr account))
          contacts (loop for email in emails
                         collect (make-instance 'contact :email email))
          chat (sb-thread:make-thread (lambda ()
                                        (start-im im))
                                      :name "Climc-Xmpp"))
;;;     (sleep 10)
;;;     (loop for contact in contacts
;;;           do (send-presence-request im "PROBE")))
    )
  (clim:run-frame-top-level *im-client*)
  0)


(defun start-climc-app ()
  "Lunch the IM client."
  (let ((dir (get-climc-directory)))
    (load (concatenate 'string dir "climcrc"))
    (format t "Account : ~A~%Emails : ~A~%" *climc-account* *climc-account-emails*)
    (unless (and *climc-account* *climc-account-emails*)
      (error "Climc : configuration file problem."))
    (launch-climc *climc-account* *climc-account-emails*)))


(defun start-climc (&optional new-process-p)
  (if new-process-p
      (setf *im-client-process*
            (sb-thread:make-thread (lambda ()
                                     (start-climc-app))
                                   :name "Climc"))
    (start-climc-app)))


(defun stop-climc ()
  (when (and *im-client-process*
             (sb-thread:thread-alive-p *im-client-process*))
    (sb-thread:terminate-thread *im-client-process*)))



;; -----
;; GUI
;; ----

(clim:make-command-table 'main-menu
                         :errorp nil
                         :menu '(;;("About" :command com-about)
                                 ("Add contact" :command com-add-contact)
                                 ("Quit" :command com-quit)))


(clim:define-application-frame im-client
    (clim:standard-application-frame redisplay-frame-mixin)
  ((im :initform nil
       :initarg :im
       :accessor im-of)
   (presence :initform (first *XMPP-PRESENCES*)
             :initarg :presence
             :accessor presence-of)
   (chat :initform nil
         :initarg :chat
         :accessor chat-of)
   (contacts :initform '()
             :initarg :contacts
             :accessor contacts-of
             :documentation "The available contacts.")
   (calls :initform nil
          :initarg :calls
          :accessor calls-of))
  (:menu-bar (("Climc" :menu main-menu)))
  (:panes
   (contacts-pane :application
                  :min-width 100
                  :max-width 250
                  :min-height 100
                  :max-height 400
                  :incremental-redisplay t
                  :display-function #'display-contacts)
   (presence-pane
    (clim:make-pane 'clim:option-pane
                    :width 70 :min-width 70
                    :min-height 100 :max-height 100
                    :items *XMPP-PRESENCES*
                    :value (first *XMPP-PRESENCES*)
               :value-changed-callback (lambda (gadget value)
                                         (update-xmpp-presence *im-client* value))))
   (xmpp-pane :application
              :min-width 100
              :max-width 250
              :min-height 100
              :max-height 400
              :incremental-redisplay t))
  ;;(:geometry :width 250 :height 400)
  (:layouts
   (default
    (clim:vertically (:equalize-width t :equalize-height nil
                      :height 200 :width 100)
      contacts-pane presence-pane))))


(defmethod clim:frame-exit :before ((im-client im-client))
  (with-slots (im chat) im-client
    (stop-im im)
    (when (and chat
               (sb-thread:thread-alive-p chat))
      (sb-thread:terminate-thread chat))))


;; --------------
;; Presentations
;; --------------

(clim:define-presentation-type contact ())

(clim:define-presentation-method clim:present (contact (type contact) stream view
                                                       &key args)
  (declare (ignore view))
  (format stream "~A [~A]~%" (email-of contact) (status-of contact)))

;; --------
;; Display 
;; --------


(defgeneric display-contacts (frame stream)
  (:documentation "Display account contacts."))


(defmethod display-contacts ((frame im-client) stream)
  (loop for contact in (contacts-of frame)
     do (clim:updating-output (stream :unique-id contact))
        (clim:present contact 'contact :stream stream))
  (terpri stream))


;; -----
;; XMPP
;; -----


(defun get-email-message (message)
  (let ((tokens (cl-ppcre:split "/" (xmpp:from message))))
    (if (> (length tokens) 0)
      (first tokens)
      (xmpp:from message))))


(defgeneric xmpp-receive-message (client message)
  (:documentation "Handler for reception of a XMPP message."))


(defmethod xmpp-receive-message ((im-client im-client) message)
  (let* ((email (get-email-message message))
         (chat (gethash email (calls-of im-client))))
    (when chat
      (let ((pane (clim:get-frame-pane chat 'chat-pane)))
        (clim:with-drawing-options (pane :ink (clim:make-rgb-color 0.0 0.0 0.5))
          (clim:with-text-family (pane :sans-serif)
            (write-string (format nil "~A ~A: ~A"
                                  (iso-time)
                                  email
                                  (xmpp:body message))
                          pane)))
        (terpri pane))))
  (when *debug*
    ;;(display-xmpp-message message)))
    (let (text)
      (with-output-to-string (os)
        (print-object message os)
        (format os "body: ~A" (xmpp:body message))
        (setf text (get-output-stream-string os)))
      (display-xmpp-message text))))
;;;     (send-message (im-of im-client)
;;;                   (xmpp:from message)
;;;                   (format nil "~a: ~a"
;;;                           email
;;;                           (xmpp:body message)))))


(defgeneric xmpp-receive-presence (im-client presence)
  (:documentation "Handler when the IM client receive a XMPP presence request."))


(defmethod xmpp-receive-presence ((im-client im-client) presence)
;;;   (let ((email (get-email-message presence))
;;;         (contact (find email (contacts-of im-client)
;;;                        :test #'string-equal
;;;                        :key #'email-of)))
;;;     (when contact
;;;       (setf (status-of contact) (xmpp:
  (when *debug*
    (let (text)
      (with-output-to-string (os)
        (print-object presence os)
        (setf text (get-output-stream-string os)))
      (display-xmpp-message text))))


(defgeneric update-xmpp-presence (im-client updated-presence)
  (:documentation "Send a XMPP request to update presence."))


(defmethod update-xmpp-presence ((im-client im-client) updated-presence)
  (with-slots (im presence) im-client
    (setf presence updated-presence)
    (send-presence-request im presence)))
