 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
data_bucket="s3://hendr522-s1024-bibsnet-v2p0"
run_folder=`pwd`
temp_dir="/tmp"

abcd_hcp_pipeline_folder="${run_folder}/run_files.abcd-hcp-pipeline_infant"
abcd_hcp_pipeline_template="template.abcd-hcp-pipeline_infant"

email=`echo $USER@umn.edu`
group=`groups|cut -d" " -f1`

# if processing run folders (sMRI, fMRI,) exist delete them and recreate
if [ -d "${abcd_hcp_pipeline_folder}" ]; then
	rm -rf "${abcd_hcp_pipeline_folder}"
	mkdir -p "${abcd_hcp_pipeline_folder}"
else
	mkdir -p "${abcd_hcp_pipeline_folder}"
fi

# counter to create run numbers
k=0

subjects=(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 20) #exclude 19, wasn't included in model training

for subj_id in "${subjects[@]}"; do
	ses_id='0mo'
	sed -e "s|SUBJECTID|${subj_id}|g" -e "s|SESID|${ses_id}|g" -e "s|TEMPDIR|${temp_dir}|g" -e "s|BUCKET|${data_bucket}|g" -e "s|RUNDIR|${run_folder}|g" ${run_folder}/${abcd_hcp_pipeline_template} > ${abcd_hcp_pipeline_folder}/run${k}
	k=$((k+1))
done

chmod 775 -R ${abcd_hcp_pipeline_folder}
sed -e "s|GROUP|${group}|g" -e "s|EMAIL|${email}|g" -i ${run_folder}/resources_abcd-hcp-pipeline_infant.sh 

