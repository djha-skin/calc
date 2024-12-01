;;;; calculator.lisp -- A CLI calculator.
;;;;
;;;; SPDX-FileCopyrightText: 2024 Daniel Jay Haskin
;;;; SPDX-License-Identifier: MIT
;;;;
;;;;

(in-package #:cl-user)

(defpackage
  #:com.djhaskin.calc (:use #:cl)
  (:documentation
    "
    A CLI calculator.
    ")
  (:import-from #:com.djhaskin.cliff)
  (:local-nicknames
    (#:cliff #:com.djhaskin.cliff))
  (:export #:main))

(in-package #:com.djhaskin.calc)

(defparameter operators
    `(("+" . ,#'+)
      ("-" . ,#'-)
      ("*" . ,#'*)
      ("/" . ,#'/)
      ("&" . ,#'logand)
      ("%" . ,(lambda (&rest args)
                (multiple-value-bind
                    (quotient remainder)
                    (apply #'truncate args)
                  remainder)))))

(defun programmer-and (options)
  (setf (gethash :operator options) "&")
  (calc options))

(defun modulus (options)
  (setf (gethash :operator options) "%")
  (calc options))

(defun calc (options)
  (let* ((result (make-hash-table :test #'equal))
         (operands (cliff:ensure-option-exists :operands))
         (operator (cliff:ensure-option-exists :operator))
         (func (cdr (assoc operator operators :test #'equal)))
         (out (apply func operands)))
    (setf (gethash :result result) out)
    (setf (gethash :status result) :successful)
    result))

(defun main (argv)
  (cliff:execute-program
    "calc"
    :subcommand-functions
    `((("programmer" "and") . ,#'programmer-and)
      (("modulus") . ,#'modulus))
    :subcommand-helps
    `((("programmer" "and") . "Sets the operator to `&`")
      (("modulus") . "Sets the operator to `%`"))
    :default-function #'calc
    :default-func-help
    (format
      nil
      "~@{~@?~}"
      "Welcome to calc.~%"
      "~%"
      "This is a calculator CLI.~%"
      "~%"
      "The default action expects these options:~%"
      "  operand           Specify operand~%"
      "                    (may be specified multiple times)~%"
      "  operator (string) Specify operator~%")
    :cli-arguments argv
    :defaults '((:operator "+"))
    :cli-aliases
    '(("-h" . "help")
      ("--help" . "help")
      ("-o" . "--add-operands"))
    :setup
    (lambda (options)
      (let ((operands (gethash :operands options)))
        (setf (gethash :operands options)
              (map 'list #'parse-integer operands))
        options))
    :suppress-final-output t))

