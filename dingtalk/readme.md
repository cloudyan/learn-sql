# 钉钉消息

```bash
# https://oapi.dingtalk.com/robot/send?access_token=xxx


curl 'https://oapi.dingtalk.com/robot/send?access_token=xxx' \
 -H 'Content-Type: application/json' \
 -d '{"msgtype": "text","text": {"content":"告警：我就是我, 是不一样的烟火"}}'
```
