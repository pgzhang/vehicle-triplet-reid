#!/bin/sh

export CUDA_VISIBLE_DEVICES=6
source venv/bin/activate

dataset_size=''
# epoch=280000
# expr_dir='expr_attention_euclidean_fc1024_inception_multi-residual-head_attention_8_branch_inception__finetune_0'
expr_dir='expr_attention_euclidean_fc1024_inception_MBA_5b_addition_inception_1.0_1_finetune_0'
DATASET='VD1'
epoch=450000
# expr_dir='ckpt_MBA_5b_addition_1.0_VD2'
# DATASET='VD2'

python embed_timing.py \
        --experiment_root ./experiments/pku-vd/${expr_dir} \
        --dataset data/pku-vd/${DATASET}_${dataset_size}query.csv \
        --filename pku-vd_VD1_${dataset_size}query_${epoch}_embeddings.h5 \
        --checkpoint checkpoint-${epoch} \
        --batch_size 1

dataset_size='small_'
# dataset_size='medium_'
# dataset_size='large_'

python embed_timing.py \
        --experiment_root ./experiments/pku-vd/${expr_dir} \
        --dataset data/pku-vd/${DATASET}_${dataset_size}query.csv \
        --filename pku-vd_${DATASET}_${dataset_size}query_${epoch}_embeddings.h5 \
        --checkpoint checkpoint-${epoch} \
        --batch_size 1

python ./evaluate.py \
    --excluder diagonal \
    --query_dataset ./data/pku-vd/${DATASET}_query.csv \
    --query_embeddings ./experiments/pku-vd/${expr_dir}/pku-vd_${DATASET}_query_${epoch}_embeddings.h5 \
    --gallery_dataset ./data/pku-vd/${DATASET}_${dataset_size}query.csv \
    --gallery_embeddings ./experiments/pku-vd/${expr_dir}/pku-vd_${DATASET}_${dataset_size}query_${epoch}_embeddings.h5 \
    --metric euclidean \
    --filename ./experiments/pku-vd/${expr_dir}/pku-vd_${DATASET}_${dataset_size}query_${epoch}_evaluation.json \
    --batch_size 64 \
    
