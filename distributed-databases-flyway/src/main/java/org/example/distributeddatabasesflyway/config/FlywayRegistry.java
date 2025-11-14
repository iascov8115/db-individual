package org.example.distributeddatabasesflyway.config;

import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class FlywayRegistry {
    private final Map<String, Flyway> flyways;

    @Autowired
    public FlywayRegistry(Map<String, Flyway> flyways) {
        this.flyways = flyways;
    }

    public Flyway getFlyway(String key) {
        return flyways.get(key);
    }

}
