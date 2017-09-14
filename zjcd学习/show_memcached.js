var Memcached = require('memcached');
var memcached  = new Memcached('47.93.116.11:11211');
memcached.stats(function(err,data){
  console.log('memcached进程' + data[0].pid);
  console.log('分配的内存大小' + (data[0].limit_maxbytes/1048576).toFixed(2) + 'Mb');
  console.log('当前存储占用空间' + (data[0].bytes/1048576).toFixed(2) + 'Mb');
  console.log('存储占用比' + ((data[0].bytes/data[0].limit_maxbytes).toFixed(4)*100 + '%'));
})
