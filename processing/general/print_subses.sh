 #!/bin/bash 

set +x 
# determine data directory, run folders, and run templates
#temp_dir="/tmp" 
temp_dir='/home/feczk001/shared/projects/BOBSRepo/processing/DCAN-infant_s3_wrapper/OUT'
data_bucket="s3://hendr522-s1024-bibsnet-v2p0"



for i in `s3cmd ls ${data_bucket}/ | awk '{print $2}'`; do
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then 
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
        echo ${subj_id}
	fi
done

for i in `s3cmd ls ${data_bucket}/ | awk '{print $2}'`; do
	sub_text=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
	if [ "sub" = "${sub_text}" ]; then 
		subj_id=`echo ${i} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'`
		for j in `s3cmd ls ${data_bucket}/${sub_text}-${subj_id}/ | awk '{print $2}'`; do
			ses_text=`echo ${j} |  awk -F"/" '{print $(NF-1)}' | awk -F"-" '{print $1}'`
			if [ "ses" = "${ses_text}" ]; then
				ses_id=`echo ${j} | awk -F"/" '{print $(NF-1)}' | awk  -F"-" '{print $2}'` # CHANGE THIS?
                echo ${ses_id}
			fi
		done
	fi
done
