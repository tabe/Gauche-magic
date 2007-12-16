;;; -*- coding: euc-jp -*-
;;;
;;; test file.magic
;;;

(use gauche.test)
(use gauche.version)

(test-start "file.magic")
(use file.magic)
(test-module 'file.magic)

(test-section "constant")
(define-syntax test*-constant
  (syntax-rules ()
	((_ (name value) ...)
	 (begin
	   (test* (symbol->string 'name) name value)
	   ...))))
(test*-constant
 (MAGIC_NONE     #x000)
 (MAGIC_DEBUG    #x001)
 (MAGIC_SYMLINK  #x002)
 (MAGIC_COMPRESS #x004)
 (MAGIC_DEVICES  #x008)
 (MAGIC_MIME     #x010)
 (MAGIC_CONTINUE #x020)
 (MAGIC_CHECK    #x040)
 (MAGIC_PRESERVE_ATIME #x080)
 (MAGIC_RAW      #x100)
 (MAGIC_ERROR    #x200)
 )

(test-section "magic set")
(define ms (magic-open 0))
(test* "magic-open" #t (is-a? ms <magic-set>))
(magic-load ms (default-magic-file))
(test* "magic-file" "ASCII C program text" (magic-file ms "file_magic.h"))
(test* "magic-file" "ASCII C program text" (magic-file ms "file_magic.c"))
(magic-close ms)

(test-section "procedures")

(call-with-magic-set
 (lambda (ms)
   (test* "call-with-magic-set(magic-file)"
		  "Lisp/Scheme program text"
		  (magic-file ms "file/magic.scm"))
   (test* "<magic-error>"
		  #t
		  (string?
           (guard (e
                   ((condition-has-type? e <magic-error>) (slot-ref e 'message))
                   (else 'unexpected))
             (magic-file ms "no_such_file"))))
   ))

(call-with-magic-set
 (lambda (ms)
   (test* "magic-check(empty)" *test-error* (magic-check ms "test/empty"))
   (test* "magic-check(trivial)" 0 (magic-check ms "test/trivial"))
   (test* "magic-compile" 0 (magic-compile ms "test/trivial")))
 :flags MAGIC_CHECK)

(let ((c #f)
      (more #f))
  (call-with-magic-set
   (lambda (ms)
     (test* "call-with-magic-set(before and after)"
            "ASCII C program text"
            (magic-file ms (call/cc (lambda (cont) (set! c cont) "file_magic.h"))))))
  (unless more
    (set! more #t)
    (c "file_magic.c")))

(test-section "errors")

(call-with-magic-set
 (lambda (ms)
   (let ((e (guard (e (else e))
			  (magic-file ms "file_magic.h"))))
	 (test* "<magic-error>" #t (condition-has-type? e <magic-error>))
	 (test* "slot message of <magic-error>" "no magic files loaded"	(condition-ref e 'message))
	 (test* "slot no of <magic-error>" 0 (condition-ref e 'no))
	 ))
 :flags MAGIC_CHECK)

(test-end)

;; Local variables:
;; mode: scheme
;; end:
