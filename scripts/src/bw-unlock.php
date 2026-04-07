#!/usr/bin/env php
<?php

declare(strict_types=1);

$descriptors = [
    0 => fopen("/dev/tty", "r"), // password prompt reads from terminal
    1 => ["pipe", "w"], // capture stdout
    2 => fopen("/dev/tty", "w"), // status messages go to terminal
];

$process = proc_open("bw unlock", $descriptors, $pipes);

if (!is_resource($process)) {
    fwrite(STDERR, "Failed to start bw unlock\n");
    exit(1);
}

$stdout = stream_get_contents($pipes[1]);
fclose($pipes[1]);

$code = proc_close($process);

if ($code !== 0) {
    fwrite(STDERR, "bw unlock failed with code $code\n");
    exit(1);
}

// > $env:BW_SESSION="EXAMPLE"
preg_match('/BW_SESSION="([^"]+)"/', $stdout, $matches);

if (empty($matches[1])) {
    fwrite(STDERR, "Could not parse session key from output\n");
    exit(1);
}

echo "export BW_SESSION=\"{$matches[1]}\"\n";
