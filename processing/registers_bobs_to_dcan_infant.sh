module load fsl

# Summary: register the manually corrected segmentations (currently in original ALBERT space) so that it's in the same space as PREPROC_T2, intermediate T2 output from DCAN-infant pipeline

cd /home/faird/shared/code/internal/utilities/register_bobs_to_dcan/ || exit
PREPROC_T2_space=/home/faird/shared/code/internal/utilities/register_bobs_to_dcan/PREPROC_T2_space/
PREPROC_T2=$PREPROC_T2_space/T2w_acpc_dc_restore_brain.nii.gz
s3cmd get --skip-existing s3://hendr522-s1024-bibsnet-v2p0/processed_JLF/dcan-infant-pipeline/sub-01/ses-0mo/files/T1w/T2w_acpc_dc_restore_brain.nii.gz $PREPROC_T2

END=20
for i in $(seq  -f "%02g" 1 $END);
  do
    echo $i;
    ORIG_ALBERT_T2_FILE=0mo_sub-${i}_0001.nii.gz
    ORIG_ALBERT_T2=/home/midb-ig/public/hendr522/nnUNet/Realdata_BCP_and_ALBERTs_dataset/images/$ORIG_ALBERT_T2_FILE
    if test -f $ORIG_ALBERT_T2; then
      echo "$ORIG_ALBERT_T2 exists."
    else
      echo "$ORIG_ALBERT_T2 doesn't exist."
      continue
    fi
    INPUTASEG_FILE=0mo_sub-${i}.nii.gz
    INPUTASEG=/home/midb-ig/public/hendr522/nnUNet/Realdata_BCP_and_ALBERTs_dataset/segmentations/$INPUTASEG_FILE
    if test -f $INPUTASEG; then
      echo "$INPUTASEG exists."
    else
      echo "INPUTASEG doesn't exist."
      continue
    fi

    mkdir -p $PREPROC_T2_space/$i
    cd $PREPROC_T2_space/$i || exit
    cp $ORIG_ALBERT_T2 .
    cp $INPUTASEG .

    # Step 1: register ORIG_ALBERT_T2 to PREPROC_T2:
    flirt -ref $PREPROC_T2 -in ./$ORIG_ALBERT_T2_FILE -omat ./omat.mat -out ./albert2preprocT2.nii.gz -cost mutualinfo -searchrx -15 15 -searchry -15 15 -searchrz -15 15 -dof 6

    # Step 2: apply .mat file to aseg:
    applywarp --rel --interp=nn -i ./$INPUTASEG_FILE -r $PREPROC_T2 --premat=./omat.mat -o ./albert2preprocT2_aseg.nii.gz
  done
cd ..
