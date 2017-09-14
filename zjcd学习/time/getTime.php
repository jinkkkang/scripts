<?php
header("cache-control:no-cache,must-revalidate");  
header("Content-Type:text/html;charset=utf-8");  
$showtime = date("Y年m月d日H:i:s");  
echo $showtime;
?>
