(defpackage :ceramic-hello-world/app
  (:use :cl
        :lucerne)
  (:import-from :djula)
  (:import-from :ceramic)
  (:export :run
           :build))
(in-package :ceramic-hello-world/app)

(annot:enable-annot-syntax)

;; App Resources

(ceramic:define-resources :ceramic-hello-world ()
  (assets #P"static/")
  (templates #p"templates/"))

;; Define an application
(defapp app
    :middlewares ((clack.middleware.static:<clack-middleware-static>
                   :root (ceramic:resource-directory 'assets)
                   :path "/static/")))

;; Djula Config

(djula:add-template-directory (asdf:system-relative-pathname :ceramic-hello-world "templates/"))
(defparameter *base.html*  (djula:compile-template* "base.html"))
(defparameter *index.html* (djula:compile-template* "index.html"))

;; Route requests to "/" to this function
@route app "/"
(defview hello ()
  (respond (djula:render-template* *index.html*)))

;; Ceramic Run

(defvar *window* nil)
(defvar *port* 8000)

(defun run ()
  (ceramic:start)
  (setf *window* (ceramic:make-window :url (format nil "http://localhost:~D" *port*)))
  (ceramic:show *window*)
  (start app :port *port*))

;; Ceramic Build

(defvar *build-path* (asdf:system-relative-pathname :ceramic-hello-world "build/"))

(defun build ()
  (ceramic:bundle :ceramic-hello-world :bundle-pathname (format nil "~Aapp.tar" *build-path*)))

;; Entry Point

(ceramic:define-entry-point :ceramic-hello-world ()
  (run))
