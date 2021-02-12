function LameSwapChannel {
    $mp3files = Get-ChildItem -Path .\ -Filter *.mp3
    Foreach ($mp3file In $mp3files)
    {
        $mp3file = $outputFile = Split-Path $mp3file -leaf
        & "lame.exe" -V 0 -b 160 --vbr-new --swap-channel $mp3file "$mp3file.tmp"
        Move-Item "$mp3file.tmp" "$mp3file" -force
    }
}
