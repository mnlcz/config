#!/usr/bin/env php
<?php

declare(strict_types=1);

namespace Scripts;

$winid = getenv('winid');

if (!$winid) {
	fwrite(STDERR, "winid not set".PHP_EOL);
	exit(1);
}

$winpath ="/mnt/acme/$winid";

if (!is_dir($winpath)) {
    fwrite(STDERR, "'$winpath' is not a valid file." . PHP_EOL);
    exit(1);
}

$wintag = file_get_contents("$winpath/tag");

if (!$wintag) {
	fwrite(STDERR, "'$wintag' couldn't be read".PHP_EOL);
	exit(1);
}

$file = explode(" ", $wintag)[0];
$info = pathinfo($file);

$input = file_get_contents("$winpath/body");

if (!$input) {
    fwrite(STDERR, "Failed to read input.".PHP_EOL);
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
    default => throw new \Exception('Unsupported file type')
};

$cmd = array_merge($command, $args);
$descriptors = [
    0 => ['pipe', 'r'], // stdin
    1 => ['pipe', 'w'], // stdout
    2 => ['pipe', 'w'], // stderr
];

$process = proc_open($cmd, $descriptors, $pipes);

if (!is_resource($process)) {
    fwrite(STDERR, "Failed to start formatter." . PHP_EOL);
}

// send input to the formatter via stdin
fwrite($pipes[0], $input);
fclose($pipes[0]);

// get formatter output from stdout and stderr
$output = stream_get_contents($pipes[1]);
$error  = stream_get_contents($pipes[2]);

fclose($pipes[1]);
fclose($pipes[2]);

$exit = proc_close($process);

if ($exit !== 0) {
    fwrite(STDERR, $error);
    exit($exit);
}

// Add formatted content
echo $output;