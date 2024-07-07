Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object Windows.Forms.Form
$form.Text = "Convert Images to PDF"
$form.Size = New-Object Drawing.Size(600,300)
$form.StartPosition = "CenterScreen"

$labelZip = New-Object Windows.Forms.Label
$labelZip.Text = "Zip File Path:"
$labelZip.Location = New-Object Drawing.Point(10,20)
$labelZip.Size = New-Object Drawing.Size(160,40)
$labelZip.Font = New-Object Drawing.Font("Microsoft Sans Serif", 12)
$form.Controls.Add($labelZip)

$textBoxZip = New-Object Windows.Forms.TextBox
$textBoxZip.Location = New-Object Drawing.Point(180,20)
$textBoxZip.Size = New-Object Drawing.Size(300,40)
$textBoxZip.Font = New-Object Drawing.Font("Microsoft Sans Serif", 12)
$form.Controls.Add($textBoxZip)

$buttonSelectZip = New-Object Windows.Forms.Button
$buttonSelectZip.Text = "Select File"
$buttonSelectZip.Location = New-Object Drawing.Point(500,20)
$buttonSelectZip.Size = New-Object Drawing.Size(80,40)
$form.Controls.Add($buttonSelectZip)

$buttonSelectZip.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Zip Files (*.zip)|*.zip|All Files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxZip.Text = $openFileDialog.FileName
    }
})

$labelOutput = New-Object Windows.Forms.Label
$labelOutput.Text = "Output PDF Path:"
$labelOutput.Location = New-Object Drawing.Point(10,80)
$labelOutput.Size = New-Object Drawing.Size(160,40)
$labelOutput.Font = New-Object Drawing.Font("Microsoft Sans Serif", 12)
$form.Controls.Add($labelOutput)

$textBoxOutput = New-Object Windows.Forms.TextBox
$textBoxOutput.Location = New-Object Drawing.Point(180,80)
$textBoxOutput.Size = New-Object Drawing.Size(300,40)
$textBoxOutput.Font = New-Object Drawing.Font("Microsoft Sans Serif", 12)
$form.Controls.Add($textBoxOutput)

$buttonSelectOutput = New-Object Windows.Forms.Button
$buttonSelectOutput.Text = "Select File"
$buttonSelectOutput.Location = New-Object Drawing.Point(500,80)
$buttonSelectOutput.Size = New-Object Drawing.Size(80,40)
$form.Controls.Add($buttonSelectOutput)

$buttonSelectOutput.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*"
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxOutput.Text = $saveFileDialog.FileName
    }
})

$buttonConvert = New-Object Windows.Forms.Button
$buttonConvert.Text = "Convert"
$buttonConvert.Location = New-Object Drawing.Point(250,140)
$buttonConvert.Size = New-Object Drawing.Size(100,40)
$buttonConvert.Font = New-Object Drawing.Font("Microsoft Sans Serif", 12)
$form.Controls.Add($buttonConvert)

$buttonConvert.Add_Click({
    $zipFile = $textBoxZip.Text
    $outputFile = $textBoxOutput.Text

    if ([string]::IsNullOrWhiteSpace($zipFile) -or [string]::IsNullOrWhiteSpace($outputFile)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter both the zip file path and the output PDF path.", "Input Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $scriptPath = "bin\convert_images_to_pdf.ps1"
    $arguments = "-zipFile `"$zipFile`" -outputFile `"$outputFile`""

    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" $arguments"

    $form.Close()
})

$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
