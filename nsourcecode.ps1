Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class NativeMethods
{
    [DllImport("user32.dll")]
    public static extern bool ReleaseCapture();

    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(
        IntPtr hWnd,
        int Msg,
        IntPtr wParam,
        IntPtr lParam
    );

    [DllImport("user32.dll")]
    public static extern bool DestroyIcon(IntPtr handle);

    public const int WM_NCLBUTTONDOWN = 0xA1;
    public const int HTCAPTION = 0x2;
}
"@

function New-RoundedRegion {
    param(
        [int]$Width,
        [int]$Height,
        [int]$Radius = 14
    )

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath

    $diameter = $Radius * 2

    $path.AddArc(
        0,
        0,
        $diameter,
        $diameter,
        180,
        90
    )

    $path.AddArc(
        $Width - $diameter,
        0,
        $diameter,
        $diameter,
        270,
        90
    )

    $path.AddArc(
        $Width - $diameter,
        $Height - $diameter,
        $diameter,
        $diameter,
        0,
        90
    )

    $path.AddArc(
        0,
        $Height - $diameter,
        $diameter,
        $diameter,
        90,
        90
    )

    $path.CloseFigure()

    return New-Object System.Drawing.Region($path)
}

function Open-WebLink {
    param(
        [string]$Url
    )

    try {
        Start-Process $Url
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Tidak dapat membuka link.",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}

$bgColor = [System.Drawing.Color]::FromArgb(15, 15, 19)
$titleBarColor = [System.Drawing.Color]::FromArgb(22, 22, 28)
$cardColor = [System.Drawing.Color]::FromArgb(27, 27, 34)
$inputColor = [System.Drawing.Color]::FromArgb(36, 36, 44)
$borderColor = [System.Drawing.Color]::FromArgb(52, 52, 62)

$textColor = [System.Drawing.Color]::FromArgb(245, 245, 248)
$secondaryText = [System.Drawing.Color]::FromArgb(155, 155, 170)

$accentColor = [System.Drawing.Color]::FromArgb(75, 125, 235)
$accentHover = [System.Drawing.Color]::FromArgb(95, 145, 255)

$dangerColor = [System.Drawing.Color]::FromArgb(235, 75, 85)
$dangerHover = [System.Drawing.Color]::FromArgb(255, 90, 100)

$successColor = [System.Drawing.Color]::FromArgb(75, 200, 125)

$form = New-Object System.Windows.Forms.Form

$form.Text = "Windows Notification Sender"

$form.Size = New-Object System.Drawing.Size(620, 680)

$form.StartPosition = "CenterScreen"

$form.FormBorderStyle = "None"

$form.MaximizeBox = $false

$form.MinimizeBox = $true

$form.BackColor = $bgColor

$form.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    10
)

$form.DoubleBuffered = $true

$form.Region = New-RoundedRegion 620 680 16


$notifyIcon = New-Object System.Windows.Forms.NotifyIcon

$notifyIcon.Icon = [System.Drawing.SystemIcons]::Information

$notifyIcon.Visible = $true

$notifyIcon.Text = "Windows Notification Sender"


$titleBar = New-Object System.Windows.Forms.Panel

$titleBar.Location = New-Object System.Drawing.Point(0, 0)

$titleBar.Size = New-Object System.Drawing.Size(620, 52)

$titleBar.BackColor = $titleBarColor

$titleBar.Region = New-RoundedRegion 620 52 16

$form.Controls.Add($titleBar)


$appIcon = New-Object System.Windows.Forms.PictureBox

$appIcon.Location = New-Object System.Drawing.Point(18, 15)

$appIcon.Size = New-Object System.Drawing.Size(22, 22)

$appIcon.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

$appIcon.Image = [System.Drawing.SystemIcons]::Information.ToBitmap()

$titleBar.Controls.Add($appIcon)


$appTitle = New-Object System.Windows.Forms.Label

$appTitle.Text = "Notification Sender"

$appTitle.Location = New-Object System.Drawing.Point(50, 15)

$appTitle.Size = New-Object System.Drawing.Size(300, 23)

$appTitle.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    9.5,
    [System.Drawing.FontStyle]::Bold
)

$appTitle.ForeColor = $textColor

$appTitle.Cursor = [System.Windows.Forms.Cursors]::Default

$titleBar.Controls.Add($appTitle)


$minButton = New-Object System.Windows.Forms.Button

$minButton.Text = "—"

$minButton.Location = New-Object System.Drawing.Point(490, 0)

$minButton.Size = New-Object System.Drawing.Size(43, 52)

$minButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$minButton.FlatAppearance.BorderSize = 0

$minButton.BackColor = $titleBarColor

$minButton.ForeColor = $secondaryText

$minButton.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    12
)

$minButton.Cursor = [System.Windows.Forms.Cursors]::Hand

$titleBar.Controls.Add($minButton)


$maxButton = New-Object System.Windows.Forms.Button

$maxButton.Text = "□"

$maxButton.Location = New-Object System.Drawing.Point(533, 0)

$maxButton.Size = New-Object System.Drawing.Size(43, 52)

$maxButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$maxButton.FlatAppearance.BorderSize = 0

$maxButton.BackColor = $titleBarColor

$maxButton.ForeColor = $secondaryText

$maxButton.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    9
)

$maxButton.Cursor = [System.Windows.Forms.Cursors]::Hand

$titleBar.Controls.Add($maxButton)


$closeButton = New-Object System.Windows.Forms.Button

$closeButton.Text = "×"

$closeButton.Location = New-Object System.Drawing.Point(576, 0)

$closeButton.Size = New-Object System.Drawing.Size(44, 52)

$closeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$closeButton.FlatAppearance.BorderSize = 0

$closeButton.BackColor = $titleBarColor

$closeButton.ForeColor = $secondaryText

$closeButton.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    16
)

$closeButton.Cursor = [System.Windows.Forms.Cursors]::Hand

$titleBar.Controls.Add($closeButton)


$header = New-Object System.Windows.Forms.Label

$header.Text = "Notification Sender"

$header.Location = New-Object System.Drawing.Point(32, 78)

$header.Size = New-Object System.Drawing.Size(520, 40)

$header.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    22,
    [System.Drawing.FontStyle]::Bold
)

$header.ForeColor = $textColor

$form.Controls.Add($header)


$subtitle = New-Object System.Windows.Forms.Label

$subtitle.Text = "Create and send a Windows notification"

$subtitle.Location = New-Object System.Drawing.Point(35, 119)

$subtitle.Size = New-Object System.Drawing.Size(520, 25)

$subtitle.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    9.5
)

$subtitle.ForeColor = $secondaryText

$form.Controls.Add($subtitle)


$iconCard = New-Object System.Windows.Forms.Panel

$iconCard.Location = New-Object System.Drawing.Point(30, 160)

$iconCard.Size = New-Object System.Drawing.Size(560, 145)

$iconCard.BackColor = $cardColor

$iconCard.Region = New-RoundedRegion 560 145 14

$form.Controls.Add($iconCard)


$iconTitle = New-Object System.Windows.Forms.Label

$iconTitle.Text = "Notification Icon"

$iconTitle.Location = New-Object System.Drawing.Point(20, 15)

$iconTitle.Size = New-Object System.Drawing.Size(300, 27)

$iconTitle.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    11,
    [System.Drawing.FontStyle]::Bold
)

$iconTitle.ForeColor = $textColor

$iconCard.Controls.Add($iconTitle)


$iconPreview = New-Object System.Windows.Forms.PictureBox

$iconPreview.Location = New-Object System.Drawing.Point(20, 52)

$iconPreview.Size = New-Object System.Drawing.Size(58, 58)

$iconPreview.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

$iconPreview.BackColor = $inputColor

$iconPreview.Image = [System.Drawing.SystemIcons]::Information.ToBitmap()

$iconPreview.Region = New-RoundedRegion 58 58 10

$iconCard.Controls.Add($iconPreview)


$chooseIconButton = New-Object System.Windows.Forms.Button

$chooseIconButton.Text = "Choose Icon"

$chooseIconButton.Location = New-Object System.Drawing.Point(95, 56)

$chooseIconButton.Size = New-Object System.Drawing.Size(140, 48)

$chooseIconButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$chooseIconButton.FlatAppearance.BorderSize = 0

$chooseIconButton.BackColor = $accentColor

$chooseIconButton.ForeColor = [System.Drawing.Color]::White

$chooseIconButton.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    10,
    [System.Drawing.FontStyle]::Bold
)

$chooseIconButton.Cursor = [System.Windows.Forms.Cursors]::Hand

$chooseIconButton.Region = New-RoundedRegion 140 48 10

$iconCard.Controls.Add($chooseIconButton)


$iconPathLabel = New-Object System.Windows.Forms.Label

$iconPathLabel.Text = "Default Windows icon"

$iconPathLabel.Location = New-Object System.Drawing.Point(255, 66)

$iconPathLabel.Size = New-Object System.Drawing.Size(275, 40)

$iconPathLabel.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    9
)

$iconPathLabel.ForeColor = $secondaryText

$iconPathLabel.AutoEllipsis = $true

$iconCard.Controls.Add($iconPathLabel)


$notificationCard = New-Object System.Windows.Forms.Panel

$notificationCard.Location = New-Object System.Drawing.Point(30, 320)

$notificationCard.Size = New-Object System.Drawing.Size(560, 285)

$notificationCard.BackColor = $cardColor

$notificationCard.Region = New-RoundedRegion 560 285 14

$form.Controls.Add($notificationCard)


$notificationTitle = New-Object System.Windows.Forms.Label

$notificationTitle.Text = "Notification"

$notificationTitle.Location = New-Object System.Drawing.Point(20, 15)

$notificationTitle.Size = New-Object System.Drawing.Size(300, 27)

$notificationTitle.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    11,
    [System.Drawing.FontStyle]::Bold
)

$notificationTitle.ForeColor = $textColor

$notificationCard.Controls.Add($notificationTitle)


$titleLabel = New-Object System.Windows.Forms.Label

$titleLabel.Text = "Title"

$titleLabel.Location = New-Object System.Drawing.Point(20, 52)

$titleLabel.Size = New-Object System.Drawing.Size(100, 22)

$titleLabel.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    9
)

$titleLabel.ForeColor = $secondaryText

$notificationCard.Controls.Add($titleLabel)


$titleBox = New-Object System.Windows.Forms.TextBox

$titleBox.Location = New-Object System.Drawing.Point(20, 76)

$titleBox.Size = New-Object System.Drawing.Size(520, 34)

$titleBox.BackColor = $inputColor

$titleBox.ForeColor = $textColor

$titleBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

$titleBox.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    10
)

$titleBox.Text = "Nazmi"

$notificationCard.Controls.Add($titleBox)


$messageLabel = New-Object System.Windows.Forms.Label

$messageLabel.Text = "Message"

$messageLabel.Location = New-Object System.Drawing.Point(20, 120)

$messageLabel.Size = New-Object System.Drawing.Size(100, 22)

$messageLabel.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    9
)

$messageLabel.ForeColor = $secondaryText

$notificationCard.Controls.Add($messageLabel)


$messageBox = New-Object System.Windows.Forms.TextBox

$messageBox.Location = New-Object System.Drawing.Point(20, 144)

$messageBox.Size = New-Object System.Drawing.Size(520, 60)

$messageBox.Multiline = $true

$messageBox.ScrollBars = "Vertical"

$messageBox.BackColor = $inputColor

$messageBox.ForeColor = $textColor

$messageBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

$messageBox.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    10
)

$messageBox.Text = "Kapan balikan"

$notificationCard.Controls.Add($messageBox)


$sendButton = New-Object System.Windows.Forms.Button

$sendButton.Text = "SEND NOTIFICATION"

$sendButton.Location = New-Object System.Drawing.Point(20, 220)

$sendButton.Size = New-Object System.Drawing.Size(520, 45)

$sendButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$sendButton.FlatAppearance.BorderSize = 0

$sendButton.BackColor = $accentColor

$sendButton.ForeColor = [System.Drawing.Color]::White

$sendButton.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    10,
    [System.Drawing.FontStyle]::Bold
)

$sendButton.Cursor = [System.Windows.Forms.Cursors]::Hand

$sendButton.Region = New-RoundedRegion 520 45 10

$notificationCard.Controls.Add($sendButton)


$credit = New-Object System.Windows.Forms.Label

$credit.Text = "Created by robby5pryk-sudo (Afreldo)"

$credit.Location = New-Object System.Drawing.Point(30, 620)

$credit.Size = New-Object System.Drawing.Size(220, 22)

$credit.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    8.5
)

$credit.ForeColor = $secondaryText

$form.Controls.Add($credit)


$githubLink = New-Object System.Windows.Forms.LinkLabel

$githubLink.Text = "GitHub"

$githubLink.Location = New-Object System.Drawing.Point(255, 620)

$githubLink.Size = New-Object System.Drawing.Size(55, 22)

$githubLink.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    8.5,
    [System.Drawing.FontStyle]::Bold
)

$githubLink.LinkColor = $accentColor

$githubLink.ActiveLinkColor = $accentHover

$githubLink.Cursor = [System.Windows.Forms.Cursors]::Hand

$form.Controls.Add($githubLink)


$youtubeText = New-Object System.Windows.Forms.Label

$youtubeText.Text = " • "

$youtubeText.Location = New-Object System.Drawing.Point(307, 620)

$youtubeText.Size = New-Object System.Drawing.Size(20, 22)

$youtubeText.ForeColor = $secondaryText

$form.Controls.Add($youtubeText)


$youtubeLink = New-Object System.Windows.Forms.LinkLabel

$youtubeLink.Text = "YouTube"

$youtubeLink.Location = New-Object System.Drawing.Point(325, 620)

$youtubeLink.Size = New-Object System.Drawing.Size(70, 22)

$youtubeLink.Font = New-Object System.Drawing.Font(
    "Segoe UI Semibold",
    8.5,
    [System.Drawing.FontStyle]::Bold
)

$youtubeLink.LinkColor = [System.Drawing.Color]::FromArgb(
    235,
    80,
    90
)

$youtubeLink.ActiveLinkColor = dangerHover

$youtubeLink.Cursor = [System.Windows.Forms.Cursors]::Hand

$form.Controls.Add($youtubeLink)


$minButton.Add_MouseEnter({
    $minButton.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 48)
})

$minButton.Add_MouseLeave({
    $minButton.BackColor = $titleBarColor
})


$maxButton.Add_MouseEnter({
    $maxButton.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 48)
})

$maxButton.Add_MouseLeave({
    $maxButton.BackColor = $titleBarColor
})


$closeButton.Add_MouseEnter({
    $closeButton.BackColor = $dangerColor
    $closeButton.ForeColor = [System.Drawing.Color]::White
})

$closeButton.Add_MouseLeave({
    $closeButton.BackColor = $titleBarColor
    $closeButton.ForeColor = $secondaryText
})


$chooseIconButton.Add_MouseEnter({
    $chooseIconButton.BackColor = $accentHover
})

$chooseIconButton.Add_MouseLeave({
    $chooseIconButton.BackColor = $accentColor
})


$sendButton.Add_MouseEnter({
    $sendButton.BackColor = $accentHover
})

$sendButton.Add_MouseLeave({
    $sendButton.BackColor = $accentColor
})


$minButton.Add_Click({

    $form.WindowState = [System.Windows.Forms.FormWindowState]::Minimized

})


$maxButton.Add_Click({

    if ($form.WindowState -eq [System.Windows.Forms.FormWindowState]::Normal) {

        $form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized

        $maxButton.Text = "❐"

    }
    else {

        $form.WindowState = [System.Windows.Forms.FormWindowState]::Normal

        $maxButton.Text = "□"

    }

})


$closeButton.Add_Click({

    $form.Close()

})


$dragControls = @(
    $titleBar,
    $appIcon,
    $appTitle
)

foreach ($control in $dragControls) {

    $control.Add_MouseDown({

        if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left) {

            [NativeMethods]::ReleaseCapture()

            [NativeMethods]::SendMessage(
                $form.Handle,
                [NativeMethods]::WM_NCLBUTTONDOWN,
                [NativeMethods]::HTCAPTION,
                0
            ) | Out-Null

        }

    })

}


$githubUrl = "https" + "://github.com/robby5pryk-sudo"

$youtubeUrl = "https" + "://www.youtube.com/@BibzS4mpwats"


$githubLink.Add_LinkClicked({

    Open-WebLink $githubUrl

})


$youtubeLink.Add_LinkClicked({

    Open-WebLink $youtubeUrl

})


$chooseIconButton.Add_Click({

    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog

    $openFileDialog.Title = "Choose Notification Icon"

    $openFileDialog.Filter =
        "Image Files (*.ico;*.png;*.jpg;*.jpeg;*.bmp)|*.ico;*.png;*.jpg;*.jpeg;*.bmp|" +
        "Icon (*.ico)|*.ico|" +
        "PNG (*.png)|*.png|" +
        "JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg|" +
        "Bitmap (*.bmp)|*.bmp"

    $openFileDialog.Multiselect = $false

    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {

        $selectedPath = $openFileDialog.FileName

        $newIcon = $null
        $previewBitmap = $null
        $sourceBitmap = $null
        $graphics = $null

        try {

            if (
                [System.IO.Path]::GetExtension($selectedPath).ToLower() -eq ".ico"
            ) {

                $newIcon = New-Object System.Drawing.Icon($selectedPath)

                $previewBitmap = $newIcon.ToBitmap()

            }
            else {

                $sourceBitmap = New-Object System.Drawing.Bitmap(
                    $selectedPath
                )

                $iconBitmap = New-Object System.Drawing.Bitmap(
                    32,
                    32,
                    [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
                )

                $graphics = [System.Drawing.Graphics]::FromImage(
                    $iconBitmap
                )

                $graphics.Clear(
                    [System.Drawing.Color]::Transparent
                )

                $graphics.InterpolationMode =
                    [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

                $graphics.SmoothingMode =
                    [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

                $graphics.PixelOffsetMode =
                    [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

                $graphics.CompositingQuality =
                    [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

                $sourceWidth = $sourceBitmap.Width

                $sourceHeight = $sourceBitmap.Height

                $ratio = [Math]::Min(
                    32.0 / $sourceWidth,
                    32.0 / $sourceHeight
                )

                $drawWidth = [int]($sourceWidth * $ratio)

                $drawHeight = [int]($sourceHeight * $ratio)

                $drawX = [int]((32 - $drawWidth) / 2)

                $drawY = [int]((32 - $drawHeight) / 2)

                $graphics.DrawImage(
                    $sourceBitmap,
                    $drawX,
                    $drawY,
                    $drawWidth,
                    $drawHeight
                )

                $graphics.Dispose()

                $graphics = $null

                $hIcon = $iconBitmap.GetHicon()

                try {

                    $tempIcon = [System.Drawing.Icon]::FromHandle(
                        $hIcon
                    )

                    $newIcon = $tempIcon.Clone()

                    $tempIcon.Dispose()

                }
                finally {

                    [NativeMethods]::DestroyIcon(
                        $hIcon
                    ) | Out-Null

                }

                $previewBitmap = New-Object System.Drawing.Bitmap(
                    $iconBitmap
                )

                $iconBitmap.Dispose()

            }

            $oldIcon = $notifyIcon.Icon

            $notifyIcon.Icon = $newIcon

            $newIcon = $null

            $oldPreview = $iconPreview.Image

            $iconPreview.Image = $previewBitmap

            $previewBitmap = $null

            if ($oldPreview -ne $null) {

                $oldPreview.Dispose()

            }

            if ($oldIcon -ne $null) {

                $oldIcon.Dispose()

            }

            $appIcon.Image = $iconPreview.Image

            $iconPathLabel.Text = $selectedPath

        }
        catch {

            [System.Windows.Forms.MessageBox]::Show(
                "Failed to load the selected icon.`n`n$($_.Exception.Message)",
                "Icon Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error
            )

        }
        finally {

            if ($graphics -ne $null) {
                $graphics.Dispose()
            }

            if ($sourceBitmap -ne $null) {
                $sourceBitmap.Dispose()
            }

            if ($previewBitmap -ne $null) {
                $previewBitmap.Dispose()
            }

            if ($newIcon -ne $null) {
                $newIcon.Dispose()
            }

        }

    }

    $openFileDialog.Dispose()

})


$sendButton.Add_Click({

    $title = $titleBox.Text.Trim()

    $message = $messageBox.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($title)) {

        [System.Windows.Forms.MessageBox]::Show(
            "Title is required.",
            "Warning",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )

        $titleBox.Focus()

        return

    }

    if ([string]::IsNullOrWhiteSpace($message)) {

        [System.Windows.Forms.MessageBox]::Show(
            "Message is required.",
            "Warning",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )

        $messageBox.Focus()

        return

    }

    try {

        $notifyIcon.ShowBalloonTip(
            5000,
            $title,
            $message,
            [System.Windows.Forms.ToolTipIcon]::None
        )

    }
    catch {

        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            "Notification Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )

    }

})


$form.AcceptButton = $sendButton


$form.Add_FormClosed({

    $notifyIcon.Visible = $false

    $notifyIcon.Dispose()

    if ($iconPreview.Image -ne $null) {

        $iconPreview.Image.Dispose()

    }

    if ($appIcon.Image -ne $null) {

        $appIcon.Image.Dispose()

    }

})


[void]$form.ShowDialog()