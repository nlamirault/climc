;;;; Name:          climc.asd
;;;; Purpose:       ASDF definition for Climc unit tests
;;;; Programmer:    Nicolas Lamirault <nicolas.lamirault@gmail.com>
;;;;
;;;; This file, part of climc, is Copyright (c) 2013 by Nicolas Lamirault
;;;;
;;;; climc users are granted the rights to distribute and use this software
;;;; as governed by the terms of the MIT License :
;;;; http://www.opensource.org/licenses/mit-license.php
;;;;
;;;; *************************************************************************

(asdf:defsystem #:climc-test
  :serial t
  :description "Climc unit tests"
  :author "Nicolas Lamirault <nicolas.lamirault@gmail.com>"
  :license "MIT"
  :depends-on (#:climc
	       #:lisp-unit)
  :components
  ((:module :test
	    :components ((:file "package")))))
