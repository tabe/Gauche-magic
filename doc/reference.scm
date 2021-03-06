#!/usr/bin/env gosh
;; -*- coding: euc-jp -*-

(use text.html-lite)
(use text.tree)

(define *version* "0.1.0")
(define *last-update* "Wed Dec 06 2006")

(define-syntax def
  (syntax-rules (en ja procedure method)
	((_ lang)
	 '())
	((_ en ((type name ...) (p ...) (q ...)) rest ...)
	 (def en ((type name ...) (p ...)) rest ...))
	((_ ja ((type name ...) (p ...) (q ...)) rest ...)
	 (def ja ((type name ...) (q ...)) rest ...))
	((_ lang ((procedure (name arg ...) ...) (p ...)) rest ...)
	 (list*
	  (html:h3 (html:span :class "type" "procedure") ": "
			   (html:span :class "procedure" (html-escape-string (symbol->string 'name))) " "
			   (cons (html:span :class "argument" 'arg) " ") ...)
	  ...
	  (html:p (html-escape-string p))
	  ...
	  (html:hr)
	  (def lang rest ...)))
	((_ lang ((method (name arg ...) ...) (p ...)) rest ...)
	 (list*
	  (html:h3 (html:span :class "type" "method") ": "
			   (html:span :class "method" (html-escape-string (symbol->string 'name))) " "
			   (cons (html:span :class "argument" (html-escape-string (x->string 'arg))) " ") ...)
	  ...
	  (html:p (html-escape-string p))
	  ...
	  (html:hr)
	  (def lang rest ...)))
	((_ lang ((type name ...) (p ...)) rest ...)
	 (list*
	  (html:h3 (html:span :class "type" 'type) ": "
			   (html:span :class 'type (html-escape-string (symbol->string 'name))))
	  ...
	  (html:p (html-escape-string p))
	  ...
	  (html:hr)
	  (def lang rest ...)))))

(define-macro (api lang)
  `(def ,lang

	   ((class <magic-set>)
		("An object of the class wraps a C's magic_t.")
		("このオブジェクトは C の型 magic_t をラップします。"))

	   ((class <magic-error>)
		("A libmagic-origin error will be raised as a instance of the class."
		 "It has two slots: \"no\" and \"message\". The former indicates a magic-specific errno.")
		("libmagic 由来のエラーはこのクラスのオブジェクトとして生起します。"
		 "このエラーは2つのスロットを持ちます: \"no\" と \"message\" です。前者は magic 独自の errno を指します。"))

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
		("それぞれ C の同名の定数と同じ数値を値に持ちます。"
		 "互いに論理積が0になり、これらの論理和を magic-open や call-with-magic-set のフラグとして利用します。"))

	   ((procedure (magic-open flags))
		("Return a <magic-set> with given `flags'.")
		("フラグ `flags' を指定して <magic-set> を返します。"))

	   ((procedure (magic-close ms))
		("Close the <magic-set> `ms'. It is preferable but optional since gc works in the long run.")
		("<magic-set> `ms' を閉じます。この関数を利用しなくても gc がいつか代わりにやってくれます。"))

	   ((procedure (magic-load ms path))
		("Load a magic database at `path'.")
		("`path' にあるマジックデータベースを読み込みます。"))

	   ((procedure (magic-check ms path)
				   (magic-compile ms path))
		("Check or compile a magic database at `path'."
		 "Given `ms' must have flags with MAGIC_CHECK on, an error if not.")
		("`path' にあるマジックデータベースを整合性チェック、もしくはコンパイルをします。"
		 "`ms' のフラグのうち MAGIC_CHECK がオンでなければならず、そうでない場合はエラーとなります。"))

	   ((procedure (magic-file ms path))
		("Return the description of the file `path' as a string.")
		("`path' にあるファイルの情報を文字列として返します。"))

	   ((parameter default-magic-file)
		("Return the path of the default database file, e.g. /usr/share/file/magic.")
		("/usr/share/file/magic のような既定のマジックデータベースファイルのパスを返します。"))

       ((procedure (call-with-magic-set proc &keyword db flags))
        ("Call `proc' with a <magic-set> whose flags are `flags' as a single argument."
		 "If `flags' with MAGIC_CHECK off (default), before doing that it loads a magic wisdom which is either the `db' or a default one unless specified."
		 "Returning with an error or without it closes the <magic-set>.")
        ("フラグ `flags' を持つ <magic-set> を引数にして `proc' を呼びます。"
		 "フラグで MAGIC_CHECK がオフのとき(デフォルト)には、呼ぶ前にマジックデータベースをロードします。このデータベースはキーワード `db' で指定されたもの、指定されていない場合はデフォルトのものです。"
		 "エラーとともに戻る場合でもそうでない場合でも、引数に用いた <magic-set> は閉じられます。"))
	   ))

(define (document-tree lang)
  (let ((title (if (eq? 'ja lang) "Gauche-magic リファレンスマニュアル" "Gauche-magic Reference Manual")))
	(html:html
	 (html:head
	  (if (eq? 'ja lang) (html:meta :http-equiv "Content-Type" :content "text/html; charset=EUC-JP") '())
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
	   " -->")
	  (html:p "For version " *version*)
	  (html:p :id "last_update" "last update: " *last-update*)
	  (html:h2 "API")
	  (if (eq? 'en lang)
		  (api en)
		  (api ja))
	  (html:address "(c) 2006 Takeshi Abe")
	  ))))

(define (main args)
  (define (usage)
	(format (current-error-port) "usage: gosh reference.scm (en|ja)\n")
	(exit 1))
  (when (< (length args) 2)
	(usage))
  (write-tree (document-tree (string->symbol (cadr args))))
  0)
