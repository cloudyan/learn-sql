
-- 每天汇总即可
-- 改为使用脚本来处理，详见 ../../scripts
-- 文档：https://help.aliyun.com/document_detail/141789.html
-- 示例：https://github.com/aliyun-UED/aliyun-sdk-js/blob/master/samples/sls/GetLogs.js

t: error |
select
  url_decode(msg) err_msg,
  url_extract_host(concat('https://', url_decode(page))) err_host,
  url_extract_path(concat('https://', url_decode(page))) err_path,
  count(1) err_msg_cnt
group by
  err_msg,
  err_host,
  err_path
order by err_msg_cnt desc

-- split_part(request_uri, '?', 1) as path
-- parse_url



-- 小程序无 err_host，可以用别的指代下 如 appId
t: error |
select
  url_decode(msg) err_msg,
  split_part(http_referer, '/', 4) err_host,
  url_extract_path(concat('https://', url_decode(page))) err_path,
  count(1) err_msg_cnt
group by
  err_msg,
  err_host,
  err_path
order by err_msg_cnt desc
