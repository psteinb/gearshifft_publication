// nvcc -o cufft test_cufft.cpp -std=c++11 -lcufft
#include <cuda_runtime.h>
#include <iostream>
#include <cufft.h>
#include <stdexcept>
#include <array>
#include <vector>
#include <chrono>
// CHECK_CUDA template function for cuda and cufft
//  and throws std::runtime_error
#define CHECK_CUDA(ans) check_cuda((ans), "", #ans, __FILE__, __LINE__)
inline
void throw_error(int code,
                 const char* error_string,
                 const char* msg,
                 const char* func,
                 const char* file,
                 int line) {
  throw std::runtime_error("CUDA error "
                           +std::string(msg)
                           +" "+std::string(error_string)
                           +" ["+std::to_string(code)+"]"
                           +" "+std::string(file)
                           +":"+std::to_string(line)
                           +" "+std::string(func)
    );
}
static const char* cufftResultToString(cufftResult error) {
  switch (error) {
  case CUFFT_SUCCESS:
    return "CUFFT_SUCCESS";

  case CUFFT_INVALID_PLAN:
    return "CUFFT_INVALID_PLAN";

  case CUFFT_ALLOC_FAILED:
    return "CUFFT_ALLOC_FAILED";

  case CUFFT_INVALID_TYPE:
    return "CUFFT_INVALID_TYPE";

  case CUFFT_INVALID_VALUE:
    return "CUFFT_INVALID_VALUE";

  case CUFFT_INTERNAL_ERROR:
    return "CUFFT_INTERNAL_ERROR";

  case CUFFT_EXEC_FAILED:
    return "CUFFT_EXEC_FAILED";

  case CUFFT_SETUP_FAILED:
    return "CUFFT_SETUP_FAILED";

  case CUFFT_INVALID_SIZE:
    return "CUFFT_INVALID_SIZE";

  case CUFFT_UNALIGNED_DATA:
    return "CUFFT_UNALIGNED_DATA";
  }
  return "<unknown>";
}

inline
void check_cuda(cudaError_t code, const char* msg, const char *func, const char *file, int line) {
  if (code != cudaSuccess) {
    throw_error(static_cast<int>(code),
                cudaGetErrorString(code), msg, func, file, line);
  }
}
inline
void check_cuda(cufftResult code, const char* msg,  const char *func, const char *file, int line) {
  if (code != CUFFT_SUCCESS) {
    throw_error(static_cast<int>(code),
                cufftResultToString(code), "cufft", func, file, line);
  }
}

// _______________________________________________________
// Outplace Complex
template<typename T>
void run(int extent, int ID) {
  const auto runs = 5;
  T* hdata = nullptr;
  T* data;
  T* data_transform;
  cufftHandle plan;
  std::vector< std::array<size_t, 1> > vec_extents;
  vec_extents.push_back( {static_cast<size_t>(extent)} );
//  vec_extents.push_back( {16777216} );

  CHECK_CUDA( cudaSetDevice(0) );

  typedef std::chrono::high_resolution_clock clock;
  clock::time_point start;

  for( auto extents : vec_extents ) {
    size_t data_size = extents[0]*sizeof(T);
    size_t data_transform_size = extents[0]*sizeof(T);
    size_t s = 0;
    double time = 0.0;

    try {
      hdata = new T[extents[0]];

      for(auto i=0; i<=runs; ++i) {
        start = clock::now();
        CHECK_CUDA( cudaMalloc(&data, data_size));
        CHECK_CUDA( cudaMalloc(&data_transform, data_transform_size));

        CHECK_CUDA( cufftPlan1d(&plan, extents[0], CUFFT_C2C, 1));

        CHECK_CUDA( cudaMemcpy(data, hdata, data_size, cudaMemcpyHostToDevice) );

        CHECK_CUDA( cufftExecC2C(plan, data, data_transform, CUFFT_FORWARD));
        CHECK_CUDA( cufftExecC2C(plan, data_transform, data, CUFFT_INVERSE));

        CHECK_CUDA( cudaMemcpy(hdata, data, data_size, cudaMemcpyDeviceToHost) );

        CHECK_CUDA( cudaFree(data) );
        CHECK_CUDA( cudaFree(data_transform) );
        CHECK_CUDA( cufftDestroy(plan) );
        if(i==0)
          continue; //i=0 => warmup
        auto diff = clock::now() - start;
        auto duration = std::chrono::duration<double, std::milli> (diff).count();
        std::cout << "\"cuFFT\",\"Inplace\",\"Complex\",\"float\",1,\"powerof2\","<<extents[0]<<",0,0,"<<i<<",\"Success\",0,0,0,0,0,0,0,0,0,"<<duration<<","<<sizeof(T)*extents[0]<<",0,0,"<<ID<<std::endl;
      }

      delete[] hdata;
      hdata = nullptr;

    }catch(...){
      std::cout << "Error for nx="<<extents[0] << std::endl;
      // cleanup
      CHECK_CUDA( cudaFree(data) );
      CHECK_CUDA( cudaFree(data_transform) );
      delete[] hdata;
      if(plan) {
        CHECK_CUDA( cufftDestroy(plan) );
      }
    }
  }
  CHECK_CUDA( cudaDeviceReset() );
}
//
int main(int argc, char** argv) {
  int ID=atoi(argv[2]);
  if(ID==0) {
    std::cout << "\"Tesla K80\", \"CC\", 3.7, \"Multiprocessors\", 13, \"Memory [MiB]\", 11439, \"MemoryFree [MiB]\", 11376, \"MemClock [MHz]\", 2505, \"GPUClock [MHz]\", 875, \"CUDA Runtime\", 8000, \"cufft\", 8000"<<std::endl
            << "; \"Time_ContextCreate [ms]\", NA"<<std::endl
            << "; \"Time_ContextDestroy [ms]\", NA"<<std::endl
            << "\"library\",\"inplace\",\"complex\",\"precision\",\"dim\",\"kind\",\"nx\",\"ny\",\"nz\",\"run\",\"success\",\"0\",\"Time_Allocation [ms]\",\"Time_PlanInitFwd [ms]\",\"Time_PlanInitInv [ms]\",\"Time_Upload [ms]\",\"Time_FFT [ms]\",\"Time_iFFT [ms]\",\"Time_Download [ms]\",\"Time_PlanDestroy [ms]\",\"Time_Total [ms]\",\"Size_DeviceBuffer [bytes]\",\"Size_DevicePlan [bytes]\",\"Size_DeviceTransfer [bytes]\",\"ID\""<<std::endl;
  }

  run<cufftComplex>(atoi(argv[1]),ID);
  return 0;
}
