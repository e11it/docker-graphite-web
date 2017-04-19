import os

LOG_DIR = '/var/log/graphite'
if os.getenv("CARBONLINK_HOSTS"):
    CARBONLINK_HOSTS = os.getenv("CARBONLINK_HOSTS").split(',')

if os.getenv("CLUSTER_SERVERS"):
    CLUSTER_SERVERS = os.getenv("CLUSTER_SERVERS").split(',')

if os.getenv("MEMCACHE_HOSTS"):
    MEMCACHE_HOSTS = os.getenv("MEMCACHE_HOSTS").split(',')

if os.getenv("WHISPER_DIR"):
    WHISPER_DIR = os.getenv("WHISPER_DIR")

if os.getenv("SECRET_KEY"):
    SECRET_KEY = os.getenv("SECRET_KEY")
else:
    SECRET_KEY = "secret_key"

if os.getenv("CARBONLINK_TIMEOUT"):
    CARBONLINK_TIMEOUT = os.getenv("CARBONLINK_TIMEOUT")

if os.getenv("CARBONLINK_RETRY_DELAY"):
    CARBONLINK_RETRY_DELAY = os.getenv("CARBONLINK_RETRY_DELAY")

if os.getenv("CARBONLINK_QUERY_BULK"):
    CARBONLINK_QUERY_BULK = os.getenv("CARBONLINK_QUERY_BULK")

if os.getenv("REMOTE_STORE_FETCH_TIMEOUT"):
    REMOTE_STORE_FETCH_TIMEOUT = os.getenv("REMOTE_STORE_FETCH_TIMEOUT")

if os.getenv("REMOTE_STORE_FIND_TIMEOUT"):
    REMOTE_STORE_FIND_TIMEOUT = os.getenv("REMOTE_STORE_FIND_TIMEOUT")

if os.getenv("REMOTE_STORE_RETRY_DELAY"):
    REMOTE_STORE_RETRY_DELAY = os.getenv("REMOTE_STORE_RETRY_DELAY")

if os.getenv("REMOTE_FIND_CACHE_DURATION"):
    REMOTE_FIND_CACHE_DURATION = os.getenv("REMOTE_FIND_CACHE_DURATION")

if os.getenv("REMOTE_PREFETCH_DATA"):
    REMOTE_PREFETCH_DATA = os.getenv("REMOTE_PREFETCH_DATA")

if os.getenv("BAN_PREFIX"):
    BAN_PREFIX = os.getenv("BAN_PREFIX")

if os.getenv("TZ"):
    TIME_ZONE = os.getenv("TZ")

if os.getenv("STORAGE_FINDERS"):
    STORAGE_FINDERS = os.getenv("STORAGE_FINDERS").split(',')
#else:
#    STORAGE_FINDERS = (
#        'graphite.graphouse.GraphouseFinder',
#    )
