package com.hisentw.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.DateTimeZone;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.hisentw.entity.ChatEntity;
import com.hisentw.entity.ChatRepository;
import com.hisentw.entity.ResponseModel;
import com.hisentw.entity.UserEntity;
import com.hisentw.entity.UserRepository;

@RestController
@RequestMapping("/api")
public class ApiController {
	
	private Gson gson = new GsonBuilder().create();
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private ChatRepository chatRepository;
	
	@PostMapping(value = "/login", produces = "application/json;charset=UTF-8")
	public String login(@RequestBody String postPayload) {
		ResponseModel responseModel = new ResponseModel();
		UserEntity userEntity = null;
		try {
			Map<String, String> payloads = gson.fromJson(postPayload, new TypeToken<Map<String, String>>(){}.getType());
			String account = payloads.get("account");
			String password = payloads.get("password");
			Optional<UserEntity> optional = userRepository.findById(account);
			if (optional.isPresent()) {
				userEntity = optional.get();
				if (!StringUtils.equals(userEntity.getPassword(), password)) {
					responseModel.setErrorMsg("登入失敗");
					return gson.toJson(responseModel);
				} else {
					int count = userEntity.getCount();
					++count;
					userEntity.setCount(count);
					userRepository.save(userEntity);
				}
			} else {
				userEntity = new UserEntity();
				userEntity.setUserId(account);
				userEntity.setAccount(account);
				userEntity.setPassword(password);
				userEntity.setCount(1);
				userRepository.save(userEntity);
			}
		} catch (Exception e) {
			System.out.println("login error : " + e.toString());
			responseModel.setErrorMsg("系統發生錯誤");
			return gson.toJson(responseModel);
		}
		return gson.toJson(userEntity);
	}
	
	@PostMapping(value = "/updateName/{userId}", produces = "application/json;charset=UTF-8")
	public String updateName(@RequestBody String postPayload, @PathVariable("userId") String userId) {
		ResponseModel responseModel = new ResponseModel();
		try {
			Map<String, String> payloads = gson.fromJson(postPayload, new TypeToken<Map<String, String>>(){}.getType());
			String userName = payloads.get("userName");
			Optional<UserEntity> optional = userRepository.findById(userId);
			if (optional.isPresent()) {
				UserEntity userEntity = optional.get();
				userEntity.setUserName(userName);
				userRepository.save(userEntity);
			}
		} catch (Exception e) {
			System.out.println("updateName error : " + e.toString());
			responseModel.setErrorMsg("系統發生錯誤");
			return gson.toJson(responseModel);
		}
		return "";
	}
	
	@GetMapping(value = "/getImage/{userId}")
	@ResponseBody
	public byte[] getImage(@PathVariable("userId") String userId) {
		try {
			Optional<UserEntity> optional = userRepository.findById(userId);
			if (optional.isPresent()) {
				UserEntity userEntity = optional.get();
				return userEntity.getUserImage();
			}
		} catch (Exception e) {
			System.out.println("getImage error : " + e.toString());
		}
		return null;
	}
	
	@PostMapping(value = "/uploadImage/{userId}")
	public String uploadImage(
			@RequestParam(value = "file", required = false) MultipartFile uploadfile,
			@PathVariable("userId") String userId) {
		ResponseModel responseModel = new ResponseModel();
		try {
			Optional<UserEntity> optional = userRepository.findById(userId);
			if (optional.isPresent()) {
				UserEntity userEntity = optional.get();
				userEntity.setUserImage(uploadfile.getBytes());
				userRepository.save(userEntity);
			}
		} catch (Exception e) {
			System.out.println("uploadImage error : " + e.toString());
			responseModel.setErrorMsg("系統發生錯誤");
			return gson.toJson(responseModel);
		}
		return "";
	}
	
	@GetMapping(value = "/getTotalLoginCount")
	@ResponseBody
	public int getTotalLoginCount() {
		int totalCount = 0;
		try {
			totalCount = userRepository.getTotalLoginCount();
		} catch (Exception e) {
			System.out.println("getTotalLoginCount error : " + e.toString());
		}
		return totalCount;
	}
	
	@GetMapping(value = "/getChatList", produces = "application/json;charset=UTF-8")
	public String getChatList() {
		List<ChatEntity> chatList = null;
		try {
			chatList = this.getCharList();
		} catch (Exception e) {
			System.out.println("getChatList error : " + e.toString());
		}
		return gson.toJson(chatList);
	}
	
	@PostMapping(value = "/sendMessage/{userId}")
	public String sendMessage(
			@RequestBody String postPayload,
			@PathVariable("userId") String userId) {
		ResponseModel responseModel = new ResponseModel();
		DateTime now = new DateTime().withZone(DateTimeZone.forID("Asia/Taipei"));
		List<ChatEntity> chatList = null;
		try {
			Map<String, String> payloads = gson.fromJson(postPayload, new TypeToken<Map<String, String>>(){}.getType());
			String message = payloads.get("message");
			Optional<UserEntity> optional = userRepository.findById(userId);
			if (optional.isPresent()) {
				ChatEntity chatEntity = new ChatEntity();
				chatEntity.setUserId(userId);
				chatEntity.setMessage(message);
				chatEntity.setMessageTime(now.toDate());
				chatRepository.save(chatEntity);
				chatList = this.getCharList();
			} else {
				responseModel.setErrorMsg("查無此筆資料");
				return gson.toJson(responseModel);
			}
		} catch (Exception e) {
			System.out.println("sendMessage error : " + e.toString());
			responseModel.setErrorMsg("系統發生錯誤");
			return gson.toJson(responseModel);
		}
		return gson.toJson(chatList);
	}
	
	@GetMapping(value = "/deleteMessage/{id}")
	public String deleteMessage(
			@PathVariable("id") String id) {
		ResponseModel responseModel = new ResponseModel();
		List<ChatEntity> chatList = null;
		try {
			Optional<ChatEntity> optional = chatRepository.findById(id);
			if (optional.isPresent()) {
				chatRepository.deleteById(id);
				chatList = this.getCharList();
			} else {
				responseModel.setErrorMsg("查無此筆資料");
				return gson.toJson(responseModel);
			}
		} catch (Exception e) {
			System.out.println("deleteMessage error : " + e.toString());
			responseModel.setErrorMsg("系統發生錯誤");
			return gson.toJson(responseModel);
		}
		return gson.toJson(chatList);
	}
	
	private List<ChatEntity> getCharList() {
		Map<String, UserEntity> map = userRepository.findAll().stream()
			      .collect(Collectors.toMap(UserEntity::getUserId, v -> v));
		List<ChatEntity> chatList = chatRepository.findAll();
		chatList.forEach(v -> {
			v.setUserId(v.getUserId() + "%" + map.get(v.getUserId()).getUserName());
		});
		return chatRepository.findAll();
	}
	
}
