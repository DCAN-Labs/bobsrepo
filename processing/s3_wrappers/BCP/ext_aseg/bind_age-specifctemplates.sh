TEMPLATE_BIND=/home/elisonj/shared/BCP/lib/templates/${template}

# THIS IS BCP SPECIFIC
if [ ${#ses_id} -ge 4 ] && [ ${ses_id:2} == 'mo' ]; then
    MONTH=${ses_id:0:2}
elif [ ${#ses_id} -ge 3 ] && [ ${ses_id:1} == 'mo' ]; then
    MONTH=${ses_id:0:1}
elif [ ${#ses_id} -ge 3 ] && [ ${ses_id:1} == 'wk' ]; then
    MONTH=0
elif [ ${#ses_id} -ge 4 ] && [ ${ses_id:2} == 'wk' ]; then
    MONTH=0
fi

if   [ "${MONTH}" -lt 0 ]; then
    echo "Invalid month <0: ${MONTH}, exiting"
    exit 1
elif [ "${MONTH}" -le 2 ] ; then
    template=00-02
elif [ "${MONTH}" -le 5 ] ; then
    template=02-05
elif [ "${MONTH}" -le 11 ] ; then
    template=08-11
elif [ "${MONTH}" -le 14 ] ; then
    template=11-14
elif [ "${MONTH}" -le 17 ] ; then
    template=14-17
elif [ "${MONTH}" -le 21 ] ; then
    template=17-21
elif [ "${MONTH}" -le 27 ] ; then
    template=21-27
elif [ "${MONTH}" -le 33 ] ; then
    template=27-33
elif [ "${MONTH}" -le 44 ] ; then
    template=33-44
elif [ "${MONTH}" -le 60 ] ; then
    template=44-60
else
    echo "Invalid month >60 ${MONTH}, exiting."
    exit 1
fi


