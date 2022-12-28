

-- 域名可达性监控-a

*
and app_alias_name :app_name
and app_inner_version >= 1050951 |
select
  *
from(
    select
      city,
      requestHost,
      sum(availableCnt) successCnt,
      sum(unAvailableCnt) errCnt,
      sum(cnt) total,
      sum(unAvailableCnt) * 100 / sum(cnt) errRate
    FROM      (
        select
          DISTINCT "__tag__:__client_ip__" clientIp,
          ip_to_city("__tag__:__client_ip__") as city,
          event_name,
          requestHost,
          if(event_name = 'DOMAIN_AVAILABLE', 1, 0) availableCnt,
          if(event_name = 'DOMAIN_UNAVAILABLE', 1, 0) unAvailableCnt,
          1 cnt
        FROM          log
        where
          ip_to_city("__tag__:__client_ip__") <> ''
      )
    where
      requestHost in (
        'xx1.com',
        'xx2.com'
      )
    group by
      city,
      requestHost
    order by
      city,
      requestHost
  )
where
  total > 10
  and errRate > 50
limit
  1000


-- 域名可达性监控-c
*
and app_alias_name :app_name
and app_inner_version >= 1050951 |
select
  *
from(
    select
      city,
      requestHost,
      sum(availableCnt) successCnt,
      sum(unAvailableCnt) errCnt,
      sum(cnt) total,
      sum(unAvailableCnt) * 100 / sum(cnt) errRate
    FROM      (
        select
          DISTINCT "__tag__:__client_ip__" clientIp,
          ip_to_city("__tag__:__client_ip__") as city,
          event_name,
          requestHost,
          if(event_name = 'DOMAIN_AVAILABLE', 1, 0) availableCnt,
          if(event_name = 'DOMAIN_UNAVAILABLE', 1, 0) unAvailableCnt,
          1 cnt
        FROM          log
        where
          ip_to_city("__tag__:__client_ip__") <> ''
      )
    where
      requestHost in (
        'xx1.com',
        'xx2.com'
      )
    group by
      city,
      requestHost
    order by
      city,
      requestHost
  )
where
  total > 10
  and errRate > 50
limit
  1000

-- 域名可达性监控-b
*
and app_alias_name :app_name
and app_inner_version >= 1050951 |
select
  *
from(
    select
      city,
      requestHost,
      sum(availableCnt) successCnt,
      sum(unAvailableCnt) errCnt,
      sum(cnt) total,
      sum(unAvailableCnt) * 100 / sum(cnt) errRate
    FROM      (
        select
          DISTINCT "__tag__:__client_ip__" clientIp,
          ip_to_city("__tag__:__client_ip__") as city,
          event_name,
          requestHost,
          if(event_name = 'DOMAIN_AVAILABLE', 1, 0) availableCnt,
          if(event_name = 'DOMAIN_UNAVAILABLE', 1, 0) unAvailableCnt,
          1 cnt
        FROM          log
        where
          ip_to_city("__tag__:__client_ip__") <> ''
      )
    where
      requestHost in (
        'xx1.com',
        'xx2.com'
      )
    group by
      city,
      requestHost
    order by
      city,
      requestHost
  )
where
  total > 10
  and errRate > 50
limit
  1000

-- 告警规则

-- 1. b：获取10分钟（整点时间）数据，按城市、域名分类，统计域名可达次数、域名不可达次数、域名可达率，每分钟执行一次，根据查询结果，筛选出总次数大于10和域名可达率小于50%的数据进行告警
-- 2. a： 获取30分钟（整点时间）数据，按城市、域名分类，统计域名可达次数、域名不可达次数、域名可达率，每分钟执行一次，根据查询结果，筛选出总次数大于10和域名可达率小于50%的数据进行告警
-- 3. c：获取60分钟（整点时间）数据，按城市、域名分类，统计域名可达次数、域名不可达次数、域名可达率，每分钟执行一次，根据查询结果，筛选出总次数大于10和域名可达率小于50%的数据进行告警
