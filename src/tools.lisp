;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-

;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          tools.lisp
;;;; Purpose:       Some McClim tools
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



;; Hack based on iso-time from Hunchentoot
(defun iso-time (&optional (time (get-universal-time)))
  "Returns the universal time TIME as a string in full ISO format."
  (multiple-value-bind (second minute hour date month year)
      (decode-universal-time time)
    (declare (ignore year month date))
    (format nil "~2,'0d:~2,'0d:~2,'0d"
            hour minute second)))


;; -----------------------------------------------------------------
;; Hack for scroll pane and formatting table
;; From : common-lisp.net/~rtoy/maxima-repl-2005-07-02.lisp

(defclass redisplay-frame-mixin ()
  ())

(defmethod clim:redisplay-frame-pane :after
    ((frame redisplay-frame-mixin) (pane clim:application-pane) &key force-p)
  (declare (ignore force-p))
  (clim:change-space-requirements
   pane
   :height (clim:bounding-rectangle-height (clim:stream-output-history pane))))

;; Hack end
;; -----------------------------------------------------------------



(defun redisplay-callback (app pane)
  "Force `APP' to redisplay the specified `PANE'."
  (clim:redisplay-frame-pane app
                             (clim:get-frame-pane app pane)
                             :force-p t))


(defun make-button (label callback &key width height
                    (max-width clim:+fill+) min-width
                    (max-height clim:+fill+) min-height)
  "Creates a new button."
  (clim:make-pane 'clim:push-button
                  :label label
                  :activate-callback callback
                  :width width :height height
                  :max-width  max-width :min-width min-width
                  :max-height max-height :min-height min-height))


(defun close-box-callback (button)
  "Callback to close dialog box."
  (finish-output *error-output*)
  (clim:frame-exit (clim:gadget-client button)))



(defun get-climc-directory ()
  "Get the home directory of Climc."
  (let ((directory (concatenate 'string
                                (sb-ext:posix-getenv "HOME")
                                "/.config/")))
    (ensure-directories-exist directory)))
