;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          im.lisp
;;;; Purpose:       The IM client.
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************



(in-package :climc)


;; (defmethod xmpp:handle ((connection xmpp:connection) (message xmpp:message))
;;   (xmpp:message connection (xmpp:from message) 
;;                 (format nil "You say : ~a" (xmpp:body message))))




(defmethod xmpp:handle ((connection xmpp:connection) (message xmpp:message))
  (when *im-client*
    (xmpp-receive-message *im-client* message)))


(defmethod xmpp:handle ((connection xmpp:connection) (presence xmpp:presence))
  (when *im-client*
    (xmpp-receive-presence *im-client* presence)))


(defclass im ()
  ((connection :initform nil
               :initarg :connection
               :accessor connection-of)
   (username :initform nil
             :initarg :username
             :accessor username-of)
   (password :initform nil
             :initarg :password
             :accessor password-of)))


(defun make-im (username password)
  (make-instance 'im
                 :username username :password password))


(defgeneric start-im (im)
  (:documentation "Start the `IM' client."))


(defmethod start-im ((im im))
  (with-slots (connection username password) im
    (setf connection
        (xmpp:connect-tls :hostname "talk.google.com"
                          :jid-domain-part "gmail.com"))
    (xmpp:auth connection username password "resource" :mechanism :sasl-plain)
    (xmpp:receive-stanza-loop connection)))


(defgeneric stop-im (im)
  (:documentation "Stop the `IM'."))


(defmethod stop-im ((im im))
  (xmpp:disconnect (connection-of im)))



(defgeneric send-message (im to text)
  (:documentation "Send a message `TEXT' to a contact `TO'."))


(defmethod send-message ((im im) to text)
  (xmpp:message (connection-of im) to text))



(defgeneric send-presence-request (im presence)
  (:documentation "Send a XMPP request with `PRESENCE' information."))


(defmethod send-presence-request ((im im) presence)
  (xmpp:presence (connection-of im) :status presence))

