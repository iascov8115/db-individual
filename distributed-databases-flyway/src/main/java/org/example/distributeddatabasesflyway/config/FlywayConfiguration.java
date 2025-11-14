package org.example.distributeddatabasesflyway.config;

import org.flywaydb.core.Flyway;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

@Configuration
public class FlywayConfiguration {

    @Bean("flywayMoldova")
    public Flyway flywayMoldova(Environment env) {

        String url = env.getProperty("flyway.md.url");
        String user = env.getProperty("flyway.md.user");
        String password = env.getProperty("flyway.md.password");
        String schemas = env.getProperty("flyway.md.schemas");
        String locations = env.getProperty("flyway.md.locations");

        return Flyway.configure()
                .dataSource(url, user, password)
                .schemas(schemas)
                .locations(locations)
                .baselineOnMigrate(true)
                .load();
    }

    @Bean("flywayDwh")
    public Flyway flywayDwh(Environment env) {
        String url = env.getProperty("flyway.dwh.url");
        String user = env.getProperty("flyway.dwh.user");
        String password = env.getProperty("flyway.dwh.password");
        String schemas = env.getProperty("flyway.dwh.schemas");
        String locations = env.getProperty("flyway.dwh.locations");
        String defaultSchema = env.getProperty("flyway.dwh.default-schema");

        return Flyway.configure().dataSource(url, user, password)
                .schemas(schemas)
                .locations(locations)
                .defaultSchema(defaultSchema)
                .baselineOnMigrate(true)
                .load();
    }
}
