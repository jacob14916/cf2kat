# cf2kat: Convert Codeforces packages to Kattis packages
## Usage
	./cf2kat.sh SOURCE.zip DEST
SOURCE.zip must be a Codeforces "full package". DEST is a directory that will be overwritten with the Kattis package. The name of the Kattis problem will be basename DEST. 
## Caveats
The only (input) validator that will be detected is validator.cpp.
Custom checkers are not currently supported.
