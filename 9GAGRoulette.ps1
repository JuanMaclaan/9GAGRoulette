# =======================================================
# NAME: 9GAGRoulette.PS1
# AUTHOR:https://github.com/schokapyk
# DATE: 19/10/2019
#
#
# VERSION 1.0
# COMMENTS: Access to random post/section from 9gag.com
#
# =======================================================


##Random 9gag

##Variables

$9gag = invoke-webrequest "https://9gag.com/" -UseBasicParsing

##Function

##Function randompost (9gag have already a link to do that)
Function randompost {  Start-Process -FilePath "http://bit.ly/3231YVs"}

##Function randomsection
Function randomsection {
	$randomsec = Get-Random ($9gag.AllElements | Where {$_.class -eq "badge-upload-section-list-item-selector selector"} | select data-url)
	Start-Process -FilePath "https://9gag.com/$($randomsec."data-url")"
}

##Function randompopular

Function randompopular {

	$num = Get-Random -minimum 1 -maximum 4

	Switch ($num) {
		1 {$popular = "hot"}
		2 {$popular = "trending"}
		3 {$popular = "fresh"}
}

	Start-Process -FilePath "https://9gag.com/$($popular)"

}

##Function Hide-Console

function Hide-Console
{
    # Hide PowerShell Console
	Add-Type -Name Window -Namespace Console -MemberDefinition '
	[DllImport("Kernel32.dll")]
	public static extern IntPtr GetConsoleWindow();
	[DllImport("user32.dll")]
	public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
	'
	$consolePtr = [Console.Window]::GetConsoleWindow()
	[Console.Window]::ShowWindow($consolePtr, 0)
}

##Function GUI 

function GUI {


 Add-Type -AssemblyName System.Windows.Forms
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Form")

$9GAGRoulette = New-Object system.Windows.Forms.Form
$9GAGRoulette.Size = New-Object System.Drawing.Size(300,300)
$9GAGRoulette.FormBorderStyle = "FixedDialog"
$9GAGRoulette.MaximizeBox = $false
$9GAGRoulette.MinimizeBox = $true
$9GAGRoulette.StartPosition	= "CenterScreen"
$9GAGRoulette.text = "9GAG-Roulette"
$9GAGRoulette.BackColor = "#ffffff"
$9GAGRoulette.TopMost = $tru

$POP = New-Object system.Windows.Forms.Button
$POP.BackColor = "#000000"
$POP.text = "POPULAR"
$POP.location = New-Object System.Drawing.Size(40,20)
$POP.Size = New-Object System.Drawing.Size(200,60)
$POP.Font = 'Segoe UI,13,style=Bold'
$POP.ForeColor = "#ffffff"
$POP.Add_Click({randompopular})
$9GAGRoulette.Controls.add($POP)

$Section = New-Object system.Windows.Forms.Button
$Section.BackColor = "#000000"
$Section.text = "Ramdom Section"
$Section.location = New-Object System.Drawing.Size(40,100)
$Section.Size = New-Object System.Drawing.Size(200,60)
$Section.Font = 'Segoe UI,13,style=Bold'
$Section.ForeColor = "#ffffff"
$Section.Add_Click({randomsection})
$9GAGRoulette.Controls.add($Section)

$Post = New-Object system.Windows.Forms.Button
$Post.BackColor = "#000000"
$Post.text = "Random Post"
$Post.location = New-Object System.Drawing.Size(40,180)
$Post.Size = New-Object System.Drawing.Size(200,60)
$Post.Font = 'Segoe UI,13,style=Bold'
$Post.ForeColor = "#ffffff"
$Post.Add_Click({randompost})
$9GAGRoulette.Controls.add($Post)

##Show Form
$9GAGRoulette.Add_Shown({
    $9GAGRoulette.Activate()
    Hide-Console
})
[void] $9GAGRoulette.showdialog()
}

##Run GUI Function
GUI