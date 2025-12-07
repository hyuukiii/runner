package com.runmatch.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

// 해당 어노테이션을 붙여줘야 날짜( createdAt, updateAt )가 자동으로 들어감
@EnableJpaAuditing
@SpringBootApplication
public class RunmatchApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(RunmatchApiApplication.class, args);
	}

}