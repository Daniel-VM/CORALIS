#           info_collector.py
#
# So far, the info_collector retrieves ncRNA-target  to databases listed in the mti_urls.json file.
# The information relative to molecular interactions is retrieved and stored into into the data/source/ directory.
import pandas as pd
import json
import requests
import gzip
import re


with open('mti_urls.json') as j_file:
    data = json.load(j_file)

#MIRTARBASE
mirtarbase = requests.get(data['miRTarbase'])
with open('../data/source/mirtarbase_all.xlsx', 'wb') as f_mirtarbase:
    f_mirtarbase.write(mirtarbase.content)


#RAID
# The RAIDatabase has stored the information regarding the ncRNA-interactions based on categories which are encoded numerically under the argument PID. 
# This pids indicates the detection method (strong / weak experimental evicence and computational prediction) by which ncRNA-interaction were found. 
# Aditionally, each pid argument has associated a sub argument called id  that points to the technique used.
# All source interaction files in RAID are stored according to the ID number.  
#     pid=31 <- strong experimental evicence and computational prediction
#     pid=32 <- weak experimental evicence and computational prediction
#
#     id=31*.zip <- strong experimental evicence and computational prediction
#     id=32*.zip <- weak experimental evicence and computational prediction
raid_url = data['RAID'] 
raid_pids = requests.get("https://www.rna-society.org/rnainter/js/browser/myztree.js")

pattern_strong = 'id:(.*?), pId:31'
pattern_weak = 'id:(.*?), pId:32'

pids_strong = re.findall(pattern_strong, raid_pids.text)
pids_weak = re.findall(pattern_weak, raid_pids.text)

pids_all = pids_strong + pids_weak

cc = 1
for i in range(0, len(pids_all)):
    if pids_all[i] == "321":
        pids_all[i] = "ChIP-seq"
        
    file_name = pids_all[i] + ".zip"
    raid_file = raid_url + file_name
    raid = requests.get(raid_file, allow_redirects=False)
    bf = '../data/source/tmp/' + file_name 
    with open(bf, 'wb') as f_raid:
        f_raid.write(raid.content)
        print(file_name)
    cc+=1
print(cc) #107 files