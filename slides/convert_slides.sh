# requires decktape to be installed
# if $1 is a folder, then only convert .html files in that folder
# if $1 is a file, then only convert that file
# if $1 is empty, then convert all .html files in the _site/slides directory
#
# Usage:
# ./convert_slides.sh
# ./convert_slides.sh _site/posts
# ./convert_slides.sh _site/posts/2019-01-01-my-presentation.html

convert_to_pdf() {
    local file=$1
    echo "Converting $file to pdf"
    docker run --rm -t -v "$(pwd)":/slides -v "$(pwd)":/home/user astefanutti/decktape --screenshots-size '1920x1080' /home/user/"$file" "$file".pdf
}

if [ -d "$1" ]; then
    echo "Converting all .html files in $1 to pdf"
    find "$1" -name "slides.html" | while read -r file; do
        convert_to_pdf "$file"
    done
elif [ -f "$1" ]; then
    convert_to_pdf "$1"
else
    echo "Converting all .html files in _site/slides to pdf"
    find _site/slides -name "slides.html" | while read -r file; do
        convert_to_pdf "$file"
    done
fi
