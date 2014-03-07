;;
;; Continuous integration: launch unit tests
;;

(in-package :cl-user)

(load ".clenv/.quicklisp/setup.lisp")

(ql:quickload "climc")
(ql:quickload "climc-test")

(setq lisp-unit:*print-failures* t)
(setq lisp-unit:*print-errors* t)
(setq lisp-unit:*print-summary* t)

(lisp-unit:run-tests :all :climc-test)
