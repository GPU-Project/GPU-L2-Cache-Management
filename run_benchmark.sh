#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <cache_policy> <benchmark>"
    exit 1
fi


# Assign arguments to variables
CACHE_POLICY=$1
BENCHMARK=$2

# Validate CACHE_POLICY
case $CACHE_POLICY in
    L|F|M|Q|R|S|P)
        ;; # Valid cache policy
    *)
        echo "Invalid cache policy. Choose from L, F, M, Q, R, S, P."
        exit 1
        ;;
esac

# Validate BENCHMARK
case $BENCHMARK in
    CP|MUM|RAY|NQU|BFS)
        ;; # Valid benchmark
    *)
        echo "Invalid benchmark. Choose from CP, MUM, RAY, NQU, BFS."
        exit 1
        ;;
esac

# Define file paths
CONFIG_FILE="gpgpu-sim_distribution/configs/GTX480/gpgpusim.config"
GPUWATTCH_FILE="test/gpuwattch_gtx480.xml"
BENCHMARK_DIR="ispass2009-benchmarks/$BENCHMARK"

# Step 0
cd /root/test


# Step 1: Clear current directory (Be very careful with this step)
rm -rf *

cd ..

# Navigate to the directory containing the config file
cd gpgpu-sim_distribution/configs/GTX480/ || exit

# Edit the config file and replace the cache policy
sed -i "s/-gpgpu_cache:dl2 64:128:8,./-gpgpu_cache:dl2 64:128:8,$CACHE_POLICY/" "gpgpusim.config"

cd /root

# Step 14 and 15: Copy the modified config and wattch files to the test directory
cp -a ./gpgpu-sim_distribution/configs/GTX480/* ./test/
cp cp test/gpgpusim.config  "$BENCHMARK_DIR/"
cp "$GPUWATTCH_FILE" "$BENCHMARK_DIR/"

# Step 15: Navigate to the benchmarks directory
cd ispass2009-benchmarks/

# Step 90 and 17: Setup configuration
./setup_config.sh --cleanup > /dev/null 2>&1
./setup_config.sh GTX480 > /dev/null 2>&1

# Step 18 and 19: Run the benchmark and output the results
cd "$BENCHMARK"
sh README.GPGPU-Sim | grep "miss_rate"

