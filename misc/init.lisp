(load "./quicklisp.lisp")

(handler-case
    (quicklisp-quickstart:install)
  (simple-error (e)
    (format t "Warning: ~s" e)))

(load (make-pathname :directory (pathname-directory (user-homedir-pathname))
		     :name "quicklisp/setup" :type "lisp"))
