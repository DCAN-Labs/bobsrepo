import os
from nipype.interfaces import fsl

bids_input='/home/elisonj/shared/BCP/raw/BIDS_output'
aseg_src_dir='/home/feczk001/shared/projects/BOBSRepo/UPLOAD/s3_bucket_backup'
proc_src='s3://bcp.lt8mo.prefs.only'
out_dir='/home/feczk001/shared/projects/BOBSRepo/aseg2nativeT2/test'

with open('bobsrepo_sublist.txt') as file:
    for line in file:
        src=line.strip('\n')
        sub=src.split('/')[0]
        ses=src.split('/')[1]

        sub_dir=os.path.join(out_dir, sub, ses)     
        sub_wd=os.path.join(sub_dir, 'wd')
        sub_anat_dir=os.path.join(sub_dir, 'anat')
        aseg_T2space_fp=f'{sub_anat_dir}/{sub}_{ses}_space-T2w_desc-aseg_dseg.nii.gz'

        if not os.path.exists(aseg_T2space_fp):      
            if not os.path.exists(sub_wd):
                os.makedirs(sub_wd)
            if not os.path.exists(sub_anat_dir):
                os.mkdir(sub_anat_dir)

            # Download mat files needed
            os.system(f's3cmd sync {proc_src}/{sub}/{ses}/files/T2w/xfms/tmpT2w2T1w.mat {sub_wd}/')
            os.system(f's3cmd sync {proc_src}/{sub}/{ses}/files/T2w/xfms/acpc.mat {sub_wd}/')

            # If mat files are available:
            if os.path.exists(f'{sub_wd}/acpc.mat'):
                # Concatenate T2 mat files and take inverse of concatenated file
                os.system(f'convert_xfm -omat {sub_wd}/acpc_T22T1reg_concat.mat -concat {sub_wd}/tmpT2w2T1w.mat {sub_wd}/acpc.mat')
                os.system(f'convert_xfm -omat {sub_wd}/inv.mat -inverse {sub_wd}/acpc_T22T1reg_concat.mat')

                # Apply inverse mat file to aseg using native T2w as reference 
                aseg_T2space_fp=f'{sub_anat_dir}/{sub}_{ses}_space-T2w_desc-aseg_dseg.nii.gz'
                os.system(f'flirt -applyxfm -ref {bids_input}/{src}/anat/{sub}_{ses}_run-001_T2w.nii.gz -in {aseg_src_dir}/{src}/anat/{sub}_{ses}_space-INFANTMNIacpc_desc-aseg_dseg.nii.gz -init {sub_wd}/inv.mat -o {aseg_T2space_fp} -interp nearestneighbour')