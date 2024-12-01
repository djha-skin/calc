(defsystem "com.djhaskin.calc"
  :version "0.8.0"
  :author "Daniel Jay Haskin"
  :license "MIT"
  :depends-on ("com.djhaskin.cliff"
               "com.djhaskin.nrdl"
               "alexandria")
  :components ((:module "src"
                :components
                ((:file "calculator"))))
  :description "CLI calculator, a demonstration project for Common Lisp CLIFF")
