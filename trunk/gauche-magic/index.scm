#!/usr/bin/env gosh
;; -*- encoding: euc-jp -*-

(use fixedpoint.package)
(use fixedpoint.site)
(use text.html-lite)

(//
 (magic "ftp://ftp.astron.com/pub/file/")
 (File::Type "http://search.cpan.org/~pmison/File-Type-0.22/lib/File/Type.pm")
 (File::MimeInfo::Magic "http://search.cpan.org/~pardus/File-MimeInfo-0.13/MimeInfo/Magic.pm")
 (Fileinfo "http://pecl.php.net/package/fileinfo")
 )

(define-package Gauche-magic 2007 1 18)

(define-index Gauche-magic
  (html:p (html:dfn /Gauche-magic/)
          (en/ja
           (list " is an extension package of " /Gauche/ " which provides a binding of the " /magic/ " library.")
           (list " は " /Scheme/ " 処理系 " /Gauche/ " で " /magic/ " ライブラリを利用するための拡張パッケージです。")))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "News" "最新情報"))
  (html:ul
   (html:li "[2007-01-18] " (en/ja "Release 0.1.1. Small fixes and changes for Gauche 0.8.8 API."
                                   "バージョン 0.1.1 を公開しました。小さなバグ修正と Gauche 0.8.8 API 向けの変更が含まれています。"))
   (html:li "[2006-12-06] " (en/ja "Release 0.1.0." "バージョン 0.1.0 を公開しました。")))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Features" "特徴"))
  (html:ul
   (html:li (en/ja "Getting the description of a given file with a magic database."
                   "マジックデータベースを用いたファイル情報の取得。"))
   (html:li (en/ja "Checking and compiling a magic database."
                   "マジックデータベースの整合性チェックとコンパイル。")))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Requirements" "導入"))
  (html:p (en/ja "This package is for Gauche 0.8.8 or later."
                 "このパッケージは Gauche 0.8.8 またはそれ以上で動作します。"))
  (html:ul
   (html:li (en/ja (list "It requires the " /magic/ " library (file-4.12 or higher) which has been installed.")
                   (list "また別途 " /magic/ " ライブラリ(file バージョン 4.12 以上)がインストールされている必要があります。"))))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Download" "ダウンロード"))
  (*package-download*)

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
  )

(define main package-main)
