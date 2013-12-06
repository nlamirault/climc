;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          climc.asd
;;;; Purpose:       ASDF definition for Climc
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; This file, part of climc, is Copyright (c) 2008 by Nicolas Lamirault
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************


(in-package :asdf)


(defsystem climc
  :name "climc"
  :author "Nicolas Lamirault <nicolas.lamirault@gmail.com>"
  :maintainer "Nicolas Lamirault <nicolas.lamirault@gmail.com>"
  :version "0.1"
  :licence "MIT License"
  :description "A common lisp Instant Messaging client."
  :depends-on (:mcclim
               :cl-xmpp-tls
               :cl-ppcre)
  :components
  ((:module :src
            :components
            ((:file "package")
             (:file "specials" :depends-on ("package"))
             (:file "tools" :depends-on ("package"))
             (:file "im" :depends-on ("specials"))
             (:file "dao" :depends-on ("package"))
             (:file "chat" :depends-on ("specials"))
             (:file "xmpp" :depends-on ("specials"))
             (:file "climc" :depends-on ("xmpp" "tools" "dao" "chat"))
             (:file "commands" :depends-on ("climc"))
             ))))

