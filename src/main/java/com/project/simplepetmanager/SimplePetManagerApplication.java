package com.project.simplepetmanager;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication
public class SimplePetManagerApplication {

    public static void main(String[] args) {
        SpringApplication.run(SimplePetManagerApplication.class, args);
    }

}
