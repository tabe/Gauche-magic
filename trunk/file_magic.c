/*
 *  file_magic.c
 *
 *   Copyright (c) 2006,2007 Takeshi Abe. All rights reserved.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions
 *   are met:
 *
 *    1. Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *    3. Neither the name of the authors nor the names of its contributors
 *       may be used to endorse or promote products derived from this
 *       software without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *  $Id$
 */

#include "file_magic.h"

ScmClass *FileMagicSetClass;

static void
fileMagicSetCleanUp(ScmObj obj)
{
  if (!fileMagicSetClosedP(obj)) {
	magic_t ms = FILE_MAGIC_SET_UNBOX(obj);
	magic_close(ms);
  }
}

static ScmObj sym_closed;

int
fileMagicSetClosedP(ScmObj obj)
{
  SCM_ASSERT(SCM_FOREIGN_POINTER_P(obj));
  return !SCM_FALSEP(Scm_ForeignPointerAttrGet(SCM_FOREIGN_POINTER(obj),
											   sym_closed, SCM_FALSE));
}

void
fileMagicSetMarkClosed(ScmObj obj)
{
  SCM_ASSERT(SCM_FOREIGN_POINTER_P(obj));
  Scm_ForeignPointerAttrSet(SCM_FOREIGN_POINTER(obj),
							sym_closed, SCM_TRUE);
}

ScmObj
fileMagicRaiseCondition(magic_t ms)
{
  int no = magic_errno(ms);
  const char *msg = magic_error(ms);
  return Scm_RaiseCondition(SCM_SYMBOL_VALUE("file.magic", "<magic-error>"),
							"no", SCM_MAKE_INT(no),
							SCM_RAISE_CONDITION_MESSAGE,
							(msg == NULL) ? "(no message)" : msg);
}

magic_t
fileMagicOpen(int flags)
{
  magic_t ms = magic_open(flags);
  if (ms == NULL) {
	Scm_Error("magic_open(%d) failed", flags);
  }
  return ms;
}

const char *
fileMagicFile(magic_t ms, const char *path)
{
  const char *result;
  if ( (result = magic_file(ms, path)) == NULL) {
	fileMagicRaiseCondition(ms);
  }
  return result;
}

#define CALL_OR_RAISE_CONDITION(func, ms, path) do {	\
	if (func(ms, path) == -1) {							\
	  fileMagicRaiseCondition(ms);						\
	  return -1;										\
	}													\
	return 0;											\
  } while (0)

int
fileMagicLoad(magic_t ms, const char *path)
{
  CALL_OR_RAISE_CONDITION(magic_load, ms, path);
}

int
fileMagicCompile(magic_t ms, const char *path)
{
  CALL_OR_RAISE_CONDITION(magic_compile, ms, path);
}

int
fileMagicCheck(magic_t ms, const char *path)
{
  CALL_OR_RAISE_CONDITION(magic_check, ms, path);
}

const char *
defaultMagicFile(void)
{
#if defined HAVE__USR_SHARE_MISC_MAGIC
  return "/usr/share/misc/magic";
#elif defined HAVE__USR_SHARE_MISC_FILE_MAGIC
  return "/usr/share/misc/file/magic";
#elif defined HAVE__USR_LOCAL_SHARE_FILE_MAGIC
  return "/usr/local/share/file/magic";
#else
  return "/usr/share/file/magic";
#endif
}

ScmObj
Scm_Init_file_magic(void)
{
  ScmModule *mod;

  SCM_INIT_EXTENSION(file_magic);

  mod = SCM_MODULE(SCM_FIND_MODULE("file.magic", TRUE));

  FileMagicSetClass =
	Scm_MakeForeignPointerClass(mod, "<magic-set>",
								NULL, fileMagicSetCleanUp, SCM_FOREIGN_POINTER_KEEP_IDENTITY|SCM_FOREIGN_POINTER_MAP_NULL);

  sym_closed = SCM_INTERN("closed?");

  Scm_Init_file_magiclib(mod);
}
