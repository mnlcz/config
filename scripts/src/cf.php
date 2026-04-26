#!/usr/bin/env php
<?php

declare(strict_types=1);

namespace Scripts;

$winid = getenv('winid');

if (!$winid) {
    fwrite(STDERR, 'winid not set'.PHP_EOL);
    exit(1);
}

$winpath = "/mnt/acme/$winid";

if (!is_dir($winpath)) {
    fwrite(STDERR, "'$winpath' is not a valid file.".PHP_EOL);
    exit(1);
}

$wintag = file_get_contents("$winpath/tag");

if (!$wintag) {
    fwrite(STDERR, "'$wintag' couldn't be read".PHP_EOL);
    exit(1);
}

$file = explode(' ', $wintag)[0];
$info = pathinfo($file);

$input = file_get_contents("$winpath/body");

if (!$input) {
    fwrite(STDERR, 'Failed to read input.'.PHP_EOL);
    exit(1);
}

[$command, $args] = match ($info['extension']) {
    'c3' => [
        ['c3fmt'],
        ['--stdin', '--stdout'],
    ],
    'md' => [
        ['prettier'],
        [],
    ],
    'typ' => [
        ['typstyle'],
        [],
    ],
    default => throw new \Exception('Unsupported file type'),
};

$cmd = array_merge($command, $args);
$descriptors = [
    0 => ['pipe', 'r'], // stdin
    1 => ['pipe', 'w'], // stdout
    2 => ['pipe', 'w'], // stderr
];

$process = proc_open($cmd, $descriptors, $pipes);

if (!is_resource($process)) {
    fwrite(STDERR, 'Failed to start formatter.'.PHP_EOL);
}

// send input to the formatter via stdin
fwrite($pipes[0], $input);
fclose($pipes[0]);

// get formatted output from stdout and stderr
$output = stream_get_contents($pipes[1]);
$error = stream_get_contents($pipes[2]);

fclose($pipes[1]);
fclose($pipes[2]);

$exit = proc_close($process);

if (0 !== $exit) {
    fwrite(STDERR, $error);
    exit($exit);
}

// clear the body
$fh = proc_open(
    "9p write acme/$winid/addr",
    [0 => ['pipe', 'r']],
    $pipes
);
fwrite($pipes[0], ',');
fclose($pipes[0]);
proc_close($fh);

// write formatted output
$fh = proc_open(
    "9p write acme/$winid/data",
    [0 => ['pipe', 'r']],
    $pipes
);
fwrite($pipes[0], $output);
fclose($pipes[0]);
proc_close($fh);
