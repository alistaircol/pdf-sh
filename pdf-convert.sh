#!/usr/bin/env bash
# https://askubuntu.com/a/488354/762631
echo "Please select the PDF file you wish to convert to PDF Version 1.4"
PDF_SOURCE=$(zenity \
  --file-selection \
  --file-filter='PDF files (pdf) | *.pdf' \
  --title="Select a PDF file to convert to PDF Version 1.4" \
  2> /dev/null
)
PDF_SOURCE_VERSION=$(pdfinfo $PDF_SOURCE | grep 'PDF version')
echo "Source PDF: ${PDF_SOURCE}"
echo "Source PDF: ${PDF_SOURCE_VERSION}"

PDF_TARGET=$(zenity \
  --file-selection \
  --file-filter='PDF files (pdf) | *.pdf' \
  --title="Select a file to save source PDF to PDF Version 1.4" \
  --save \
  --confirm-overwrite \
  2> /dev/null
)
PDF_TARGET_VERSION="1.4"

echo "Target PDF: ${PDF_TARGET}"
echo "Target PDF: PDF version:    ${PDF_TARGET_VERSION}"
echo ""
echo "Converting!"
gs \
  -sDEVICE=pdfwrite \
  -dCompatibilityLevel=$PDF_TARGET_VERSION \
  -o "${PDF_TARGET}" \
  "${PDF_SOURCE}"

echo "Done!"

