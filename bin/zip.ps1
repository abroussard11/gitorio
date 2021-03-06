param(
  [string]$directory,
  [string]$output
)

#Load the assembly
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
#zip the file
[System.IO.Compression.ZipFile]::CreateFromDirectory($directory, $output, [System.IO.Compression.CompressionLevel]::Fastest, "true")
