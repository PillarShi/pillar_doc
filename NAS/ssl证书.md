acme.sh 使用较为简单，这里暂时不写。

`root`使用`crontab -e`设置每月15号定时运行脚本，并重启机器

```bash
* * 15 * * "/root/.acme.sh"/nas_ssl_renew.sh > /dev/null
```
