package com.hisentw.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.hisentw.entity.UserEntity;
import com.hisentw.entity.UserRepository;

@RestController
@RequestMapping("/api")
public class ApiController {
	
	private Gson gson = new GsonBuilder().create();
	
	@Autowired
	private UserRepository userRepository;
	
	@PostMapping(value = "/createImage/{userId}")
	public String createImage(
			@RequestParam(value = "file", required = false) MultipartFile uploadfile,
			@PathVariable("userId") String userId) {
		try {
			Optional<UserEntity> optional = userRepository.findById(userId);
			if (optional.isPresent()) {
				UserEntity userEntity = optional.get();
				userEntity.setUserImage(uploadfile.getBytes());
				userRepository.save(userEntity);
				return "上傳成功";
			} else {
				return "查無此人";
			}
		} catch (Exception e) {
			System.out.println("createImage error : " + e.toString());
			return "系統發生錯誤";
		}
	}
	
}
