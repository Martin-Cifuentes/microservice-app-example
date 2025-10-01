package com.elgris.usersapi.configuration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.boot.ApplicationRunner;
import org.springframework.cache.CacheManager;

@Configuration
@EnableCaching
public class RedisConfig {

  @Value("${spring.redis.host:redis-todo}")
  private String host;

  @Value("${spring.redis.port:6379}")
  private int port;

  @Value("${app.cache.ttl-seconds:300}")
  private long ttlSeconds;

  @Bean
  public RedisConnectionFactory redisConnectionFactory() {
    JedisConnectionFactory f = new JedisConnectionFactory();
    f.setHostName(host);
    f.setPort(port);
    return f;
  }

  @Bean
  public RedisTemplate<Object, Object> redisTemplate(RedisConnectionFactory cf) {
    RedisTemplate<Object, Object> t = new RedisTemplate<>();
    t.setConnectionFactory(cf);
    t.setKeySerializer(new StringRedisSerializer());
    t.setValueSerializer(new GenericJackson2JsonRedisSerializer());
    t.afterPropertiesSet();
    return t;
  }

  @Bean
  public RedisCacheManager cacheManager(RedisTemplate<Object, Object> template) {
    RedisCacheManager mgr = new RedisCacheManager(template);
    mgr.setDefaultExpiration(ttlSeconds); // TTL en segundos
    mgr.setUsePrefix(true);
    return mgr;
  }

  @Bean
  public ApplicationRunner cacheManagerLogger(CacheManager cm) {
    return args -> System.out.println(">> CacheManager in use: " + cm.getClass().getName());
    }
}