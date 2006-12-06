;;;
;;;  magic.scm
;;;
;;;   Copyright (c) 2006 Takeshi Abe. All rights reserved.
;;;
;;;   Redistribution and use in source and binary forms, with or without
;;;   modification, are permitted provided that the following conditions
;;;   are met:
;;;
;;;    1. Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;
;;;    2. Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;
;;;    3. Neither the name of the authors nor the names of its contributors
;;;       may be used to endorse or promote products derived from this
;;;       software without specific prior written permission.
;;;
;;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;;   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;;   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;;   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;;;   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;;   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
;;;   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;;   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;;   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;  
;;;  $Id$

(define-module file.magic
  (use gauche.parameter)
  (export <magic-set>
		  <magic-error>
		  MAGIC_NONE
		  MAGIC_DEBUG
		  MAGIC_SYMLINK
		  MAGIC_COMPRESS
		  MAGIC_DEVICES
		  MAGIC_MIME
		  MAGIC_CONTINUE
		  MAGIC_CHECK
		  MAGIC_PRESERVE_ATIME
		  MAGIC_RAW
		  MAGIC_ERROR
		  magic-open magic-close
		  magic-load magic-check magic-compile
		  magic-file
		  default-magic-file call-with-magic-set
		  ))
(select-module file.magic)

(dynamic-load "file_magic")

(define-condition-type <magic-error> <error> #f
  ((no :init-keyword :no)))

(define default-magic-file (make-parameter (%default-magic-file%)))

(define (call-with-magic-set proc . rest)
  (let-keywords* rest ((db (default-magic-file))
					   (flags MAGIC_NONE))
	(let ((ms (magic-open flags)))
	  (dynamic-wind
		  (lambda () (when (= 0 (logand MAGIC_CHECK flags))
					   (magic-load ms db)))
		  (lambda () (proc ms))
		  (lambda () (magic-close ms))))))

(provide "file/magic")
