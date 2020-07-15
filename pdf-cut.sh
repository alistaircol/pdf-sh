#!/usr/bin/env bash
echo "Please select the PDF file you wish to slice"
PDF_SOURCE=$(zenity \
  --file-selection \
  --file-filter='PDF files (pdf) | *.pdf' \
  --title="Select a PDF file to slice" \
  2> /dev/null
)
PDF_SOURCE_VERSION=$(pdfinfo $PDF_SOURCE | grep 'PDF version')
echo "Source PDF: ${PDF_SOURCE}"
echo "Source PDF: ${PDF_SOURCE_VERSION}"

PDF_SOURCE_PAGES=$(pdfinfo $PDF_SOURCE | grep "Pages:" | awk '{print $2}')

echo "Please select page number you want to start"
PDF_SOURCE_PAGE_START=$(zenity \
  --scale \
  --min-value=1 \
  --max-value=$PDF_SOURCE_PAGES \
  --step=1 \
  --value=1 \
  --text="Start Page" \
  2> /dev/null
)

echo "Please select page number you want to end"
PDF_SOURCE_PAGE_END=$(zenity \
  --scale \
  --min-value=$PDF_SOURCE_PAGE_START \
  --max-value=$PDF_SOURCE_PAGES \
  --step=1 \
  --value=$PDF_SOURCE_PAGE_START \
  --text="End Page" \
  2> /dev/null
)

echo "Num pages: ${PDF_SOURCE_PAGES}"
echo "Num pages: ${PDF_SOURCE_PAGE_START}"
echo "Num pages: ${PDF_SOURCE_PAGE_END}"

echo "Please file you want to save pages ${PDF_SOURCE_PAGE_START} - ${PDF_SOURCE_PAGE_END}"
PDF_TARGET=$(zenity \
  --file-selection \
  --file-filter='PDF files (pdf) | *.pdf' \
  --title="Select a file to save source PDF pages ${PDF_SOURCE_PAGE_START} - ${PDF_SOURCE_PAGE_END}" \
  --save \
  --confirm-overwrite \
  2> /dev/null
)

pdftk "${PDF_SOURCE}" cat $PDF_SOURCE_PAGE_START-$PDF_SOURCE_PAGE_END output $PDF_TARGET 
xdg-open $PDF_TARGET
echo "Done!"

