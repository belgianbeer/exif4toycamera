# デフォルト値
$offset = "+09:00"
$orientation = "Horizontal"

# ファイルリスト格納用
$files = @()

# 引数を順に処理
for ($i = 0; $i -lt $args.Count; $i++) {
    switch -Regex ($args[$i]) {
        "^-z$" {
            # 次の引数をオフセット値として取得
            if ($i + 1 -lt $args.Count) {
                $offset = $args[$i + 1]
                $i++  # 次の要素を消費
            } else {
                Write-Host "-z オプションには値が必要です"
                exit 1
            }
        }
        "^-r$" { $orientation = "Rotate 90 CW" }
        "^-l$" { $orientation = "Rotate 270 CW" }
        default { $files += $args[$i] }
    }
}

if ($files.Count -eq 0) {
    Write-Host "JPEG ファイルを指定してください。"
    exit 1
}

# exiftool 実行
exiftool -quiet -preserve -overwrite_original `
    -DateTimeOriginal'<FileModifyDate' `
    -OffsetTimeOriginal="$offset" `
    -Make=3COINS `
    -Model='MINI TOY CAMERA 2513/KRTC' `
    -Orientation="$orientation" `
    $files
