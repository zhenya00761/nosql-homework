package ratelimiter;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.time.Instant;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class RateLimiter {

  private final Jedis redis;
  private final String label;
  private final long maxRequestCount;
  private final long timeWindowSeconds;

  public RateLimiter(Jedis redis, String label, long maxRequestCount, long timeWindowSeconds) {
    this.redis = redis;
    this.label = label;
    this.maxRequestCount = maxRequestCount;
    this.timeWindowSeconds = timeWindowSeconds;
  }

  public boolean pass() {

    String LUA_SCRIPT =
        "local windowStart = tonumber(ARGV[3]) - (tonumber(ARGV[2]) * 1000)\n" +
        "redis.call('ZREMRANGEBYSCORE', KEYS[1], '-inf', windowStart)\n" +
        "local count = redis.call('ZCARD', KEYS[1])\n" +
        "if count < tonumber(ARGV[1]) then\n" +
        "    redis.call('ZADD', KEYS[1], ARGV[3], ARGV[4])\n" +
        "    redis.call('EXPIRE', KEYS[1], tonumber(ARGV[2]) * 2)\n" +
        "    return 1\n" +
        "else\n" +
        "    return 0\n" +
        "end";

    String key = label;
    long now = System.currentTimeMillis();
    String memberId = UUID.randomUUID().toString();

    Long result = (Long) redis.eval(
        LUA_SCRIPT,
        List.of(key),
        Arrays.asList(
            String.valueOf(maxRequestCount),
            String.valueOf(timeWindowSeconds),
            String.valueOf(now),
            memberId
        )
    );

    return result == 1L;
  }

  public static void main(String[] args) {
    JedisPool pool = new JedisPool("localhost", 6379);

    try (Jedis redis = pool.getResource()) {
      RateLimiter rateLimiter = new RateLimiter(redis, "pr_rate", 1, 1);

      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
      long prev = Instant.now().toEpochMilli();
      long now;

      while (true) {
        try {
          String s = br.readLine();
          if (s == null || s.equals("q")) {
            return;
          }
          boolean passed = rateLimiter.pass();

          now = Instant.now().toEpochMilli();
          if (passed) {
            System.out.printf("%d ms: %s", now - prev, "passed");
            prev = now;
          } else {
            System.out.printf("%d ms: %s", now - prev, "limited");
          }
        } catch (IOException e) {
          e.printStackTrace();
        }
      }

    }
  }
}
