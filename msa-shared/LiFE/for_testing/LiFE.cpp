//
// MATLAB Compiler: 6.2 (R2016a)
// Date: Mon Feb 20 15:29:11 2017
// Arguments: "-B" "macro_default" "-W" "cpplib:LiFE" "-T" "link:lib" "-d"
// "/gpfs/home/h/a/hayashis/Karst/git/sca-service-life/msa-shared/LiFE/for_testi
// ng" "-v"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feBuildDictionaries.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feClipFibersToVolume.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feConnectionVLSOE.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feConnectomeEncoding.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feConnectomeInit.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feConnectomeSetDwi.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feConnectomeStatistics.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feCreate.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feFiberNetworkStats.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feGet.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feGetRep.m"
// "/gpfs/home/h/a/hayashis/BigRed2/git/encode/life/fe/feSet.m"
// "/gpfs/home/h/a/hayashis/Karst/git/sca-service-life/life.m"
// "/gpfs/home/h/a/hayashis/Karst/git/sca-service-life/main.m" "-a"
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
bool MW_CALL_CONV mlxFeBuildDictionaries(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[])
{
  return mclFeval(_mcr_inst, "feBuildDictionaries", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeClipFibersToVolume(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "feClipFibersToVolume", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectionVLSOE(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[])
{
  return mclFeval(_mcr_inst, "feConnectionVLSOE", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeEncoding(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[])
{
  return mclFeval(_mcr_inst, "feConnectomeEncoding", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeInit(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[])
{
  return mclFeval(_mcr_inst, "feConnectomeInit", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeSetDwi(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[])
{
  return mclFeval(_mcr_inst, "feConnectomeSetDwi", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeStatistics(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                            *prhs[])
{
  return mclFeval(_mcr_inst, "feConnectomeStatistics", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeCreate(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "feCreate", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeFiberNetworkStats(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[])
{
  return mclFeval(_mcr_inst, "feFiberNetworkStats", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeGet(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "feGet", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeGetRep(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "feGetRep", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeSet(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "feSet", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxLife(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "life", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_C_API 
bool MW_CALL_CONV mlxMain(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[])
{
  return mclFeval(_mcr_inst, "main", nlhs, plhs, nrhs, prhs);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feBuildDictionaries(int nargout, mwArray& fe, const mwArray& fe_in1, 
                                      const mwArray& Nphi, const mwArray& Ntheta)
{
  mclcppMlfFeval(_mcr_inst, "feBuildDictionaries", nargout, 1, 3, &fe, &fe_in1, &Nphi, &Ntheta);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feClipFibersToVolume(int nargout, mwArray& fg, mwArray& kept, const 
                                       mwArray& fg_in1, const mwArray& coords, const 
                                       mwArray& maxVolDist)
{
  mclcppMlfFeval(_mcr_inst, "feClipFibersToVolume", nargout, 2, 3, &fg, &kept, &fg_in1, &coords, &maxVolDist);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feConnectionVLSOE(int nargout, mwArray& fib, mwArray& vl, mwArray& vx, 
                                    const mwArray& fe, const mwArray& roi1, const 
                                    mwArray& roi2)
{
  mclcppMlfFeval(_mcr_inst, "feConnectionVLSOE", nargout, 3, 3, &fib, &vl, &vx, &fe, &roi1, &roi2);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feConnectomeEncoding(int nargout, mwArray& fe, const mwArray& fe_in1)
{
  mclcppMlfFeval(_mcr_inst, "feConnectomeEncoding", nargout, 1, 1, &fe, &fe_in1);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feConnectomeInit(int nargout, mwArray& fe, const mwArray& dwiFile, 
                                   const mwArray& fgFileName, const mwArray& feFileName, 
                                   const mwArray& savedir, const mwArray& 
                                   dwiFileRepeated, const mwArray& anatomyFile, const 
                                   mwArray& varargin)
{
  mclcppMlfFeval(_mcr_inst, "feConnectomeInit", nargout, 1, -7, &fe, &dwiFile, &fgFileName, &feFileName, &savedir, &dwiFileRepeated, &anatomyFile, &varargin);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feConnectomeSetDwi(int nargout, mwArray& fe, const mwArray& fe_in1, 
                                     const mwArray& dwiFileName, const mwArray& isrepeat)
{
  mclcppMlfFeval(_mcr_inst, "feConnectomeSetDwi", nargout, 1, 3, &fe, &fe_in1, &dwiFileName, &isrepeat);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feConnectomeStatistics(int nargout, mwArray& fe, const mwArray& fe_in1)
{
  mclcppMlfFeval(_mcr_inst, "feConnectomeStatistics", nargout, 1, 1, &fe, &fe_in1);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feCreate(int nargout, mwArray& fe)
{
  mclcppMlfFeval(_mcr_inst, "feCreate", nargout, 1, 0, &fe);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feFiberNetworkStats(int nargout, mwArray& fns, mwArray& pval, mwArray& 
                                      fdat, const mwArray& data, const mwArray& nreps, 
                                      const mwArray& prop, const mwArray& kcore)
{
  mclcppMlfFeval(_mcr_inst, "feFiberNetworkStats", nargout, 3, 4, &fns, &pval, &fdat, &data, &nreps, &prop, &kcore);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feGet(int nargout, mwArray& val, const mwArray& fe, const mwArray& 
                        param, const mwArray& varargin)
{
  mclcppMlfFeval(_mcr_inst, "feGet", nargout, 1, -3, &val, &fe, &param, &varargin);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feGetRep(int nargout, mwArray& val, const mwArray& fe, const mwArray& 
                           param, const mwArray& varargin)
{
  mclcppMlfFeval(_mcr_inst, "feGetRep", nargout, 1, -3, &val, &fe, &param, &varargin);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV feSet(int nargout, mwArray& fe, const mwArray& fe_in1, const mwArray& 
                        param, const mwArray& val, const mwArray& varargin)
{
  mclcppMlfFeval(_mcr_inst, "feSet", nargout, 1, -4, &fe, &fe_in1, &param, &val, &varargin);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV life(int nargout, mwArray& fe, mwArray& out, const mwArray& config)
{
  mclcppMlfFeval(_mcr_inst, "life", nargout, 2, 1, &fe, &out, &config);
}

LIB_LiFE_CPP_API 
void MW_CALL_CONV main()
{
  mclcppMlfFeval(_mcr_inst, "main", 0, 0, 0);
}

