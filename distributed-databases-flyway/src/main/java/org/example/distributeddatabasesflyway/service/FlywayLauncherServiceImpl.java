package org.example.distributeddatabasesflyway.service;

import org.example.distributeddatabasesflyway.config.FlywayRegistry;
import org.example.distributeddatabasesflyway.constants.Constants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FlywayLauncherServiceImpl implements FlywayLauncherService {

    private final FlywayRegistry flywayRegistry;

    @Autowired
    public FlywayLauncherServiceImpl(FlywayRegistry flywayRegistry) {
        this.flywayRegistry = flywayRegistry;
    }

    @Override
    public Integer launch() {

        flywayRegistry.getFlyway(Constants.FLYWAY_MOLDOVA).migrate();
        flywayRegistry.getFlyway(Constants.FLYWAY_ROMANIA).migrate();
        flywayRegistry.getFlyway(Constants.FLYWAY_BULGARIA).migrate();
        flywayRegistry.getFlyway(Constants.FLYWAY_DWH).migrate();

        return 0;
    }
}
