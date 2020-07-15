#!/usr/bin/env bash
# http://jamesslocum.com/post/61904545275
FILES=()
STOP=0
echo "Append documents together, order is important!"

PDF_SOURCE=$(zenity \
  --file-selection \
  --file-filter='PDF files (pdf) | *.pdf' \
  --title="Select a PDF file" \
  2> /dev/null
)
INITIAL_PDF_SOURCE_CHOSEN=$?

if [ $INITIAL_PDF_SOURCE_CHOSEN -ne "0" ]; then
  echo "No source given, bye"
  exit 0
fi

echo "SOURCE: ${PDF_SOURCE}"
FILES+=("${PDF_SOURCE}")

while [ $STOP -eq "0" ]; do
  # Y = 0
  # N = 1
  zenity \
    --question \
    --text="Do you want to append another file" \
    --ok-label="Yes" \
    --cancel-label="No" \
    2> /dev/null

  APPEND_ANOTHER=$?

  if [ $APPEND_ANOTHER -ne "0" ]; then
    STOP=1
  else
    PDF_SOURCE=$(zenity \
      --file-selection \
      --file-filter='PDF files (pdf) | *.pdf' \
      --title="Select a PDF file" \
      2> /dev/null
    )
    echo "SOURCE: ${PDF_SOURCE}"
    FILES+=("${PDF_SOURCE}")
  fi
done

if [ ${#FILES[@]} -eq "1" ]; then
  echo "Only one file, doing nothing."
  exit 0
fi

# https://askubuntu.com/a/844278/762631
LIST_COLUMN_NAMES=(--column="File Path")
zenity \
  --list \
  --title="Files to append" "${LIST_COLUMN_NAMES[@]}" "${FILES[@]}" \
  2> /dev/null

PROCEED=$?

if [ $PROCEED -ne "0" ]; then
  echo "Doing nothing."
else
  echo "Concatting!"
  PDF_TARGET=$(zenity \
    --file-selection \
    --file-filter='PDF files (pdf) | *.pdf' \
    --title="Select a target file to save combined documents" \
    --save \
    --confirm-overwrite \
    2> /dev/null
  )
  echo "TARGET: ${PDF_TARGET}"
  pdftk "${FILES[@]}" cat output ${PDF_TARGET}
  echo "Done!"
  xdg-open $PDF_TARGET
fi

