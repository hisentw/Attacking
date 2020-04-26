package com.hisentw.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.hisentw")
public class Application {

	public static void main(final String[] args) throws Exception {
		SpringApplication.run(Application.class, args);
	}
	
}
