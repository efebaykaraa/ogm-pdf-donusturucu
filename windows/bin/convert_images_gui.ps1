# Ensure the script runs with UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function SetLanguage {
    param (
        [string]$language
    )

    if ($language -eq "Turkce") {
        $form.Text = "Goruntuleri PDF'ye Donustur"
        $labelZip.Text = "Zip Dosya Yolu:"
        $labelOutput.Text = "Cikis PDF Yolu:"
        $buttonSelectZip.Text = "Dosya Sec"
        $buttonSelectOutput.Text = "Dosya Sec"
        $buttonConvert.Text = "Donustur"
        $messageInputError = "Lutfen hem zip dosya yolunu hem de Cikis PDF yolunu girin."
        $messageInputErrorTitle = "Giris Hatasi"
    } else {
        $form.Text = "Convert Images to PDF"
        $labelZip.Text = "Zip File Path:"
        $labelOutput.Text = "Output PDF Path:"
        $buttonSelectZip.Text = "Select File"
        $buttonSelectOutput.Text = "Select File"
        $buttonConvert.Text = "Convert"
        $messageInputError = "Please enter both the zip file path and the output PDF path."
        $messageInputErrorTitle = "Input Error"
    }
}

$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size(600,400)
$form.StartPosition = "CenterScreen"

$labelLanguage = New-Object Windows.Forms.Label
$labelLanguage.Text = "Dil / Language:"
$labelLanguage.Location = New-Object Drawing.Point(10,20)
$labelLanguage.Size = New-Object Drawing.Size(160,40)
$labelLanguage.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($labelLanguage)

$comboBoxLanguage = New-Object Windows.Forms.ComboBox
$comboBoxLanguage.Location = New-Object Drawing.Point(180,20)
$comboBoxLanguage.Size = New-Object Drawing.Size(300,40)
$comboBoxLanguage.Font = New-Object Drawing.Font("Arial", 12)
$comboBoxLanguage.Items.AddRange(@("Turkce", "English"))
$comboBoxLanguage.SelectedIndex = 0
$form.Controls.Add($comboBoxLanguage)

$labelZip = New-Object Windows.Forms.Label
$labelZip.Location = New-Object Drawing.Point(10,80)
$labelZip.Size = New-Object Drawing.Size(160,40)
$labelZip.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($labelZip)

$textBoxZip = New-Object Windows.Forms.TextBox
$textBoxZip.Location = New-Object Drawing.Point(180,80)
$textBoxZip.Size = New-Object Drawing.Size(300,40)
$textBoxZip.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($textBoxZip)

$buttonSelectZip = New-Object Windows.Forms.Button
$buttonSelectZip.Location = New-Object Drawing.Point(500,80)
$buttonSelectZip.Size = New-Object Drawing.Size(80,40)
$buttonSelectZip.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($buttonSelectZip)

$buttonSelectZip.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Zip Files (*.zip)|*.zip|All Files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxZip.Text = $openFileDialog.FileName
    }
})

$labelOutput = New-Object Windows.Forms.Label
$labelOutput.Location = New-Object Drawing.Point(10,140)
$labelOutput.Size = New-Object Drawing.Size(160,40)
$labelOutput.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($labelOutput)

$textBoxOutput = New-Object Windows.Forms.TextBox
$textBoxOutput.Location = New-Object Drawing.Point(180,140)
$textBoxOutput.Size = New-Object Drawing.Size(300,40)
$textBoxOutput.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($textBoxOutput)

$buttonSelectOutput = New-Object Windows.Forms.Button
$buttonSelectOutput.Location = New-Object Drawing.Point(500,140)
$buttonSelectOutput.Size = New-Object Drawing.Size(80,40)
$buttonSelectOutput.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($buttonSelectOutput)

$buttonSelectOutput.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "PDF Files (*.pdf)|*.pdf|All Files (*.*)|*.*"
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxOutput.Text = $saveFileDialog.FileName
    }
})

$buttonConvert = New-Object Windows.Forms.Button
$buttonConvert.Location = New-Object Drawing.Point(250,200)
$buttonConvert.Size = New-Object Drawing.Size(100,40)
$buttonConvert.Font = New-Object Drawing.Font("Arial", 12)
$form.Controls.Add($buttonConvert)

$buttonConvert.Add_Click({
    $zipFile = $textBoxZip.Text
    $outputFile = $textBoxOutput.Text

    if ([string]::IsNullOrWhiteSpace($zipFile) -or [string]::IsNullOrWhiteSpace($outputFile)) {
        [System.Windows.Forms.MessageBox]::Show($messageInputError, $messageInputErrorTitle, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $scriptPath = "bin\convert_images_to_pdf.ps1"
    $arguments = "-zipFile `"$zipFile`" -outputFile `"$outputFile`""

    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" $arguments"

    $form.Close()
})

$comboBoxLanguage.Add_SelectedIndexChanged({
    SetLanguage -language $comboBoxLanguage.SelectedItem
})

SetLanguage -language "Turkce"

$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
