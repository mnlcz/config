#!/usr/bin/env php
<?php

declare(strict_types=1);

namespace Scripts;

$opts = getopt('f:', ['file:']);

if (!isset($opts['f']) and !isset($opts['file'])) {
    exit("Usage: cf -f (--file)" . PHP_EOL);
}

$file = $opts['f'] ?? $opts['file'];

if (!is_file($file)) {
    exit("'$file' is not a valid file." . PHP_EOL);
}

$info = pathinfo($file);

[$command, $extra_args] = match ($info['extension']) {
    'c3' => [
        ['c3fmt'],
        ['--in-place'],
    ],
    'md' => [
        ['prettier'],
        ['--write'],
    ],
    default => throw new \Exception('Unsupported file type')
};

$cmd = array_merge($command, $extra_args, [$file]);
$descriptors = [
    0 => ['pipe', 'r'], // stdin
    1 => ['pipe', 'w'], // stdout
    2 => ['pipe', 'w'], // stderr
];

$process = proc_open($cmd, $descriptors, $pipes);

if (!is_resource($process)) {
    fwrite(STDERR, "Failed to start process for: $file" . PHP_EOL);
}

fclose($pipes[0]); // close stdin

$err = stream_get_contents($pipes[2]);

fclose($pipes[1]);
fclose($pipes[2]);

$exit_code = proc_close($process);

if ($exit_code !== 0) {
    fwrite(STDERR, "Formatter failed: $err" . PHP_EOL);
    exit($exit_code);
}
