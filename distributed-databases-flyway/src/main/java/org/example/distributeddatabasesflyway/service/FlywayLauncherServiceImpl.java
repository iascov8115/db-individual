package org.example.distributeddatabasesflyway.service;

import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class FlywayLauncherServiceImpl implements FlywayLauncherService {

    private final Flyway flyway;
    private final Flyway flywayDwh;

    @Autowired
    public FlywayLauncherServiceImpl(@Qualifier("flywayMoldova") Flyway flyway, Flyway flywayDwh) {
        this.flyway = flyway;
        this.flywayDwh = flywayDwh;
    }

    @Override
    public Integer launch() {
        flyway.migrate();
        flywayDwh.migrate();

        return 0;
    }
}
