package org.example.distributeddatabasesflyway.service;

import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class FlywayLauncherServiceImpl implements FlywayLauncherService {

    private final Flyway flyway;

    @Autowired
    public FlywayLauncherServiceImpl(@Qualifier("flywayMoldova") Flyway flyway) {
        this.flyway = flyway;
    }

    @Override
    public Integer launch() {
        flyway.migrate();

        return 0;
    }
}
