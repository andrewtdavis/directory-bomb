# Directory Bomb Scripts

_These scripts will create millions of files quickly, either empty or with data for testing various data management tools._

**Be exceptionally careful running these scripts, as they can consistently create files faster than anything I've found can delete them!**

- `dirbomb.sh <directory> <# dirs> <# files / directory>` - Creates empty files, thousands to millions of them.
- `dirbomb-data.sh` Creates files with data, thousands to millions of them. Tunable to how much has data, and variable uniqueness.
- `-d <# dirs>`
- `-f <# files/directory>`
- `-t <taget-dir>`
- `-p <% files with data>`
- `-u <% of files with identical data vs unique> -s <size of file, default 1M. Use K/M/G)`