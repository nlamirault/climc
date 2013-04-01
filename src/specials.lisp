;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          specials.lisp
;;;; Purpose:       Climc general informations.
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


(defparameter *im-client* nil)

(defparameter *im-client-process* nil)

(defparameter *xmpp-app* nil)

(defparameter *climc-account* nil)

(defparameter *climc-account-emails* nil)


(defparameter *XMPP-PRESENCES* '(AWAY CHAT DND XA))


;; Dev

(defparameter *debug* nil "If T, active some logs.")

