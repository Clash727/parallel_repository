#include <cstdio>
#include <cuda_runtime.h>

__global__ void hello_kernel() {}

int main() {
    int count = 0;
    cudaError_t err = cudaGetDeviceCount(&count);
    if (err != cudaSuccess) {
        std::printf("cudaGetDeviceCount failed: %s\n", cudaGetErrorString(err));
        return 1;
    }
    std::printf("CUDA devices: %d\n", count);
    if (count > 0) {
        cudaDeviceProp prop{};
        cudaGetDeviceProperties(&prop, 0);
        std::printf("Device 0: %s\n", prop.name);
    }
    hello_kernel<<<1, 1>>>();
    err = cudaDeviceSynchronize();
    if (err != cudaSuccess) {
        std::printf("kernel failed: %s\n", cudaGetErrorString(err));
        return 1;
    }
    std::printf("CUDA smoke test passed\n");
    return 0;
}
