dnl
dnl 
dnl

PHP_ARG_WITH(pdflib,for PDFlib support,
[  --with-pdflib[=DIR]     Include PDFlib support.])

if test "$PHP_PDFLIB" != "no"; then
  dnl #
  dnl # The main PDFlib configure
  dnl #

  PHP_REQUIRE_CXX()
  dnl # $6 set to "1" => use $(CXX) for linking
  PHP_NEW_EXTENSION(pdf, pdf.c, $ext_shared, "", "", 1)
  dnl # MacOSX requires this
  case `(uname -s) 2>/dev/null || echo unknown` in
    *arwin*)
      PHP_ADD_FRAMEWORK(ApplicationServices)
      PDF_SHARED_LIBADD="$PDF_SHARED_LIBADD $PHP_FRAMEWORKS"
      ;;
  esac
  PHP_SUBST(PDF_SHARED_LIBADD)

  case $PHP_PDFLIB in
    yes)
        AC_DEFINE(HAVE_PDFLIB,1,[ ])
        PHP_ADD_LIBRARY(pdf,, PDF_SHARED_LIBADD)
    ;;
    *)
      if test -f "$PHP_PDFLIB/include/pdflib.h"; then
        PDFLIB_INCDIR="$PHP_PDFLIB/include"
      elif test -f "$PHP_PDFLIB/pdflib.h"; then
        PDFLIB_INCDIR="$PHP_PDFLIB"
      elif test -f "$PHP_PDFLIB/bind/c/include/pdflib.h"; then
        PDFLIB_INCDIR="$PHP_PDFLIB/bind/c/include"
      else
        AC_MSG_ERROR([pdflib.h not found! Check the path passed to --with-pdflib=<PATH>. PATH must be the install prefix or the directory containing pdflib.h.])
      fi

      dnl Accept an installation prefix, the C binding directory, or its
      dnl include directory. Official PDFlib SDK archives use include/ and
      dnl lib/ as sibling directories.
      PDFLIB_LIBDIR=""
      for i in "$PHP_PDFLIB/lib" "$PHP_PDFLIB/lib64" \
               "$PHP_PDFLIB/bind/c/lib" "$PHP_PDFLIB" \
               "$PHP_PDFLIB/../lib" "$PHP_PDFLIB/../lib64"; do
        if test -f "$i/libpdf.a" || test -f "$i/libpdf.so" || \
           test -f "$i/libpdf.dylib" || test -f "$i/libpdf.sl"; then
          PDFLIB_LIBDIR="$i"
          break
        fi
      done

      if test -z "$PDFLIB_LIBDIR"; then
        AC_MSG_ERROR([PDFlib library not found! Expected libpdf in the install prefix, lib, lib64, or a sibling lib directory.])
      fi

      AC_DEFINE(HAVE_PDFLIB,1,[ ])
      PHP_ADD_LIBRARY_WITH_PATH(pdf, $PDFLIB_LIBDIR, PDF_SHARED_LIBADD)
      PHP_ADD_INCLUDE($PDFLIB_INCDIR)
    ;;
  esac
fi
