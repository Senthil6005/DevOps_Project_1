package com.trainerstacks.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HomeController {

    @Value("${APP_VERSION:local}")
    private String version;

    @GetMapping("/")
    public String home() {
        return "DevOps pipeline demo is running. Version: " + version;
    }
}
