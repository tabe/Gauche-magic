#!/usr/bin/env gosh

(use file.util)
(use fixedpoint.site)
(use text.html-lite)
(use text.tree)

(//
 (magic "ftp://ftp.astron.com/pub/file/")
 (File::Type "http://search.cpan.org/~pmison/File-Type-0.22/lib/File/Type.pm")
 (File::MimeInfo::Magic "http://search.cpan.org/~pardus/File-MimeInfo-0.13/MimeInfo/Magic.pm")
 (Fileinfo "http://pecl.php.net/package/fileinfo")
 )

(define *last-update* "Wed Dec 06 2006")
(define *gauche-magic-version* (file->string "../VERSION"))
(define *gauche-magic-tarball-basename* (string-append "Gauche-magic-" *gauche-magic-version* ".tgz"))
(define *gauche-magic-tarball-size* (file-size (string-append "../../" *gauche-magic-tarball-basename*)))
(define *gauche-magic-tarball-url* *gauche-magic-tarball-basename*)

(define (index lang)
  (let-syntax ((en/ja (syntax-rules ()
						((_ en ja)
						 (if (string=? "en" lang) en ja)))))
	((fixedpoint:frame "Gauche-magic")
	 (html:p :id "lang_navi" (html:a :href (en/ja "index.html" "index.en.html")
										"[" (en/ja "Japanese" "English") "]"))
	 (html:p :id "last_update" "Last update: " *last-update*)
	 (html:p (html:dfn /Gauche-magic/)
			 (en/ja
				 (list " is an extension package of " /Gauche/ " which provides a binding of the " /magic/ " library.")
				 (list " は " /Scheme/ " 処理系 " /Gauche/ " で " /magic/ " ライブラリを利用するための拡張パッケージです。")))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "News" "最新情報"))
	 (html:ul
	  (html:li "[2006-12-06] " (en/ja "Release 0.1.0." "バージョン 0.1.0 を公開しました。")))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Features" "特徴"))
	 (html:ul
	  (html:li (en/ja "Getting the description of a given file with a magic database."
					  "マジックデータベースを用いたファイル情報の取得。"))
	  (html:li (en/ja "Checking and compiling a magic database."
					  "マジックデータベースの整合性チェックとコンパイル。")))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Requirements" "導入"))
	 (html:p (en/ja "This package is for Gauche 0.8.7 or later."
					"このパッケージは Gauche 0.8.7 またはそれ以上で動作します。"))
	 (html:ul
	  (html:li (en/ja (list "It requires the " /magic/ " library (file-4.12 or higher) which has been installed.")
					  (list "また別途 " /magic/ " ライブラリ(file バージョン 4.12 以上)がインストールされている必要があります。"))))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Download" "ダウンロード"))
	 (html:p (html:a :href *gauche-magic-tarball-url*
					 *gauche-magic-tarball-basename* " (" *gauche-magic-tarball-size*  " bytes)"))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Documents" "文書"))
	 (html:ul
	  (html:li (html:a :href (en/ja "reference.en.html" "reference.ja.html")
					   "Gauche-magic " (en/ja "Reference Manual" "リファレンスマニュアル"))))

	 (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Links" "リンク"))
	 (html:ul
	  (html:li /magic/)
	  (html:li /File::Type/)
	  (html:li /File::MimeInfo::Magic/)
	  (html:li /Fileinfo/)
	  (html:li (html:a :href (en/ja "http://httpd.apache.org/docs/2.2/en/mod/mod_mime_magic.html"
									"http://httpd.apache.org/docs/2.2/ja/mod/mod_mime_magic.html")
					   "mod_mime_magic"))
	  )
	 )))

(define (main args)
  (define (usage)
	(format (current-error-port) "usage: gosh ~a (en|ja)\n" *program-name*)
	(exit 1))
  (when (< (length args) 2)
	(usage))
  (write-tree (index (cadr args)))
  0)
