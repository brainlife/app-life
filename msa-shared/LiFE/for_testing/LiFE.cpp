//
// MATLAB Compiler: 6.2 (R2016a)
// Date: Mon Feb 20 14:58:29 2017
// Arguments: "-B" "macro_default" "-W" "cpplib:LiFE" "-T" "link:lib" "-d"
// "/gpfs/home/h/a/hayashis/Karst/git/sca-service-life/NewFolder/LiFE/for_testin
// g" "-v" "/gpfs/home/h/a/hayashis/Karst/git/sca-service-life/main.m" "-a"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode-mexed/mexfiles" 
//

#include <stdio.h>
#define EXPORTING_LiFE 1
#include "LiFE.h"

static HMCRINSTANCE _mcr_inst = NULL;


#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_LiFE_C_API
#define LIB_LiFE_C_API /* No special import/export declaration */
#endif

LIB_LiFE_C_API 
bool MW_CALL_CONV LiFEInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler)
{
    int bResult = 0;
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
    {
        mclCtfStream ctfStream = 
            mclGetEmbeddedCtfStream((void *)(LiFEInitializeWithHandlers));
        if (ctfStream) {
            bResult = mclInitializeComponentInstanceEmbedded(   &_mcr_inst,
                                                                error_handler, 
                                                                print_handler,
                                                                ctfStream);
            mclDestroyStream(ctfStream);
        } else {
            bResult = 0;
        }
    }  
    if (!bResult)
    return false;
  return true;
}

LIB_LiFE_C_API 
bool MW_CALL_CONV LiFEInitialize(void)
{
  return LiFEInitializeWithHandlers(mclDefaultErrorHandler, mclDefaultPrintHandler);
}

LIB_LiFE_C_API 
void MW_CALL_CONV LiFETerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

LIB_LiFE_C_API 
void MW_CALL_CONV LiFEPrintStackTrace(void) 
{
  char** stackTrace;
  int stackDepth = mclGetStackTrace(&stackTrace);
  int i;
  for(i=0; i<stackDepth; i++)
  {
    mclWrite(2 /* stderr */, stackTrace[i], sizeof(char)*strlen(stackTrace[i]));
    mclWrite(2 /* stderr */, "\n", sizeof(char)*strlen("\n"));
  }
  mclFreeStackTrace(&stackTrace, stackDepth);
}


LIB_LiFE_C_API 
bool MW_CALL_CONV mlxMain(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "main", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV main()
{
  mclcppMlfFeval(_mcr_inst, "main", 0, 0, 0);
}

