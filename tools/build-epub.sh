#!/usr/bin/env bash

#go to project root
PROJECT_ROOT="$(cd `dirname $0`/..; pwd)"
cd "$PROJECT_ROOT"

OUTPUT=epub
HUGO_DIR="$PROJECT_ROOT/public-${OUTPUT}"
HUGO_CONFIG="$PROJECT_ROOT/config-${OUTPUT}.yaml"
HUGO_PUBLIC="$PROJECT_ROOT/public"

if [ ! -d "$PROJECT_ROOT/po" ]
then
   echo "po files not found"
   echo "exiting"
   exit 1
fi

# Get a list of languages
languages=`find $PROJECT_ROOT/po -name '*.po' | cut -d . -f 2 | sort -u`

# convert newlines to spaces and add English to the list
languages=$(echo "en $languages")

#check for config
if [ ! -f "$HUGO_CONFIG" ]
then
   echo "config not found"
   echo "exiting"
   exit 1
fi

#initialise directories
rm -r "$HUGO_DIR"
mkdir -p "$HUGO_DIR"

#build epub hugo files
hugo -v --config "${HUGO_CONFIG}" -d "${HUGO_DIR}"

if [ ! -d "$HUGO_DIR/en" ]
then
   echo "no English language directory found -- exiting"
   exit 1
fi

#create copy of image files from the English site for use in other languages
mkdir "${HUGO_DIR}/all_images"
cd "${HUGO_DIR}/en"
find . -type f \( -name "*.png" -o -name "*.jpg" \) -exec cp -n --parents {} "${HUGO_DIR}/all_images" \;

#create manifest additions for image files (which can't be generated by Hugo)
shopt -s globstar
rm img_manifest.txt

i=1
cd "${HUGO_DIR}/all_images"

for extension in png jpg
do
   for file in **/*.$extension
   do

      if [[ "$extension" = "jpg" ]]
      then
         type=jpeg
      else
         type=png
      fi

      echo "   <item href=\"$file\" id=\"image$i\" media-type=\"image/$type\"/>" >> img_manifest.txt

      ((i=i+1))

   done
done

#generate epubs for each language
for language in $languages
do
  echo "processing language $language"

  if [ -d "$HUGO_DIR/$language" ]
  then

     #create target directory for epub if it doesn't exist
     mkdir -p "$HUGO_PUBLIC/$language"

     #copy non-languuage files to language dir
     cd "${HUGO_DIR}"
     cp mimetype $language/mimetype
     cp -r OEBPS $language/OEBPS
     cp -r META-INF $language/META-INF
     cp darktable-logo.svg $language/OEBPS/
     cp style.css $language/OEBPS/

     #copy images
     cd "${HUGO_DIR}/all_images"
     find . -type f \( -name "*.png" -o -name "*.jpg" \) -exec cp -n --parents {} "${HUGO_DIR}/$language" \;
     
     #update content.opf with image locations
     cd "$HUGO_DIR/$language"
     cp "${HUGO_DIR}/all_images/img_manifest.txt" .
     sed -i -e "/<manifest>/r img_manifest.txt" content.opf

     #replace occurences of en or $language string
     find . -type f -name "*.html" -exec sed -i "s/\.\.\/$language\///g" {} +
     find . -type f -name "*.html" -exec sed -i 's/\.\.\/style\.css/style.css/' {} +
     sed -i "s/content src\=\"$language\//content src\=\"/" toc.ncx
     sed -i "s/item href\=\"$language\//item href\=\"/" content.opf
     sed -i "s/a href\=\"$language\//a href\=\"/" toc.xhtml
     sed -i "s/\.\.\/style\.css/style.css/" toc.xhtml

     #move files to target epub directories
     mv darkroom guides-tutorials lighttable lua map module-reference overview preferences-settings print slideshow special-topics tethering OEBPS
     mv *.html content.opf toc.xhtml toc.ncx index.html style.css darktable-logo* OEBPS

     #create epub
     zip -rX "$HUGO_PUBLIC/$language/darktable_user_manual.epub" mimetype OEBPS META-INF

  else
     echo "$language directory not found"
  fi
done

