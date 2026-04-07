#!/usr/bin/env php
<?php

declare(strict_types=1);

$has_updates = "Not up to date. ❌";
$no_updates = "Up to date. ✅";

// TODO: add attribute with the command to update. Only to show it as a help, not to actually run it.
class Tool
{
    /**
     * @param Closure(): string $handler
     */
    public function __construct(
        public readonly string $name,
        public readonly string $command,
        public readonly Closure $handler,
    ) {}

    public function check(): void
    {
        $this->log();
    }

    private function run(): ?string
    {
        return shell_exec($this->command);
    }

    private function log(): void
    {
        fprintf(STDOUT, "[%s]: ", strtoupper($this->name));
        $cmd_res = $this->run();
        $out = ($this->handler)($cmd_res);
        fprintf(STDOUT, "%s\n", $out);
    }
}

$tools = [
    new Tool(
        "dnf",
        "dnf check-update",
        fn($res) => count(array_filter(explode("\n", $res))) == 2
            ? $no_updates
            : sprintf("%s\n%s", $has_updates, $res), // TODO: parse when there are updates available
    ),
    new Tool(
        "snap",
        "snap refresh --list 2>&1",
        fn($res) => str_contains($res, "All snaps up to date.")
            ? $no_updates
            : sprintf("%s\n%s", $has_updates, $res),
    ),
    new Tool(
        "flatpak",
        "flatpak remote-ls --updates",
        fn($res) => $res ? sprintf("%s\n%s", $has_updates, $res) : $no_updates,
    ),
    new Tool("cargo", "cargo install-update --list", function ($res) use (
        $has_updates,
        $no_updates,
    ) {
        $parsed = array_filter(
            array_slice(explode("\n", $res), 1),
            fn($line) => !empty($line)
                and (str_contains($line, "Needs update")
                    or str_contains($line, "Yes")),
        );
        return count($parsed) == 1
            ? $no_updates
            : sprintf("%s\n%s\n", $has_updates, implode("\n", $parsed));
    }),
    new Tool(
        "composer",
        "composer global outdated -A 2>&1",
        fn($res) => substr_count($res, "Everything up to date") == 2
            ? $no_updates
            : sprintf(
                "%s\n%s\n",
                $has_updates,
                implode("\n", array_slice(explode("\n", $res), 2)),
            ),
    ),
    new Tool("pip", "pip list --outdated", function ($res) use (
        $has_updates,
        $no_updates,
    ) {
        if (is_null($res)) {
            return $no_updates;
        }

        $lines = explode("\n", $res);
        return sprintf("%s\n\n%s", $has_updates, $res);
    }),
    new Tool(
        "npm",
        "npm -g outdated 2>&1",
        fn($res) => empty($res)
            ? $no_updates
            : sprintf("%s\n%s\n", $has_updates, $res),
    ),
];

foreach ($tools as $tool) {
    $tool->check();
}
