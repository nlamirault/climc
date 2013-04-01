;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          delivery.lisp
;;;; Purpose:       Make executable.
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; This file, part of climc, is Copyright (c) 2008 by Nicolas Lamirault
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************

(in-package :cl-user)


(require 'climc)


(defparameter *target-directory* "/tmp/")


(defun make-climc-executable ()
  "Creates an executable of Climc."
  (sb-ext:save-lisp-and-die
   (merge-pathnames "climc" *target-directory*)
   :executable t
   :toplevel (lambda ()
               (climc:start-climc)
               (sb-ext:quit :unix-status 0))))

