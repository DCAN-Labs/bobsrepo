module load fsl

# Summary: register the manually corrected segmentations (currently in original ALBERT space) so that it's in the same space as PREPROC_T2, intermediate T2 output from DCAN-infant pipeline

# Step 1: register ORIG_ALBERT_T2 to PREPROC_T2:
s3cmd get s3://hendr522-s1024-bibsnet-v2p0/processed_JLF/dcan-infant-pipeline/sub-01/ses-0mo/files/T1w/T2w_acpc_dc_restore_brain.nii.gz
PREPROC_T2=./T2w_acpc_dc_restore_brain.nii.gz

ORIG_ALBERT_T2=/home/midb-ig/public/hendr522/nnUNet/Realdata_BCP_and_ALBERTs_dataset/images/0mo_sub-01_0001.nii.gz

flirt -ref $PREPROC_T2 -in $ORIG_ALBERT_T2 -omat omat.mat -out albert2preprocT2.nii.gz -cost mutualinfo -searchrx -15 15 -searchry -15 15 -searchrz -15 15 -dof 6

# Step 2: apply .mat file to aseg:
INPUTASEG=/home/midb-ig/public/hendr522/nnUNet/Realdata_BCP_and_ALBERTs_dataset/segmentations/0mo_sub-01.nii.gz

applywarp --rel --interp=nn -i $INPUTASEG -r $PREPROC_T2 --premat=omat.mat -o albert2preprocT2_aseg.nii.gz
