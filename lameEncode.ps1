function LameEncode {
    $mp3files = Get-ChildItem -Path .\ -Filter *.wav
    Foreach ($mp3file In $mp3files)
    {
        $mp3file = $outputFile = Split-Path $mp3file -leaf
        & "lame.exe" -V 0 -b 160 --vbr-new $mp3file "$mp3file.mp3"
    }
}
