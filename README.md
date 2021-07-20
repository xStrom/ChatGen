# ChatGen

This is a simple little script I wrote to help a friend render some Twitch VOD chats.

## Requirements

### FFmpeg

You need to have FFmpeg installed and the binary location configured in the script. [Download FFmpeg](http://ffmpeg.org/).

### TwitchDownloader

You need to have TwitchDownloader CLI installed and the binary location configured in the script. [Download TwitchDownloader CLI](https://github.com/lay295/TwitchDownloader).

## Usage

```
ChatGen [commands]

    Available commands:

    -id 123456
        The Twitch VOD id number, e.g. 123456.

    -start 01:02:34
        Start time, e.g. 1 hour 2 minutes and 34 seconds of the VOD.

    -end 02:03:55
        End time, e.g. 2 hours 3 minutes and 55 seconds of the VOD.

    -name "My Project"
        [Optional] Include your custom project name in the output filenames.
```

# Project status

This project is not actively maintained, however feel free to send bug reports or pull requests.

# About

© Copyright 2021 [Kaur Kuut](https://www.kaurkuut.com)

Licensed under the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0)