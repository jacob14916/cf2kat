import os
import sys
import re

try:
    dirname = sys.argv[1]
    os.chdir(dirname)
    dirfiles = os.listdir('./')
except Exception:
    print('Usage: python3 cf_to_kat_data.py DIRNAME')
    exit(1)
    
re_inputs = r"^[0-9]+$"
re_outputs = r"^[0-9]+\.a$"

if len(sys.argv) >= 3 and sys.argv[2] == "example":
    print("example mode")
    re_inputs = r"^example\.[0-9]+$"
    re_outputs = r"^example\.[0-9]+\.a$"

for fname in dirfiles:
    if re.search(re_inputs, fname) is not None:
        print('Input file:', fname)
        os.rename(fname, fname + '.in')
    elif re.search(re_outputs, fname) is not None:
        print('Output file:', fname)
        os.rename(fname, fname+'ns')