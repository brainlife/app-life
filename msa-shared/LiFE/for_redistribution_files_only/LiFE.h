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

#ifndef __LiFE_h
#define __LiFE_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#include "mclcppclass.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_LiFE
#define PUBLIC_LiFE_C_API __global
#else
#define PUBLIC_LiFE_C_API /* No import statement needed. */
#endif

#define LIB_LiFE_C_API PUBLIC_LiFE_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_LiFE
#define PUBLIC_LiFE_C_API __declspec(dllexport)
#else
#define PUBLIC_LiFE_C_API __declspec(dllimport)
#endif

#define LIB_LiFE_C_API PUBLIC_LiFE_C_API


#else

#define LIB_LiFE_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_LiFE_C_API 
#define LIB_LiFE_C_API /* No special import/export declaration */
#endif

extern LIB_LiFE_C_API 
bool MW_CALL_CONV LiFEInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV LiFEInitialize(void);

extern LIB_LiFE_C_API 
void MW_CALL_CONV LiFETerminate(void);



extern LIB_LiFE_C_API 
void MW_CALL_CONV LiFEPrintStackTrace(void);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeBuildDictionaries(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeClipFibersToVolume(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectionVLSOE(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                       *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeEncoding(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                          *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeInit(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                      *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeSetDwi(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                        *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeConnectomeStatistics(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                            *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeCreate(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeFiberNetworkStats(int nlhs, mxArray *plhs[], int nrhs, mxArray 
                                         *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeGet(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeGetRep(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxFeSet(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxLife(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_LiFE_C_API 
bool MW_CALL_CONV mlxMain(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);


#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

/* On Windows, use __declspec to control the exported API */
#if defined(_MSC_VER) || defined(__BORLANDC__)

#ifdef EXPORTING_LiFE
#define PUBLIC_LiFE_CPP_API __declspec(dllexport)
#else
#define PUBLIC_LiFE_CPP_API __declspec(dllimport)
#endif

#define LIB_LiFE_CPP_API PUBLIC_LiFE_CPP_API

#else

#if !defined(LIB_LiFE_CPP_API)
#if defined(LIB_LiFE_C_API)
#define LIB_LiFE_CPP_API LIB_LiFE_C_API
#else
#define LIB_LiFE_CPP_API /* empty! */ 
#endif
#endif

#endif

extern LIB_LiFE_CPP_API void MW_CALL_CONV feBuildDictionaries(int nargout, mwArray& fe, const mwArray& fe_in1, const mwArray& Nphi, const mwArray& Ntheta);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feClipFibersToVolume(int nargout, mwArray& fg, mwArray& kept, const mwArray& fg_in1, const mwArray& coords, const mwArray& maxVolDist);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feConnectionVLSOE(int nargout, mwArray& fib, mwArray& vl, mwArray& vx, const mwArray& fe, const mwArray& roi1, const mwArray& roi2);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feConnectomeEncoding(int nargout, mwArray& fe, const mwArray& fe_in1);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feConnectomeInit(int nargout, mwArray& fe, const mwArray& dwiFile, const mwArray& fgFileName, const mwArray& feFileName, const mwArray& savedir, const mwArray& dwiFileRepeated, const mwArray& anatomyFile, const mwArray& varargin);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feConnectomeSetDwi(int nargout, mwArray& fe, const mwArray& fe_in1, const mwArray& dwiFileName, const mwArray& isrepeat);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feConnectomeStatistics(int nargout, mwArray& fe, const mwArray& fe_in1);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feCreate(int nargout, mwArray& fe);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feFiberNetworkStats(int nargout, mwArray& fns, mwArray& pval, mwArray& fdat, const mwArray& data, const mwArray& nreps, const mwArray& prop, const mwArray& kcore);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feGet(int nargout, mwArray& val, const mwArray& fe, const mwArray& param, const mwArray& varargin);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feGetRep(int nargout, mwArray& val, const mwArray& fe, const mwArray& param, const mwArray& varargin);

extern LIB_LiFE_CPP_API void MW_CALL_CONV feSet(int nargout, mwArray& fe, const mwArray& fe_in1, const mwArray& param, const mwArray& val, const mwArray& varargin);

extern LIB_LiFE_CPP_API void MW_CALL_CONV life(int nargout, mwArray& fe, mwArray& out, const mwArray& config);

extern LIB_LiFE_CPP_API void MW_CALL_CONV main();

#endif
#endif
