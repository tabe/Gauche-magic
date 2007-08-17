#!/usr/bin/env gosh
;; -*- coding: euc-jp -*-

(use text.html-lite)
(use text.tree)

(define *version* "0.1.1")
(define *last-update* "Mon Jan 22 2007")

(define-syntax def
  (syntax-rules (en ja procedure method)
	((_ en)
     '())
    ((_ ja)
	 '())
	((_ en (synopsis x y z ...) rest ...)
     (cons
      (def (synopsis x z ...))
      (def en rest ...)))
	((_ ja (synopsis x y z ...) rest ...)
     (cons
      (def (synopsis y z ...))
      (def ja rest ...)))
	((_ ((procedure (name arg ...) ...) (p ...) z ...))
     (list
      (html:h3 (html:span :class "type" "procedure") ": "
               (html:span :class "procedure" (html-escape-string (symbol->string 'name))) " "
               (cons (html:span :class "argument" 'arg) " ") ...)
      ...
      (map
       (lambda (x)
         (if (string? x)
             (html:p (html-escape-string x))
             (html:pre (html-escape-string (list-ref '(z ...) x)))))
       (list p ...))
      (html:hr)))
	((_ ((method (name arg ...) ...) (p ...) z ...))
	 (list
	  (html:h3 (html:span :class "type" "method") ": "
			   (html:span :class "method" (html-escape-string (symbol->string 'name))) " "
			   (cons (html:span :class "argument" (html-escape-string (x->string 'arg))) " ") ...)
	  ...
      (map
       (lambda (x)
         (if (string? x)
             (html:p (html-escape-string x))
             (html:pre (html-escape-string (list-ref '(z ...) x)))))
       (list p ...))
	  (html:hr)))
	((_ ((type name ...) (p ...) z ...))
	 (list
	  (html:h3 (html:span :class "type" 'type) ": "
			   (html:span :class 'type (html-escape-string (symbol->string 'name))))
	  ...
      (map
       (lambda (x)
         (if (string? x)
             (html:p (html-escape-string x))
             (html:pre (html-escape-string (list-ref '(z ...) x)))))
       (list p ...))
	  (html:hr)))))

(define-macro (api lang)
  `(def ,lang

	   ((class <magic-set>)
		("An object of the class wraps a C's magic_t.")
		("���Υ��֥������Ȥ� C �η� magic_t ���åפ��ޤ���"))

	   ((class <magic-error>)
		("A libmagic-origin error will be raised as a instance of the class."
		 "It has two slots: \"no\" and \"message\". The former indicates a magic-specific errno.")
		("libmagic ͳ��Υ��顼�Ϥ��Υ��饹�Υ��֥������ȤȤ����������ޤ���"
		 "���Υ��顼��2�ĤΥ���åȤ�����ޤ�: \"no\" �� \"message\" �Ǥ������Ԥ� magic �ȼ��� errno ��ؤ��ޤ���"))

	   ((variable
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
		 MAGIC_ERROR)
		("These are integers corresponding to their C-alternatives and mutually exclusive on logical-and."
		 "A flag argument of magic-open may be a logical-or of these.")
		("���줾�� C ��Ʊ̾�������Ʊ�����ͤ��ͤ˻����ޤ���"
		 "�ߤ��������Ѥ�0�ˤʤꡢ�����������¤� magic-open �� call-with-magic-set �Υե饰�Ȥ������Ѥ��ޤ���"))

	   ((procedure (magic-open flags))
		("Return a <magic-set> with given `flags', or #f if an error occurs.")
		("�ե饰 `flags' ����ꤷ�� <magic-set> ���֤��ޤ������顼������������ #f ���֤��ޤ���"))

	   ((procedure (magic-close ms))
		("Close the <magic-set> `ms'. It is preferable but optional since gc works in the long run.")
		("<magic-set> `ms' ���Ĥ��ޤ������δؿ������Ѥ��ʤ��Ƥ� gc �����Ĥ�����ˤ�äƤ���ޤ���"))

	   ((procedure (magic-load ms path))
		("Load a magic database at `path'.")
		("`path' �ˤ���ޥ��å��ǡ����١������ɤ߹��ߤޤ���"))

	   ((procedure (magic-check ms path)
				   (magic-compile ms path))
		("Check or compile a magic database at `path'."
		 "Given `ms' must have flags with MAGIC_CHECK on, an error if not.")
		("`path' �ˤ���ޥ��å��ǡ����١����������������å����⤷���ϥ���ѥ���򤷤ޤ���"
		 "`ms' �Υե饰�Τ��� MAGIC_CHECK ������Ǥʤ���Фʤ餺�������Ǥʤ����ϥ��顼�Ȥʤ�ޤ���"))

	   ((procedure (magic-file ms path))
		("Return the description of the file `path' as a string, or #f if an error occurs.")
		("`path' �ˤ���ե�����ξ����ʸ����Ȥ����֤��ޤ������顼������������ #f ���֤��ޤ���"))

	   ((parameter default-magic-file)
		("Return the path of the default database file, e.g. /usr/share/file/magic.")
		("/usr/share/file/magic �Τ褦�ʴ���Υޥ��å��ǡ����١����ե�����Υѥ����֤��ޤ���"))

       ((procedure (call-with-magic-set proc &keyword db flags))
        ("Call `proc' with a <magic-set> whose flags are `flags' as a single argument."
		 "If `flags' with MAGIC_CHECK off (default), before doing that it loads a magic wisdom which is either the `db' or a default one unless specified."
		 "Returning with an error or without it closes the <magic-set>.")
        ("�ե饰 `flags' ����� <magic-set> ������ˤ��� `proc' ��ƤӤޤ���"
		 "�ե饰�� MAGIC_CHECK �����դΤȤ�(�ǥե����)�ˤϡ��Ƥ����˥ޥ��å��ǡ����١�������ɤ��ޤ������Υǡ����١����ϥ������ `db' �ǻ��ꤵ�줿��Ρ����ꤵ��Ƥ��ʤ����ϥǥե���ȤΤ�ΤǤ���"
		 "���顼�ȤȤ�������Ǥ⤽���Ǥʤ����Ǥ⡢�������Ѥ��� <magic-set> ���Ĥ����ޤ���"))
	   ))

(define (document-tree lang)
  (let ((title (if (eq? 'ja lang) "Gauche-magic ��ե���󥹥ޥ˥奢��" "Gauche-magic Reference Manual")))
	(html:html
	 (html:head
	  (if (eq? 'ja lang) (html:meta :http-equiv "Content-Type" :content "text/html; charset=UTF-8") '())
	  (html:title title))
	 (html:body
	  (html:h1 title)
	  (html:style
	   :type "text/css"
	   "<!-- \n"
	   "h2 { background-color:#dddddd; }\n"
	   "address { text-align: right; }\n"
	   ".type { font-size: medium; text-decoration: underline; }\n"
	   ".procedure { font-size: medium; font-weight: normal; }\n"
	   ".method { font-size: medium; font-weight: normal; }\n"
	   ".argument { font-size: small; font-style: oblique; font-weight: normal; }\n"
	   ".constant { font-size: medium; font-weight: normal; }\n"
	   ".variable { font-size: medium; font-weight: normal; }\n"
	   "#last_update { text-align: right; font-size: small; }\n"
	   "#project { text-align: right; }\n"
	   " -->")
	  (html:p "For version " *version*)
	  (html:p :id "last_update" "last update: " *last-update*)
	  (html:p :id "project" (html:a :href "http://www.fixedpoint.jp/gauche-magic/" "http://www.fixedpoint.jp/gauche-magic/"))
	  (html:h2 "API")
	  (if (eq? 'en lang)
		  (api en)
		  (api ja))
	  (html:address "&copy; 2006,2007 Takeshi Abe")
	  ))))

(define (main args)
  (define (usage)
	(format (current-error-port) "usage: gosh reference.scm (en|ja)\n")
	(exit 1))
  (when (< (length args) 2)
	(usage))
  (write-tree (document-tree (string->symbol (cadr args))))
  0)
