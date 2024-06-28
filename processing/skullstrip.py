import os

wd='/home/feczk001/shared/projects/BOBSRepo/PROC/bobsrepo/processing/general/synthstrip'
os.chdir(wd)
sif='/home/faird/shared/code/external/utilities/synthstrip_1.4.sif'

for i in os.listdir('bids'):
    head=f'{wd}/bids/{i}/ses-0mo/anat/{i}_ses-0mo_T2w.nii.gz'
    skullstripped=f'{i}_ses-0mo_T2w_skullstripped.nii.gz'
    mask=f'{i}_ses-0mo_T2w_mask.nii.gz'
    mask_dil=f'{i}_ses-0mo_T2w_maskdil.nii.gz'

    outdir=os.path.join(wd, 'out')
    cmd=f'singularity run -B {head} {sif} -i {head} -o {skullstripped} -m {mask} --no-csf'
    #os.system(cmd)

    fillh=f'fslmaths {mask} -dilM -fillh {mask_dil}'
    os.system(fillh)
