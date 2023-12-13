# GPGPU-Sim Project Setup Guide

This README provides detailed instructions on setting up and running simulations using GPGPU-Sim, focusing on L2 cache management in GPU architectures.

## Prerequisites

- Ensure that you have atleast 3.5 GB of free space before running this project in CIMS CLUSTER.
- Using this README, we have successfully ran our code on CIMS cluster.


## Setup and Execution Steps

### Step 1: Build GPGPU-Sim Sandbox

Create a GPGPU-Sim sandbox environment using Apptainer. This step sets up an isolated environment for your GPGPU-Sim project.

```
apptainer build --sandbox gpgpu-sim-sandbox docker://socalucr/gpgpu-sim    
```
Expected time 10 mins and ignore all the warnings


### Step 2: Enter the Sandbox Environment

Enter the sandbox environment using Apptainer:

```
apptainer exec --fakeroot --writable gpgpu-sim-sandbox /bin/bash  
```

### Step 3: Navigate to Root Directory inside the sandbox container

Once inside the container:

```
cd /root/  
```

### Step 4: Verify CUDA Installation Path

Check that the CUDA_INSTALL_PATH environment variable is correctly set to /usr/local/cuda:

```
echo $CUDA_INSTALL_PATH
```

### Step 5: Set NVIDIA Compute SDK Location

Set the NVIDIA Compute SDK location:

```
export NVIDIA_COMPUTE_SDK_LOCATION=/root/NVIDIA_GPU_Computing_SDK/

```

### Step 6: Verify NVIDIA Compute SDK Location

Confirm the setting of the NVIDIA_COMPUTE_SDK_LOCATION variable:

```
echo $NVIDIA_COMPUTE_SDK_LOCATION

```

### Step 7: Clone GPU L2 Cache Management Repository

Clone the repository containing L2 cache management which contains our code:

```
git clone https://github.com/GPU-Project/GPU-L2-Cache-Management

```

### Step 8: Copy Modified Source to GPGPU-Sim

Clone the repository containing L2 cache management which contains our code:

```
cp -r GPU-L2-Cache-Management/src gpgpu-sim_distribution/

```

### Step 9: Copy Modified Benchmark SH file to /root

Clone the repository containing L2 cache management which contains our code:

```
cp -r GPU-L2-Cache-Management/run_benchmark.sh /root

```

## Step 10: Navigate to GPGPU-Sim Distribution

Change directory to the GPGPU-Sim distribution:
```
cd gpgpu-sim_distribution/

```

## Step 11:  Setup Environment and Compile

Set up the environment and compile the simulator:
```
source setup_environment
make clean
make
```

Compilation takes approximately 10 minutes. Ignore warnings if they appear.

## Step 12:  Prepare Benchmark Environment

Prepare the environment for running benchmarks:
```
cd ..
mkdir test
cp -a ./gpgpu-sim_distribution/configs/GTX480/* ./test/
cd ispass2009-benchmarks/
make -f Makefile.ispass-2009
./setup_config.sh GTX480
cd ..
cd test/
```
The make process for benchmarks may take around 5 minutes and ignore warnings

## Step 13:  Test the Installation

Run a specific benchmark (e.g., RAY) and extract relevant metrics like cache miss rate:

```
../ispass2009-benchmarks/bin/release/RAY 4 4 | grep miss_rate
```

Now all the environment and benchmark for the project is setup and you should see Total cache miss rate

## Step 14:  Change the permissions for the run_benchmark file

Change the permissions for the run_benchmark file

```
cd /root
chmod +x run_benchmark.sh
```

## Step 15:  RUN Benchmark for a specific cache policy and benchmark

Change the permissions for the run_benchmark file

```
./run_benchmark.sh F BFS
```
All Possible values for cache policies are L, F, M, Q, R, S, P

All Possible values for Benchmark algorithms are CP, MUM, RAY, NQU, BFS