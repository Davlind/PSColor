# Helper method to write file length in a more human readable format
function Write-FileLength {
    param (
        $length
    )

    if ($length -eq $null) {
        return ""
    } elseif ($length -ge 1GB) {
        return ($length / 1GB).ToString("F") + 'GB'
    } elseif ($length -ge 1MB) {
        return ($length / 1MB).ToString("F") + 'MB'
    } elseif ($length -ge 1KB) {
        return ($length / 1KB).ToString("F") + 'KB'
    }

    return $length.ToString() + '  '
}

# Outputs a line of a DirectoryInfo or FileInfo
function Write-Color-LS {
    param (
        [string]$color = "white",
        $file
    )

    $length = if ($file -is [System.IO.DirectoryInfo]) { $null } else { $file.length }
    Write-host ("{0,-7}      {1,10}  {2,8}  {3,13} {4}" -f `
        $file.mode, `
        $file.LastWriteTime.ToString("d"), `
        $file.LastWriteTime.ToString("t"), `
        (Write-FileLength $length $global:PSColor.HumanReadableFileLength), `
        $file.name) -foregroundcolor $color
}

function FileInfo {
    param (
        [Parameter(Mandatory=$True,Position=1)] [System.IO.FileSystemInfo] $file
    )

    $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $hidden = New-Object System.Text.RegularExpressions.Regex(
        $global:PSColor.File.Hidden.Pattern, $regex_opts)
    $code = New-Object System.Text.RegularExpressions.Regex(
        $global:PSColor.File.Code.Pattern, $regex_opts)
    $executable = New-Object System.Text.RegularExpressions.Regex(
        $global:PSColor.File.Executable.Pattern, $regex_opts)
    $text_files = New-Object System.Text.RegularExpressions.Regex(
        $global:PSColor.File.Text.Pattern, $regex_opts)
    $compressed = New-Object System.Text.RegularExpressions.Regex(
        $global:PSColor.File.Compressed.Pattern, $regex_opts)

    if ($file -is [System.IO.DirectoryInfo]) {
        $currentdir = $file.Parent.FullName
    } else {
        $currentdir = $file.DirectoryName
    }

    if ($script:directory -ne $currentdir) {
       $script:directory = $currentdir
       Write-Host
       Write-Host "    Directory: " -noNewLine
       Write-Host " $currentdir`n" -foregroundcolor "Green"
       Write-Host "Mode                LastWriteTime     Length Name"
       Write-Host "----                -------------     ------ ----"
    }

    if ($hidden.IsMatch($file.Name)) {
        Write-Color-LS $global:PSColor.File.Hidden.Color $file
    } elseif ($file -is [System.IO.DirectoryInfo]) {
        Write-Color-LS $global:PSColor.File.Directory.Color $file
    } elseif ($code.IsMatch($file.Name)) {
        Write-Color-LS $global:PSColor.File.Code.Color $file
    } elseif ($executable.IsMatch($file.Name)) {
        Write-Color-LS $global:PSColor.File.Executable.Color $file
    } elseif ($text_files.IsMatch($file.Name)) {
        Write-Color-LS $global:PSColor.File.Text.Color $file
    } elseif ($compressed.IsMatch($file.Name)) {
        Write-Color-LS $global:PSColor.File.Compressed.Color $file
    } else {
        Write-Color-LS $global:PSColor.File.Default.Color $file
    }
}
