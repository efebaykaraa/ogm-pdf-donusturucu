# Convert OGM ZIP files to PDF

Converts ZIP files that you download from the OGM Material website to PDF files.

## Prerequisites

- Windows operating system
- PowerShell
- Microsoft Print to PDF printer

## File Structure
```
Convert-Images-to-PDF
├── windows
│   ├── bin
│   │   ├── convert_images_gui.ps1
│   │   ├── convert_images_to_pdf.ps1
│   │   └── prepare_images.bat
│   ├── ogm_to_pdf.bat
├── linux
│   ├── ogm_to_pdf.sh
├── LICENSE
└── README.md
```

## Usage

### Step 1: Set Up the Files

Clone this repository or download the ZIP file and extract it to a directory of your choice.
```shell
git clone https://github.com/efexplose/ogm-pdf-donusturucu
```

### On Windows:

1. Run the `ogm_to_pdf.bat` file by double-clicking it.
2. Select the language in the GUI (English or Turkish).
3. Specify the path of the ZIP file containing the images.
4. Specify the desired output path for the PDF file.
5. Click the `Convert` button to start the conversion process.

### On Linux:

1. Run the `ogm_to_pdf.sh` file in a terminal.
2. Select the language in the GUI (English or Turkish).
3. Specify the path of the ZIP file containing the images.
4. Specify the desired output path for the PDF file.
5. Click the `Convert` button to start the conversion process.