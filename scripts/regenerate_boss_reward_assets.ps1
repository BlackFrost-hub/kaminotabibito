Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$outDir = Join-Path $root "imports\UI\BossReward"

function New-ArgbBitmap([int]$width, [int]$height) {
    $bmp = New-Object System.Drawing.Bitmap $width, $height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::FromArgb(0, 0, 0, 0))
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    return @($bmp, $g)
}

function New-Brush([int]$a, [int]$r, [int]$g, [int]$b) {
    return New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($a, $r, $g, $b))
}

function New-Pen([int]$a, [int]$r, [int]$g, [int]$b, [float]$w = 1.0) {
    $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb($a, $r, $g, $b)), $w
    $pen.Alignment = [System.Drawing.Drawing2D.PenAlignment]::Center
    return $pen
}

function Add-Polygon($path, [int[]]$points) {
    $pts = New-Object System.Drawing.PointF[] ($points.Length / 2)
    for ($i = 0; $i -lt $points.Length; $i += 2) {
        $pts[$i / 2] = New-Object System.Drawing.PointF ([float]$points[$i]), ([float]$points[$i + 1])
    }
    $path.AddPolygon($pts)
}

function Draw-IconFrame($g, [int]$x, [int]$y, [string]$tone) {
    $shadow = New-Brush 150 0 0 0
    $g.FillRectangle($shadow, $x + 1, $y + 2, 47, 47)
    $shadow.Dispose()

    $outer = New-Brush 245 18 20 21
    $g.FillRectangle($outer, $x, $y, 47, 48)
    $outer.Dispose()

    $steel = New-Pen 230 78 81 78 2
    $dark = New-Pen 255 7 8 9 2
    $gold = New-Pen 230 126 94 38 1
    $hi = New-Pen 210 184 151 78 1
    $g.DrawRectangle($steel, $x + 2, $y + 2, 42, 43)
    $g.DrawRectangle($dark, $x + 5, $y + 5, 36, 37)
    $g.DrawRectangle($gold, $x + 8, $y + 8, 30, 31)
    $g.DrawLine($hi, $x + 9, $y + 8, $x + 38, $y + 8)
    $g.DrawLine($hi, $x + 8, $y + 9, $x + 8, $y + 38)
    $steel.Dispose(); $dark.Dispose(); $gold.Dispose(); $hi.Dispose()

    if ($tone -eq "blue") {
        $bg = New-Brush 230 10 20 42
        $g.FillRectangle($bg, $x + 10, $y + 10, 27, 28)
        $bg.Dispose()
    } else {
        $bg = New-Brush 230 25 22 17
        $g.FillRectangle($bg, $x + 10, $y + 10, 27, 28)
        $bg.Dispose()
    }
}

function Draw-AttributeIcon($g, [int]$x, [int]$y) {
    Draw-IconFrame $g $x $y "gold"

    $goldDark = New-Brush 245 102 77 34
    $goldMid = New-Brush 245 166 126 54
    $goldLight = New-Brush 245 218 184 96
    $ink = New-Pen 220 28 20 10 1
    $light = New-Pen 220 230 197 112 1

    $hornLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    Add-Polygon $hornLeft @(
        ($x + 21), ($y + 16),
        ($x + 11), ($y + 15),
        ($x + 7), ($y + 21),
        ($x + 17), ($y + 23)
    )
    $hornRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    Add-Polygon $hornRight @(
        ($x + 25), ($y + 16),
        ($x + 35), ($y + 15),
        ($x + 39), ($y + 21),
        ($x + 29), ($y + 23)
    )
    $g.FillPath($goldDark, $hornLeft)
    $g.FillPath($goldDark, $hornRight)
    $g.DrawPath($ink, $hornLeft)
    $g.DrawPath($ink, $hornRight)
    $hornLeft.Dispose(); $hornRight.Dispose()

    $mask = New-Object System.Drawing.Drawing2D.GraphicsPath
    Add-Polygon $mask @(
        ($x + 23), ($y + 11),
        ($x + 31), ($y + 18),
        ($x + 29), ($y + 29),
        ($x + 23), ($y + 37),
        ($x + 17), ($y + 29),
        ($x + 15), ($y + 18)
    )
    $g.FillPath($goldMid, $mask)
    $g.DrawPath($ink, $mask)
    $mask.Dispose()

    $face = New-Object System.Drawing.Drawing2D.GraphicsPath
    Add-Polygon $face @(
        ($x + 23), ($y + 15),
        ($x + 27), ($y + 22),
        ($x + 25), ($y + 31),
        ($x + 23), ($y + 34),
        ($x + 21), ($y + 31),
        ($x + 19), ($y + 22)
    )
    $g.FillPath($goldLight, $face)
    $g.DrawPath($ink, $face)
    $face.Dispose()

    $g.DrawLine($light, $x + 23, $y + 12, $x + 23, $y + 34)
    $g.DrawLine($ink, $x + 17, $y + 23, $x + 21, $y + 23)
    $g.DrawLine($ink, $x + 25, $y + 23, $x + 29, $y + 23)
    $g.DrawArc((New-Pen 230 185 142 58 1), $x + 13, $y + 15, 20, 18, 205, 130)

    $goldDark.Dispose(); $goldMid.Dispose(); $goldLight.Dispose(); $ink.Dispose(); $light.Dispose()
}

function Draw-EffectIcon($g, [int]$x, [int]$y) {
    Draw-IconFrame $g $x $y "blue"
    $blue = New-Pen 240 86 126 194 2
    $pale = New-Pen 240 211 230 255 1
    $glow = New-Brush 80 68 122 220
    $g.FillEllipse($glow, $x + 14, $y + 14, 19, 19)
    $glow.Dispose()
    $cx = $x + 23
    $cy = $y + 24
    $g.DrawLine($blue, $cx, $y + 12, $cx, $y + 36)
    $g.DrawLine($blue, $x + 11, $cy, $x + 35, $cy)
    $g.DrawLine($pale, $x + 15, $y + 16, $x + 31, $y + 32)
    $g.DrawLine($pale, $x + 31, $y + 16, $x + 15, $y + 32)
    $g.DrawEllipse($pale, $x + 20, $y + 21, 6, 6)
    $blue.Dispose(); $pale.Dispose()
}

function Draw-HeaderText($g, [string]$text, [int]$x, [int]$y) {
    $family = New-Object System.Drawing.FontFamily "Microsoft YaHei UI"
    $format = New-Object System.Drawing.StringFormat
    $format.FormatFlags = [System.Drawing.StringFormatFlags]::NoWrap
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddString($text, $family, [int][System.Drawing.FontStyle]::Bold, 36, (New-Object System.Drawing.PointF -ArgumentList @([float]$x, [float]$y)), $format)

    $matrix = New-Object System.Drawing.Drawing2D.Matrix
    $matrix.Translate(3, 3)
    $shadowPath = $path.Clone()
    $shadowPath.Transform($matrix)

    $shadowBrush = New-Brush 175 31 18 3
    $outerPen = New-Pen 225 75 43 6 4
    $innerPen = New-Pen 210 122 79 18 2
    $goldBrush = New-Brush 255 229 187 82
    $highlightPen = New-Pen 120 255 228 133 1

    $g.FillPath($shadowBrush, $shadowPath)
    $g.DrawPath($outerPen, $path)
    $g.FillPath($goldBrush, $path)
    $g.DrawPath($innerPen, $path)
    $g.DrawLine($highlightPen, $x + 5, $y + 5, $x + 54, $y + 5)

    $family.Dispose(); $format.Dispose(); $path.Dispose(); $shadowPath.Dispose(); $matrix.Dispose()
    $shadowBrush.Dispose(); $outerPen.Dispose(); $innerPen.Dispose(); $goldBrush.Dispose(); $highlightPen.Dispose()
}

function Draw-EngravedDivider($g, [int]$x1, [int]$y, [int]$x2) {
    $wideShadow = New-Pen 105 0 0 0 4
    $shadow = New-Pen 185 4 4 4 2
    $cut = New-Pen 205 18 15 10 1
    $topHi = New-Pen 35 82 76 62 1
    $capDark = New-Brush 235 10 10 9
    $capGold = New-Pen 55 111 93 55 1

    $g.DrawLine($wideShadow, $x1, $y + 2, $x2, $y + 2)
    $g.DrawLine($shadow, $x1, $y + 1, $x2, $y + 1)
    $g.DrawLine($cut, $x1 + 1, $y - 1, $x2 - 1, $y - 1)
    $g.DrawLine($topHi, $x1 + 6, $y - 3, $x2 - 6, $y - 3)

    foreach ($x in @($x1, $x2)) {
        $dir = if ($x -eq $x1) { 1 } else { -1 }
        $pts = @(
            (New-Object System.Drawing.PointF ([float]$x), ([float]($y - 4))),
            (New-Object System.Drawing.PointF ([float]($x + 7 * $dir)), ([float]$y)),
            (New-Object System.Drawing.PointF ([float]$x), ([float]($y + 4))),
            (New-Object System.Drawing.PointF ([float]($x - 2 * $dir)), ([float]$y))
        )
        $g.FillPolygon($capDark, $pts)
        $g.DrawPolygon($capGold, $pts)
    }

    $wideShadow.Dispose(); $shadow.Dispose(); $cut.Dispose(); $topHi.Dispose(); $capDark.Dispose(); $capGold.Dispose()
}

function Draw-VerticalDivider($g, [int]$x, [int]$y1, [int]$y2) {
    $shadow = New-Pen 85 0 0 0 3
    $cut = New-Pen 135 35 25 12 2
    $hi = New-Pen 32 140 101 42 1
    $g.DrawLine($shadow, $x + 2, $y1, $x + 2, $y2)
    $g.DrawLine($cut, $x, $y1, $x, $y2)
    $g.DrawLine($hi, $x - 2, $y1 + 3, $x - 2, $y2 - 3)
    $shadow.Dispose(); $cut.Dispose(); $hi.Dispose()
}

function Draw-DetailOverlay() {
    $items = New-ArgbBitmap 1672 941
    $bmp = $items[0]; $g = $items[1]

    Draw-AttributeIcon $g 755 365
    Draw-EffectIcon $g 755 615

    Draw-HeaderText $g "$([char]0x5C5E)$([char]0x6027)" 742 414
    Draw-HeaderText $g "$([char]0x7279)$([char]0x6548)" 742 664
    Draw-EngravedDivider $g 814 594 1496

    Save-ImagePair $bmp "boss_reward_detail_overlay"
    $g.Dispose(); $bmp.Dispose()
}

function Draw-SelectedBorder() {
    $items = New-ArgbBitmap 128 128
    $bmp = $items[0]; $g = $items[1]

    $shadow = New-Pen 120 0 0 0 4
    $goldDark = New-Pen 245 72 50 20 3
    $gold = New-Pen 245 151 108 40 2
    $goldHi = New-Pen 230 218 181 80 1
    $innerDim = New-Pen 205 39 28 12 1

    $g.DrawRectangle($shadow, 3, 3, 122, 122)
    $g.DrawRectangle($goldDark, 5, 5, 118, 118)
    $g.DrawRectangle($gold, 8, 8, 112, 112)
    $g.DrawRectangle($goldHi, 10, 10, 108, 108)
    $g.DrawRectangle($innerDim, 13, 13, 102, 102)

    $corner = New-Pen 235 219 181 80 2
    foreach ($cx in @(8, 120)) {
        $dir = if ($cx -lt 64) { 1 } else { -1 }
        $g.DrawLine($corner, $cx, 8, $cx + 18 * $dir, 8)
        $g.DrawLine($corner, $cx, 8, $cx, 26)
        $g.DrawLine($corner, $cx, 120, $cx + 18 * $dir, 120)
        $g.DrawLine($corner, $cx, 120, $cx, 102)
    }

    $shadow.Dispose(); $goldDark.Dispose(); $gold.Dispose(); $goldHi.Dispose(); $innerDim.Dispose(); $corner.Dispose()
    Save-ImagePair $bmp "reward_selected_border"
    $g.Dispose(); $bmp.Dispose()
}

function Draw-CheckBadge() {
    $items = New-ArgbBitmap 96 96
    $bmp = $items[0]; $g = $items[1]

    $shadow = New-Brush 120 0 0 0
    $g.FillRectangle($shadow, 15, 17, 58, 58)
    $shadow.Dispose()

    $bg = New-Brush 245 14 13 10
    $g.FillRectangle($bg, 13, 13, 56, 56)
    $bg.Dispose()

    $steel = New-Pen 245 48 32 12 4
    $goldDark = New-Pen 245 90 61 20 3
    $gold = New-Pen 225 151 108 40 2
    $hi = New-Pen 200 207 171 78 1
    $g.DrawRectangle($steel, 13, 13, 56, 56)
    $g.DrawRectangle($goldDark, 17, 17, 48, 48)
    $g.DrawRectangle($gold, 21, 21, 40, 40)
    $g.DrawLine($hi, 22, 21, 61, 21)
    $g.DrawLine($hi, 21, 22, 21, 61)

    $checkShadow = New-Pen 190 0 0 0 7
    $check = New-Pen 255 199 156 66 5
    $check.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $check.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $check.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $checkShadow.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $checkShadow.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $checkShadow.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pts = @(24, 46, 37, 58, 59, 31)
    $g.DrawLines($checkShadow, @(
        (New-Object System.Drawing.PointF $pts[0], $pts[1]),
        (New-Object System.Drawing.PointF $pts[2], $pts[3]),
        (New-Object System.Drawing.PointF $pts[4], $pts[5])
    ))
    $g.DrawLines($check, @(
        (New-Object System.Drawing.PointF $pts[0], $pts[1]),
        (New-Object System.Drawing.PointF $pts[2], $pts[3]),
        (New-Object System.Drawing.PointF $pts[4], $pts[5])
    ))

    $steel.Dispose(); $goldDark.Dispose(); $gold.Dispose(); $hi.Dispose(); $checkShadow.Dispose(); $check.Dispose()
    Save-ImagePair $bmp "reward_check_badge"
    $g.Dispose(); $bmp.Dispose()
}

function Save-Tga32($bmp, [string]$path) {
    $fs = [System.IO.File]::Open($path, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
    try {
        $w = $bmp.Width
        $h = $bmp.Height
        $header = New-Object byte[] 18
        $header[2] = 2
        $header[12] = [byte]($w -band 0xff)
        $header[13] = [byte](($w -shr 8) -band 0xff)
        $header[14] = [byte]($h -band 0xff)
        $header[15] = [byte](($h -shr 8) -band 0xff)
        $header[16] = 32
        $header[17] = 40
        $fs.Write($header, 0, 18)

        $bytes = New-Object byte[] ($w * $h * 4)
        $i = 0
        for ($y = 0; $y -lt $h; $y++) {
            for ($x = 0; $x -lt $w; $x++) {
                $c = $bmp.GetPixel($x, $y)
                $bytes[$i++] = $c.B
                $bytes[$i++] = $c.G
                $bytes[$i++] = $c.R
                $bytes[$i++] = $c.A
            }
        }
        $fs.Write($bytes, 0, $bytes.Length)
    } finally {
        $fs.Dispose()
    }
}

function Save-ImagePair($bmp, [string]$name) {
    $png = Join-Path $outDir "$name.png"
    $tga = Join-Path $outDir "$name.tga"
    $bmp.Save($png, [System.Drawing.Imaging.ImageFormat]::Png)
    Save-Tga32 $bmp $tga
}

Draw-DetailOverlay
Draw-SelectedBorder
Draw-CheckBadge

Write-Host "Regenerated BossReward UI assets."
