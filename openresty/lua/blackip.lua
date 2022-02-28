local redis = require("resty.redis")
local ngx_log = ngx.log
local ngx_ERR = ngx.ERR
local ngx_INFO = ngx.INFO
local ngx_exit = ngx.exit
local ngx_var = ngx.var

-- 黑名单缓存60秒
local cache_idle = 60
local forbidden_list = ngx.shared.forbidden_list


local function close_redis(red)
    if not red then
        return
    end
    -- 释放连接(连接池实现)
    local pool_max_idle_time = 10000 -- 毫秒
    local pool_size = 100  -- 连接池大小
    local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)

    if not ok then
        ngx_log(ngx_ERR, "set redis keepalive error : ", err)
    end
end

-- 从redis获取ip黑名单列表
local function get_forbidden_list()
    local red = redis:new()
    red:set_timeout(1000)
    local ip = os.getenv("REDIS_HOST")
    local port = os.getenv("REDIS_PORT")
    local password = os.getenv("REDIS_PASS")
    local key = os.getenv("REDIS_IPBLACK_KEY")

    local ok, err = red:connect(ip, port)
    if not ok then
        ngx_log(ngx_ERR, "connect to redis error : ", err)
        close_redis(red)
        return
    end

    local res, err = red:auth(password)
    if not res then
        ngx_log(ngx_ERR, "failed to authenticate: ", err)
        close_redis(red)
        return
    end

    local resp, err = red:smembers(key)
    if not resp then
        ngx_log(ngx_ERR, "get redis connect error : ", err)
        close_redis(red)
        return
    end
    -- 得到的数据为空处理
    if resp == ngx.null then
        resp = nil
    end
    close_redis(red)

    return resp
end

-- 刷新黑名单
local function reflush_forbidden_list()
    local current_time = ngx.now()
    local last_update_time = forbidden_list:get("last_update_time");

    if last_update_time == nil or last_update_time < (current_time - cache_idle) then
        local new_forbidden_list = get_forbidden_list();
        if not new_forbidden_list then
            return
        end

        forbidden_list:flush_all()
        for i, forbidden_ip in ipairs(new_forbidden_list) do
            forbidden_list:set(forbidden_ip, true);
        end
        forbidden_list:set("last_update_time", current_time);
    end
end


reflush_forbidden_list()
local ip = ngx_var.remote_addr
if forbidden_list:get(ip) then
    ngx_log(ngx_INFO, "forbidden ip refused access : ", ip)
    return ngx_exit(ngx.HTTP_FORBIDDEN)
end

