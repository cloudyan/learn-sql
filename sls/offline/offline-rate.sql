-- 离线包占比

(
  (
    context :xxxapi
    and "/xxxapi/xxx"
    and topic :HttpIn
  )
) | with t1 as (
  SELECT
    json_extract_scalar(msg, '$.commonRequestParameters.p_i[0]') as p_i,
    json_extract_scalar(msg, '$.commonRequestParameters.p_v[0]') as p_b,
    json_extract_scalar(msg, '$.commonRequestParameters.p_c[0]') as p_c,
    json_extract_scalar(msg, '$.requestParameters.o_v[0]') as o_v
  FROM    log
  WHERE
    json_extract_scalar(msg, '$.commonRequestParameters.p_v[0]') IS NOT null
    AND json_extract_scalar(msg, '$.commonRequestParameters.p_i[0]') IS NOT null
    AND json_extract_scalar(msg, '$.commonRequestParameters.r_c[0]') = 'hb'
),
t2 as (
  select
    p_c,
    max(o_v) o_v,
    max(p_i) p_i,
    max(p_b) p_b
  FROM    t1
  GROUP BY
    p_c
),
t3 as (
  select
    arbitrary(o_v) o_v,
    p_i,
    p_b,
    COUNT(p_c) cnt
  FROM    t2
  GROUP BY
    p_i,
    p_b
  ORDER BY
    p_b DESC
)
SELECT
  arbitrary(o_v) "App版本号",
  p_i "App内部版本号",
  p_b "离线包版本号",
  cnt "by p_c 出现次数",
  round (
    cnt * 100.0 / sum(cnt) over (partition by p_i),
    2
  ) "占比（%）"
FROM  t3
WHERE
  cnt > 20
GROUP BY
  p_i,
  p_b,
  cnt
ORDER BY
  p_i DESC
LIMIT
  10000
