# =======================================================
# NAME: 9GAGRoulette.PS1
# AUTHOR:https://github.com/schokapyk
# DATE: 19/10/2019
#
#
# VERSION 1.1
# COMMENTS: Access to random post/section from 9gag.com
# SPECIAL THANKS TO : https://github.com/Hei5enberg44
# =======================================================

# =======================================================
#                       Variables
# =======================================================
$9sec = @("france", "funny", "animals", "anime-manga", "animewaifu", "awesome", "car", "comic-webtoon", "cosplay", "gaming", "girl", "girlcelebrity", "leagueoflegends", "meme", "nsfw", "politics", "relationship", "savage", "wtf", "animewallpaper", "apexlegends", "ask9gag", "countryballs", "home-living", "crappydesign", "drawing-diy-crafts", "food-drinks", "football", "fortnite", "got", "guy", "history", "horror", "kpop", "timely", "lego", "superhero", "movie-tv", "music", "basketball", "overwatch", "pcmr", "pokemon", "pubg", "satisfying", "science-tech", "sport", "starwars", "school", "rate-my-outfit", "travel-photography", "wallpaper", "warhammer", "wholesome", "darkhumor")
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$file = "$($ScriptDir)\9GAGRoulette.ps1"
$script:i = 0
$script:o = 0
# ======================================================
#                       Functions
# ======================================================

## For that function use 2 parameters, the line you want to replace in the script and the content you want to use to replace the line
Function majsections ($find) {

$findline = $((Get-Content $file)[$find])
(Get-Content $file).replace($findline,$($findline.substring(0,10)+$sections+")")) | Set-Content $file
$script:i++
}

##Template
Function majscript($find,$replace) {

$findline = $((Get-Content $file)[$find])
(Get-Content $file).replace($findline,$replace) | Set-Content $file
$i++
}


##Function randompost (9gag have already a link to do that)
Function randompost {  Start-Process -FilePath "http://bit.ly/3231YVs"}

##Function randomsection
Function randomsection {
    
    #If the check box "Update Section List" is check and the var $script:o is not -eq to 0, it will request the section list from 9gag.com, else it use $9sec
    if ($checkbox1.checked -and $script:o -eq 0) {
        $9gag = invoke-webrequest "https://9gag.com/"
                if ($9gag -is [int]) {
                     $gag = invoke-webrequest "https://9gag.com/" -UseBasicParsing
                }
                $9gagsec = $9gag.AllElements | Where {$_.class -eq "badge-upload-section-list-item-selector selector"} | select data-url | ForEach { $_."data-url" }
                    $array = @()
	                Foreach ($sec in $9gagsec) {
                    $array += """" + $sec + """"
                    }
                    $sections = [system.String]::Join(", ", $array)
                    $script:o++           
    }
                     
    Else{
        $9gagsec = $9sec
    }
        
        $randomsec = $9gagsec | get-random
        
        Start-Process -FilePath "https://9gag.com/$($randomsec)"
     #This part update the section list in the script file
     if ($checkbox1.checked) {
        if ($script:i -eq 0){
        majsections 14
        }
     }

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

$checkbox1 = new-object System.Windows.Forms.checkbox
$checkbox1.Location = new-object System.Drawing.Size(40,0)
$checkbox1.Text = "Update Section"
$checkbox1.Checked = $false
$9GAGRoulette.Controls.Add($checkbox1)

##Show Form
$9GAGRoulette.Add_Shown({
    $9GAGRoulette.Activate()
    Hide-Console
})
[void] $9GAGRoulette.showdialog()
}

##Run GUI Function
GUI
