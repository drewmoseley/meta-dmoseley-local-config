import os
import shutil
import glob

tezi_dirs = glob.glob("/work2/dmoseley/Toradex/Apalis*") + \
    glob.glob("/work2/dmoseley/Toradex/Aquila*") + \
    glob.glob("/work2/dmoseley/Toradex/Colibri*") + \
    glob.glob("/work2/dmoseley/Toradex/Verdin*")
for tezi_dir in tezi_dirs:
    print(tezi_dir)
