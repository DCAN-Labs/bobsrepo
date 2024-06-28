import os

## Registering manually corrected ALBERT and nnUNet asegs to DCAN-infant pipeline space
wd='/home/feczk001/shared/projects/BOBSRepo/PROC/bobsrepo/processing/general/ALBERTreg2DCANinfant'

int_files=os.path.join(wd, "int_files")
out=os.path.join(wd,"registered_asegs")

sublist=['sub-01', 'sub-02', 'sub-03', 'sub-04', 'sub-05', 'sub-06', 'sub-07', 'sub-08', 'sub-09', 'sub-10', 'sub-11', 'sub-12','sub-13','sub-14','sub-15','sub-16','sub-17','sub-18','sub-20']
#exclude sub-19, aseg was too poor to include in model

for i in sublist:
    ## Register ALBERT T2s provided by Tim to intermediate dcan-infant pipeline output T2
    os.chdir(os.path.join(int_files, i))

    ## pull down JLF T2 from s3
    cmd=f's3cmd get s3://hendr522-s1024-bibsnet-v2p0/processed/JLF/dcan-infant-pipeline/{i}/ses-0mo/files/T1w/T2w_acpc_dc_restore_brain.nii.gz'
    # os.system(cmd)

    ## register albert T2 to dcan proc T2
    if not os.path.exists('albert2preprocT2.nii.gz'):
        albert_T2=f'/home/midb-ig/public/hendr522/nnUNet/Realdata_BCP_and_ALBERTs_dataset/images/0mo_{i}_0001.nii.gz'
        flirtcmd=f'flirt -ref T2w_acpc_dc_restore_brain.nii.gz -in {albert_T2} -omat omat.mat -out albert2preprocT2.nii.gz -cost mutualinfo -searchrx -15 15 -searchry -15 15 -searchrz -15 15 -dof 6'
        os.system(flirtcmd)

    ## Apply .mat file to manually corrected and nnUNet asegs 
    mc_aseg_src=f'/home/midb-ig/public/hendr522/nnUNet/Realdata_BCP_and_ALBERTs_dataset/segmentations/0mo_{i}.nii.gz'
    mc_aseg_dest=os.path.join(out, f'0mo_{i}_reg2dcaninfant_mc.nii.gz')
    warpcmd=f'applywarp --rel --interp=nn -i {mc_aseg_src} -r T2w_acpc_dc_restore_brain.nii.gz --premat=omat.mat -o {mc_aseg_dest}'
    os.system(warpcmd)

    nnunet_aseg_src=f'/home/midb-ig/public/hendr522/nnUNet/T1+T2CrossValidation/asegs_cc_2.0_with_synthstrip_and_bias/0mo_{i}.nii.gz'
    nnunet_aseg_dest=os.path.join(out, f'0mo_{i}_reg2dcaninfant_nnunet.nii.gz')
    warpcmd=f'applywarp --rel --interp=nn -i {nnunet_aseg_src} -r T2w_acpc_dc_restore_brain.nii.gz --premat=omat.mat -o {nnunet_aseg_dest}'
    os.system(warpcmd)
