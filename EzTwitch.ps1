# Copyright 2021 Kaur Kuut <admin@kaurkuut.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

param (
    $get,
    $name,
    $id,
    $start,
    $end
)

# Configuration - make sure this is filled out based on your setup!

# e.g. C:\Program Files\TwitchDownloader\TwitchDownloaderCLI.exe
$twitch_downloader_location = ""
# e.g. D:\Apps\ffmpeg\bin\ffmpeg.exe
$ffmpeg_location = ""

# Usage

function Help {
    Write-Output "`nUsage: ./EzTwitch [commands]

    Available commands:

    -get chat
        What to download, either 'chat' or 'video'.

    -id 123456
        The Twitch VOD id number, e.g. 123456.

    -start 01:02:34
        Start time, e.g. 1 hour 2 minutes and 34 seconds of the VOD.

    -end 02:03:55
        End time, e.g. 2 hours 3 minutes and 55 seconds of the VOD.

    -name `"My Project`"
        [Optional] Include your custom project name in the output filenames."
}

# Sanity check

Write-Output "[EzTwitch] Version 2.0.0 by Strom"

if ($twitch_downloader_location -eq "") {
    Help
    Write-Output "`n[Missing config] You need to provide the TwitchDownloaderCLI binary location!"
    exit
}

if ($ffmpeg_location -eq "") {
    Help
    Write-Output "`n[Missing config] You need to provide the ffmpeg binary location!"
    exit
}

if ($get -eq $null) {
    Help
    Write-Output "`n[Missing param] You need to choose what to download! (e.g. -get chat)"
    exit
}

if ($get -notmatch '^(chat|video)$') {
    Help
    Write-Output "`n[Invalid param] Unrecognized get request! (e.g. -get chat)"
    exit
}

if ($id -eq $null) {
    Help
    Write-Output "`n[Missing param] You need to provide a Twitch VOD id! (e.g. -id 123)"
    exit
}

if ($start -eq $null) {
    Help
    Write-Output "`n[Missing param] You need to provide a start timestamp! (e.g. -start 12:34:56)"
    exit
}

if ($start -notmatch '^(\d\d):(\d\d):(\d\d)$') {
    Help
    Write-Output "`n[Invalid param] The start timestamp is not in the correct format! (e.g. -start 12:34:56)"
    exit
}

if ($end -eq $null) {
    Help
    Write-Output "`n[Missing param] You need to provide an end timestamp! (e.g. -end 12:34:56)"
    exit
}

if ($end -notmatch '^(\d\d):(\d\d):(\d\d)$') {
    Help
    Write-Output "`n[Invalid param] The end timestamp is not in the correct format! (e.g. -end 12:34:56)"
    exit
}

# Code

$start_match = [regex]::Matches($start, '^(\d\d):(\d\d):(\d\d)$')[0]
$start_h = [int]$start_match.Groups[1].Value
$start_m = [int]$start_match.Groups[2].Value
$start_s = [int]$start_match.Groups[3].Value
$start_secs = $start_h * 3600 + $start_m * 60 + $start_s

$end_match = [regex]::Matches($end, '^(\d\d):(\d\d):(\d\d)$')[0]
$end_h = [int]$end_match.Groups[1].Value
$end_m = [int]$end_match.Groups[2].Value
$end_s = [int]$end_match.Groups[3].Value
$end_secs = $end_h * 3600 + $end_m * 60 + $end_s

$file_name = $get + " " + [string]$start_h + "." + [string]$start_m + "." + [string]$start_s + " - " + [string]$end_h + "." + [string]$end_m + "." + [string]$end_s
if ($name -ne $null) {
    $file_name = $name + " " + $file_name
} else {
    $file_name = [string]$id + " " + $file_name
}

$json_name = $file_name + ".json"
$vide_name = $file_name + ".mp4"

if ($get -eq "chat") {
    Write-Output "[EzTwitch] Starting chat download ..."

    &$twitch_downloader_location --ffmpeg-path $ffmpeg_location -m ChatDownload -o $json_name -u $id -b $start_secs -e $end_secs

    Write-Output "`n[EzTwitch] Starting chat render ..."

    &$twitch_downloader_location --ffmpeg-path $ffmpeg_location -m ChatRender -o $vide_name -i $json_name -h 1440 -w 720 --framerate 60 --font-size 24 --background-color "#000000"
} elseif ($get -eq "video") {
     Write-Output "[EzTwitch] Starting video download ..."

    &$twitch_downloader_location --ffmpeg-path $ffmpeg_location -m VideoDownload -o $vide_name -u $id -b $start_secs -e $end_secs -q "1080p60"
}

Write-Output "`n[EzTwitch] All done! :)"