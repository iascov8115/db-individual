package org.example.distributeddatabasesflyway.config;

import org.example.distributeddatabasesflyway.constants.Constants;
import org.flywaydb.core.Flyway;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

@Configuration
public class FlywayConfiguration {

    @Bean(Constants.FLYWAY_MOLDOVA)
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

    @Bean(Constants.FLYWAY_ROMANIA)
    public Flyway flywayRomania(Environment env) {

        String url = env.getProperty("flyway.ro.url");
        String user = env.getProperty("flyway.ro.user");
        String password = env.getProperty("flyway.ro.password");
        String schemas = env.getProperty("flyway.ro.schemas");
        String locations = env.getProperty("flyway.ro.locations");

        return Flyway.configure()
                .dataSource(url, user, password)
                .schemas(schemas)
                .locations(locations)
                .baselineOnMigrate(true)
                .load();
    }

    @Bean(Constants.FLYWAY_BULGARIA)
    public Flyway flywayBulgaria(Environment env) {

        String url = env.getProperty("flyway.bg.url");
        String user = env.getProperty("flyway.bg.user");
        String password = env.getProperty("flyway.bg.password");
        String schemas = env.getProperty("flyway.bg.schemas");
        String locations = env.getProperty("flyway.bg.locations");

        return Flyway.configure()
                .dataSource(url, user, password)
                .schemas(schemas)
                .locations(locations)
                .baselineOnMigrate(true)
                .load();
    }

    @Bean(Constants.FLYWAY_DWH)
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
