local host = os.getenv("REDIS_HOST")
local port = os.getenv("REDIS_PORT")
local password = os.getenv("REDIS_PASS")
local redis_key = os.getenv("REDIS_IPBLACK_KEY")
local redis = require "resty.redis";
local red = redis:new()
local redis_connection_timeout = 10
local ip_blacklist = ngx.shared.ip_blacklist
red:set_timeout(redis_connection_timeout)
ngx.log(ngx.STDERR, "host:".. host)
ngx.log(ngx.STDERR, "port:".. port)
local ok, err = red:connect("10.96.65.220", port);-- 地址host，端口号port
ok, err = red:auth(password)-- password    -- redis设置的密码
if not ok then
    -- 链接失败的时候
    ngx.log(ngx.DEBUG, "error:" .. err);
else
    local new_ip_blacklist, err = red:smembers(redis_key);-- 获取redis中redis_key的值
    if err then
        -- 获取失败的时候
        ngx.log(ngx.DEBUG, "error:" .. err)
    else
        -- 获取成功！
        ngx.log(ngx.DEBUG, new_ip_blacklist .. err)
    end
end
