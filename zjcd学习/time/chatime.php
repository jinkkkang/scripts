<?php
$s = $_POST["newtime"];
$t =  (explode("T",$s));
$time = $t[0] . " " . $t[1] . ":00";
$cmd = 'date -s ' . '"' . $time . '"';
system($cmd);
echo "修改成功";
?>
