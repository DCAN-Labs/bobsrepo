import os

s3='s3://hendr522-s1024-bibsnet-v2p0/processed_JLF/dcan-infant-pipeline'
out='/home/feczk001/shared/projects/BOBSRepo/processing/s3_wrappers/ALBERT/JLF/exec_sums'

file = open('albert_sublist.txt','r')
list = file.readlines()
for i in list:
  i=i.split('\n')[0]
  cmd=f's3cmd sync --recursive {s3}/{i}/ses-0mo/files/executivesummary/ {out}/'
  os.system(cmd)
