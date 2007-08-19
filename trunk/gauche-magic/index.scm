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
           (list " �� " /Scheme/ " ������ " /Gauche/ " �� " /magic/ " �饤�֥������Ѥ��뤿��γ�ĥ�ѥå������Ǥ���")))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "News" "�ǿ�����"))
  (html:ul
   (html:li "[2007-01-18] " (en/ja "Release 0.1.1. Small fixes and changes for Gauche 0.8.8 API."
                                   "�С������ 0.1.1 ��������ޤ����������ʥХ������� Gauche 0.8.8 API �������ѹ����ޤޤ�Ƥ��ޤ���"))
   (html:li "[2006-12-06] " (en/ja "Release 0.1.0." "�С������ 0.1.0 ��������ޤ�����")))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Features" "��ħ"))
  (html:ul
   (html:li (en/ja "Getting the description of a given file with a magic database."
                   "�ޥ��å��ǡ����١������Ѥ����ե��������μ�����"))
   (html:li (en/ja "Checking and compiling a magic database."
                   "�ޥ��å��ǡ����١����������������å��ȥ���ѥ��롣")))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Requirements" "Ƴ��"))
  (html:p (en/ja "This package is for Gauche 0.8.8 or later."
                 "���Υѥå������� Gauche 0.8.8 �ޤ��Ϥ���ʾ��ư��ޤ���"))
  (html:ul
   (html:li (en/ja (list "It requires the " /magic/ " library (file-4.12 or higher) which has been installed.")
                   (list "�ޤ����� " /magic/ " �饤�֥��(file �С������ 4.12 �ʾ�)�����󥹥ȡ��뤵��Ƥ���ɬ�פ�����ޤ���"))))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Download" "���������"))
  (*package-download*)

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Documents" "ʸ��"))
  (html:ul
   (html:li (html:a :href (en/ja "reference.en.html" "reference.ja.html")
                    "Gauche-magic " (en/ja "Reference Manual" "��ե���󥹥ޥ˥奢��"))))

  (html:h2 :style "border-bottom: 1px solid #bbbbbb;" (en/ja "Links" "���"))
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
