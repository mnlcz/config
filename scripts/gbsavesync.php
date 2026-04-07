#!/usr/bin/env php
<?php

declare(strict_types=1);

namespace Scripts;

$user = trim(shell_exec('whoami'));
$curr_game = readline('Game: ');
$downloads = "/home/$user/Downloads";
if (!realpath($downloads)) {
    fwrite(STDERR, "Downloads directory '$downloads' couldn't be found. Consider changing it".PHP_EOL);
    exit(1);
}
$downloads = realpath($downloads);
$conversion_tool = "/home/$user/.local/bin/gbsaveconv";
$ls = scandir($downloads);
$matches = array_values(array_filter($ls, fn ($f) => str_contains(strtolower($f), strtolower($curr_game)) and str_ends_with($f, '.srm')));
if (empty($matches)) {
    fwrite(STDERR, "Game $curr_game, not found in $downloads".PHP_EOL);
    exit(1);
}
if (count($matches) > 1) {
    fwrite(STDERR, "Search '$curr_game', matched with multiple save files:".PHP_EOL);
    foreach ($matches as $match) {
        fprintf(STDERR, "\t--> %s\n", $match);
    }
    fwrite(STDERR, 'Consider prompting a more detailed name.'.PHP_EOL);
    exit(1);
}
$save = $matches[0];
fprintf(STDOUT, "Matched with:\n\t--> %s\n", $save);

fwrite(STDOUT, PHP_EOL.'============================== RETROARCH ============================='.PHP_EOL);
$retroarch = realpath("/home/$user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/RetroArch/saves/mGBA/");
fwrite(STDOUT, "Attempting to copy the save file to '$retroarch'... ");
if (!realpath($retroarch)) {
    fwrite(STDERR, "But the location doesn't exist.".PHP_EOL);
    exit(1);
}
$res = copy("$downloads/$save", "$retroarch/$save");
if (!$res) {
    fwrite(STDERR, 'But the copy operation failed.'.PHP_EOL);
    exit(1);
}
fwrite(STDOUT, 'Done.'.PHP_EOL);

fwrite(STDOUT, PHP_EOL.'================================ VBA-M ==============================='.PHP_EOL);
$vbam = realpath("/home/$user/Games/VBA/");
if (!$vbam) {
    fwrite(STDERR, 'The VBA-M location is not valid. Action needed.'.PHP_EOL);
    exit(1);
}
$ls = scandir($vbam);
$matches = array_values(array_filter($ls, fn ($f) => str_contains(strtolower($f), strtolower($curr_game)) and is_dir("$vbam/$f")));
if (empty($matches)) {
    fwrite(STDERR, "Game '$curr_game' doesn't have a dedicated directory in '$vbam'. Cannot copy save.".PHP_EOL);
    exit(1);
}
if (count($matches) > 1) {
    fwrite(STDERR, "Game '$curr_game', matched with multiple directories in '$vbam':".PHP_EOL);
    foreach ($matches as $match) {
        fprintf(STDERR, "\t--> %s\n", $match);
    }
    fwrite(STDERR, 'Consider renaming.'.PHP_EOL);
    exit(1);
}
$save_dir = "$vbam/$matches[0]";
fwrite(STDOUT, "Save file '$save' requires conversion to '.sav'.".PHP_EOL);
if (!realpath($conversion_tool)) {
    fwrite(STDERR, "The conversion tool '$conversion_tool couldn't be found. Cannot copy save.".PHP_EOL);
    exit(1);
}
if (!is_executable(realpath($conversion_tool))) {
    fwrite(STDERR, "The conversion tool '$conversion_tool' exists, but it's not executable. Cannot copy save.".PHP_EOL);
    exit(1);
}
fwrite(STDOUT, "Using '$conversion_tool' conversion tool...".PHP_EOL);
$out = substr($save, 0, strlen($save) - 3).'sav';
$cmd_out = shell_exec(realpath($conversion_tool).' '.escapeshellarg("$downloads/$save").' '.escapeshellarg("$downloads/$out"));
$matches = array_values(array_filter(scandir($downloads), fn ($f) => str_ends_with($f, '.sav')));
if (is_null($cmd_out) or empty($matches) or count($matches) > 1) {
    fwrite(STDERR, 'The conversion tool failed. Cannot copy save.'.PHP_EOL);
    exit(1);
}
$save = $matches[0];
fprintf(STDOUT, "The conversion tool generated:\n\t--> %s\n", $save);
fwrite(STDOUT, "Attempting to copy the save file to '$save_dir'... ");
if (!realpath($save_dir)) {
    fwrite(STDERR, "But the location doesn't exist.".PHP_EOL);
    exit(1);
}
$res = copy("$downloads/$save", "$save_dir/$save");
if (!$res) {
    fwrite(STDERR, 'But the copy operation failed.'.PHP_EOL);
    exit(1);
}
fwrite(STDOUT, 'Done.'.PHP_EOL);

fwrite(STDOUT, PHP_EOL.'Cleanup... ');
$save_files = array_filter(scandir($downloads), fn ($f) => str_ends_with($f, '.sav') or str_ends_with($f, '.srm'));
foreach ($save_files as $sf) {
    unlink("$downloads/$sf");
}
fwrite(STDOUT, 'Done.'.PHP_EOL);
