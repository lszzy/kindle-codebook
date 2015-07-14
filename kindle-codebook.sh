#!env php
<?php
//参数检查
if (!$argv || count($argv) < 2) {
    exit("format: kindle-codebook.sh input [output] [skips]\nexample: kindle-codebook input/ output.html \".svn,.git\"\n");
}

//安全检查
$input = $argv[1];
$output = !empty($argv[2]) ? $argv[2] : basename($argv[1]) . '.html';
$skips = !empty($argv[3]) ? explode(',', $argv[3]) : array();
if (!file_exists($input)) {
    exit('input files not exist\n');
}
if (file_exists($output)) {
    exit('output file exist\n');
}

//扫描目录
function scanFiles($target)
{
    $dir   = rtrim($target, '/\\');
    $files = array();
      
    //扫描目录，兼容scandir
    if (function_exists('scandir')) {
        $subs = scandir($dir);
    } else {
        $subs = array();
        $handle = opendir($dir);
        while (($file = readdir($handle)) !== false) {
            $subs[] = $file;
        }
        closedir($handle);
        sort($subs);
    }
        
    $subs  = array_diff($subs, array('.', '..'));
    foreach ($subs as $sub) {
        $files[] = $dir . '/' . $sub;
    }
    return $files;
}

//递归扫描目录文件列表
function scanDirs($target, $skips)
{
    $result = array();
    $files = scanFiles($target);
    $dirs = array();
    //排序并过滤，优先文件
    foreach ($files as $file) {
        $skip = false;
        foreach ($skips as $value) {
            if (strpos($file, $value) !== false) {
                $skip = true;
                break;
            }
        }
        if ($skip) {
            continue;
        }

        if (is_file($file)) {
            $result[] = $file;
        } else {
            $dirs[] = $file;
        }
    }
    //再目录
    foreach ($dirs as $dir) {
        $result = array_merge($result, scanDirs($dir, $skips));
    }
    return $result;
}

//获取文件列表
$files = is_dir($input) ? scanDirs($input, $skips) : array($input);
$title = basename($input);
$html = '<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>' . $title . '</title>
</head>
<body>
    <h1>' . $title . '</h1>
';
$content = '';
//目录
foreach ($files as $file) {
    $anchor = str_replace(array('/', '\\', '.'), '-', $file);
    $content .= "<a id='catalog-$anchor' href='#{$anchor}'>{$file}</a>\n";
}
//内容
foreach ($files as $file) {
    $anchor = str_replace(array('/', '\\', '.'), '-', $file);
    $text = highlight_file($file, true);
    $content .= "<h3 id='{$anchor}'><a href='#catalog-$anchor'>$file</a></h3>";
    $content .= "<p>" . $text . "</p>\n";
}
$html .= nl2br($content) . '
</body>
</html>';

$status = file_put_contents($output, $html);
exit($status ? "success!\n" : "fail!\n");
?>
