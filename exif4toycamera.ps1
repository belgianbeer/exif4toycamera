#
#  exif4toycamera.ps1 - Adding Exif meta-data for 3COINS MINI TOY CAMERA
#
#  Copyright (c) 2025 Masato Minda
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
#  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
#  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
#  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#  SUCH DAMAGE.
#

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
	-AllDates'<FileModifyDate' `
	-OffsetTime="$offset" `
	-OffsetTimeOriginal="$offset" `
	-OffsetTimeDigitized="$offset" `
	-Make=3COINS `
	-Model='MINI TOY CAMERA 2513/KRTC' `
	-FocalLength='2.2mm'  `
	-FNumber='2.8' `
	-Orientation="$orientation" `
	$files
