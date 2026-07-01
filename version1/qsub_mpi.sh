#!/bin/sh
#PBS -N guess_mpi
#PBS -e test.e
#PBS -o test.o
#PBS -l nodes=1:ppn=4

NODES=$(cat $PBS_NODEFILE | sort | uniq)

for node in $NODES; do
    scp master_ubss1:/home/${USER}/guess/main ${node}:/home/${USER}/main 1>&2
    scp -r master_ubss1:/home/${USER}/guess/files ${node}:/home/${USER}/ 1>&2
done

GEN=${GEN:-1}
BATCH=${BATCH:-500000}
HYBRID_TRAIN_THREADS=${HYBRID_TRAIN_THREADS:-2}
HYBRID_GENERATE_THREADS=${HYBRID_GENERATE_THREADS:-2}
HYBRID_GENERATE_THRESHOLD=${HYBRID_GENERATE_THRESHOLD:-1024}
HYBRID_HASH_THREADS=${HYBRID_HASH_THREADS:-2}
HYBRID_HASH_THRESHOLD=${HYBRID_HASH_THRESHOLD:-4096}
HYBRID_USE_HEAP=${HYBRID_USE_HEAP:-1}
export HYBRID_TRAIN_THREADS HYBRID_GENERATE_THREADS HYBRID_GENERATE_THRESHOLD
export HYBRID_HASH_THREADS HYBRID_HASH_THRESHOLD HYBRID_USE_HEAP

/usr/local/bin/mpiexec -np 4 -machinefile $PBS_NODEFILE /home/${USER}/main ${GEN} ${BATCH}

scp -r /home/${USER}/files/ master_ubss1:/home/${USER}/guess/ 2>&1
