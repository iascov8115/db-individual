package org.example.distributeddatabasesflyway.controller;

import org.example.distributeddatabasesflyway.service.FlywayLauncherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/flyway")
public class FlywayRunnerController {

    private final FlywayLauncherService flywayLauncherService;

    @Autowired
    public FlywayRunnerController(FlywayLauncherService flywayLauncherService) {
        this.flywayLauncherService = flywayLauncherService;
    }


    // Run from Postman or with the following command:
    // curl --location --request POST 'http://localhost:8080/flyway'
    @PostMapping
    public ResponseEntity<?> launchFlyway() {
        Optional<Integer> body = Optional.ofNullable(flywayLauncherService.launch());

        return ResponseEntity.of(body);
    }

}
