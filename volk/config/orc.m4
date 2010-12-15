dnl pkg-config-based checks for Orc

dnl specific:
dnl ORC_CHECK([REQUIRED_VERSION])

AC_DEFUN([ORC_CHECK],
[
  ORC_REQ=ifelse([$1], , "0.4.6", [$1])
  
  enable_orc = auto
  if test "x$enable_orc" != "xno" ; then
    PKG_CHECK_MODULES(ORC, orc-0.4 >= $ORC_REQ, [
      AC_DEFINE(HAVE_ORC, 1, [Use Orc])
      if test "x$ORCC" = "x" ; then
        ORCC=`$PKG_CONFIG --variable=orcc orc-0.4`
      fi
      AC_SUBST(ORCC)
      ORCC_FLAGS="--compat $ORC_REQ"
      ORC_LDFLAGS=`$PKG_CONFIG --libs orc-0.4`
      ORC_CFLAGS=`$PKG_CONFIG --cflags orc-0.4`
      AC_SUBST(ORCC_FLAGS)
      AC_SUBST(ORC_LDFLAGS)
      AC_SUBST(ORC_CFLAGS)
      HAVE_ORC=yes
      HAVE_ORCC=yes
      if test "x$cross_compiling" = "xyes" ; then
        HAVE_ORCC=no
      fi
    ], [
      if test "x$enable_orc" = "xyes" ; then
        AC_MSG_ERROR([--enable-orc specified, but Orc >= $ORC_REQ not found])
      fi
      AC_DEFINE(DISABLE_ORC, 1, [Disable Orc])
      HAVE_ORC=no
      HAVE_ORCC=no
    ])
  else
    AC_DEFINE(DISABLE_ORC, 1, [Disable Orc])
    HAVE_ORC=no
    HAVE_ORCC=no
  fi
  AM_CONDITIONAL(HAVE_ORC, [test "x$HAVE_ORC" = "xyes"])
  AM_CONDITIONAL(HAVE_ORCC, [test "x$HAVE_ORCC" = "xyes"])

]))

AC_DEFUN([ORC_OUTPUT],
[
  if test "$HAVE_ORC" = yes ; then
    printf "configure: *** Orc acceleration enabled.\n"
  else
    if test "x$enable_orc" = "xno" ; then
      printf "configure: *** Orc acceleration disabled by --disable-orc.\n"
    else
      printf "configure: *** Orc acceleration disabled.  Requires Orc >= $ORC_REQ, which was\n"
      printf "               not found.\n"
    fi
  fi
  printf "\n"
])

