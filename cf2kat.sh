#!/bin/bash
C2KDIR="$( dirname $0 )"

USAGE="Usage: cf2kat.sh SOURCE.zip DEST"
CAVEATS=$'Caveats: Validator must be named validator.cpp; Custom checkers not currently supported'


if [ $# -ne 2 ]
then
    echo $USAGE
    echo $CAVEATS
    exit 1
fi

SOURCE_DIR="$( mktemp -d cf2kat.XXXXXX )"

echo "$SOURCE_DIR"


if [ -f $1 ]
then
    unzip "$1" -d "$SOURCE_DIR"
else
    echo "File $1 does not exist"
    rm -r "$SOURCE_DIR"
    exit 1
fi

PROBLEMNAME="$( basename $2 )"

rm -r "$2"
mkdir "$2"

cp "$C2KDIR/problem.yaml" "$2"
echo "$PROBLEMNAME" >> "$2/problem.yaml"

mkdir "$2/data"
mkdir "$2/data/secret"
mkdir "$2/data/sample"


cp "$SOURCE_DIR/tests/"* "$2/data/secret/"
python3 "$C2KDIR/cf_to_kat_data.py" "$2/data/secret"
dos2unix "$2/data/secret"/*

cp "$SOURCE_DIR/statement-sections/english/example"* "$2/data/sample"
python3 "$C2KDIR/cf_to_kat_data.py" "$2/data/sample" example
dos2unix "$2/data/sample"/*

mkdir "$2/input_format_validators" 
if [ -f "$SOURCE_DIR/files/validator.cpp" ]
then 
    mkdir "$2/input_format_validators/validator"
    cp "$SOURCE_DIR/files/testlib.h" "$2/input_format_validators/validator/testlib.h"
    cp "$SOURCE_DIR/files/validator.cpp" "$2/input_format_validators/validator/validator.cpp"
    cp "$C2KDIR/input_validator_build.sh" "$2/input_format_validators/validator/build"
    chmod +x "$2/input_format_validators/validator/build"
    cp "$C2KDIR/input_validator_run.sh" "$2/input_format_validators/validator/run"
    chmod +x "$2/input_format_validators/validator/run"
else
    mkdir "$2/input_format_validators/fake"
    cp "$C2KDIR/fakebuild.sh" "$2/input_format_validators/fake/build"
    cp "$C2KDIR/fakevalidator.sh" "$2/input_format_validators/fake/run"
fi

mkdir "$2/submissions"
mkdir "$2/submissions/accepted"
cp "$SOURCE_DIR/solutions/"*.cpp "$2/submissions/accepted/"

#using bash to write a problem statement

mkdir "$2/problem_statement"
PROB="$2/problem_statement/problem.en.tex"
echo -n "\problemname{" >> "$PROB"
cat "$SOURCE_DIR/statement-sections/english/name.tex" >> "$PROB"
echo "}" >> "$PROB"
cat "$SOURCE_DIR/statement-sections/english/legend.tex" >> "$PROB"
echo "" >> "$PROB"
echo "\section*{Input}" >> "$PROB"
cat "$SOURCE_DIR/statement-sections/english/input.tex" >> "$PROB"
echo "" >> "$PROB"
echo "\section*{Output}" >> "$PROB"
cat "$SOURCE_DIR/statement-sections/english/output.tex" >> "$PROB"

rm -r "$SOURCE_DIR"