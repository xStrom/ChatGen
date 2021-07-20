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
    $name,
    $id,
    $start,
    $end
)

# Configuration

$twitch_dowloader_location = ""
$ffmpeg_location = ""

# Sanity check

Write-Output "[ChatGen] Version 1.0 by Strom"

if ($twitch_dowloader_location -eq "") {
    Write-Output "You need to provide the TwitchDownloaderCLI binary location!"
    exit
}

if ($ffmpeg_location -eq "") {
    Write-Output "You need to provide the ffmpeg binary location!"
    exit
}

if ($id -eq $null) {
    Write-Output "You need to provide a Twitch VOD id! (e.g. -id 123)"
    exit
}

if ($start -eq $null) {
    Write-Output "You need to provide a start timestamp! (e.g. -start 12:34:56)"
    exit
}

if ($start -notmatch '^(\d\d):(\d\d):(\d\d)$') {
    Write-Output "The start timestamp is not in the correct format! (e.g. -start 12:34:56)"
    exit
}

if ($end -eq $null) {
    Write-Output "You need to provide an end timestamp! (e.g. -end 12:34:56)"
    exit
}

if ($end -notmatch '^(\d\d):(\d\d):(\d\d)$') {
    Write-Output "The end timestamp is not in the correct format! (e.g. -end 12:34:56)"
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

$file_name = [string]$id + " " + [string]$start_secs + "-" + [string]$end_secs
if ($name -ne $null) {
    $file_name = $name + " " + $file_name
}

$json_name = $file_name + ".json"
$vide_name = $file_name + ".mp4"

Write-Output "[ChatGen] Starting chat download ..."

&$twitch_dowloader_location --ffmpeg-path $ffmpeg_location -m ChatDownload -o $json_name -u $id -b $start_secs -e $end_secs

Write-Output "`n[ChatGen] Starting chat render ..."

&$twitch_dowloader_location --ffmpeg-path $ffmpeg_location -m ChatRender -o $vide_name -i $json_name -h 1440 -w 720 --framerate 60 --font-size 24

Write-Output "`n[ChatGen] All done! :)"