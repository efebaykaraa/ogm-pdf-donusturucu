param (
    [string]$zipFile,
    [string]$outputFile
)

# Function to convert images to PDF
function ConvertToPdf($files, $outFile) {
    Add-Type -AssemblyName System.Drawing
    $files = @($files)
    if (!$outFile) {
        $firstFile = $files[0] 
        if ($firstFile.FullName) { $firstFile = $firstFile.FullName }
        $outFile = $firstFile.Substring(0, $firstFile.LastIndexOf(".")) + ".pdf"
    } else {
        if (![System.IO.Path]::IsPathRooted($outFile)) {
            $outFile = [System.IO.Path]::Combine((Get-Location).Path, $outFile)
        }
    }

    try {
        $doc = [System.Drawing.Printing.PrintDocument]::new()
        $opt = $doc.PrinterSettings = [System.Drawing.Printing.PrinterSettings]::new()
        $opt.PrinterName = "Microsoft Print to PDF"
        $opt.PrintToFile = $true
        $opt.PrintFileName = $outFile

        $script:_pageIndex = 0
        $doc.add_PrintPage({
            param($sender, [System.Drawing.Printing.PrintPageEventArgs] $a)
            $file = $files[$script:_pageIndex]
            if ($file.FullName) {
                $file = $file.FullName
            }
            $script:_pageIndex = $script:_pageIndex + 1

            Write-Output "Processing page $script:_pageIndex of $($files.Count)"

            try {
                $image = [System.Drawing.Image]::FromFile($file)
                $a.Graphics.DrawImage($image, $a.PageBounds)
                $a.HasMorePages = $script:_pageIndex -lt $files.Count
            }
            finally {
                $image.Dispose()
            }
        })

        $doc.PrintController = [System.Drawing.Printing.StandardPrintController]::new()

        $doc.Print()
        return $outFile
    }
    finally {
        if ($doc) { $doc.Dispose() }
    }
}

# Call the batch script to prepare images
$batchScript = "bin\prepare_images.bat"
$prepareCmd = "& .\$batchScript $zipFile"

Write-Output "Calling prepare_images.bat with arguments $zipFile"

$tempDir = Invoke-Expression $prepareCmd | Select-String -Pattern 'Temporary directory created: (.*)' | ForEach-Object { $_.Matches[0].Groups[1].Value.Trim() }

if ($LASTEXITCODE -ne 0) {
    Write-Output "Failed to prepare images."
    exit 1
}

Write-Output "Images prepared successfully in $tempDir\files\mobile"

# Get the list of JPG files in the temporary directory
$jpgFiles = Get-ChildItem -Path "$tempDir\files\mobile" -Filter "*.jpg"

if ($jpgFiles.Count -eq 0) {
    Write-Output "No JPG files found in $tempDir\files\mobile"
    exit
}

Write-Output "Found $($jpgFiles.Count) JPG files in $tempDir\files\mobile"

# Determine the output PDF file name
if ($outputFile -like "*.pdf") {
    $pdfFile = $outputFile
} else {
    $pdfFile = [System.IO.Path]::Combine($outputFile, "output.pdf")
}

Write-Output "Output PDF will be created at: $pdfFile"

# Convert JPG files to PDF
ConvertToPdf $jpgFiles $pdfFile

Write-Output "PDF created successfully: $pdfFile"

# Clean up by deleting the temporary directory
Remove-Item -Recurse -Force "$tempDir\files\mobile"

Write-Output "Temporary directory deleted."

Write-Output "Process has completed successfully. Press any key to exit."