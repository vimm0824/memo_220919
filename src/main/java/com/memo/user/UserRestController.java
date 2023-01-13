package com.memo.user;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.memo.common.EncryptUtils;
import com.memo.user.bo.UserBO;

@RequestMapping("user")
@RestController
public class UserRestController {

	@Autowired
	private UserBO userBO;
	
	/**
	 * 아이디 중복확인 api
	 * @param loginId
	 * @return
	 */
	@RequestMapping("/is_duplicated_id")
	public Map<String, Object> isDuplicatedId(
			@RequestParam("loginId") String loginId) {
		
		Map<String, Object> result = new HashMap<>();
		
		boolean isDuplicated = userBO.existLoginId(loginId);
		
		if (isDuplicated) { // 중복일때
			result.put("code", 1);
			result.put("result", true);
		} else { // 사용가능
			result.put("code", 1);
			result.put("result", false);
		}
		
		return result;
 	}
	
	/**
	 * 회원가입
	 * @param loginId
	 * @param password
	 * @param name
	 * @param email
	 * @return
	 */
	@PostMapping("/sign_up")
	public Map<String, Object> signUp(
			@RequestParam("loginId") String loginId,
			@RequestParam("password") String password,
			@RequestParam("name") String name,
			@RequestParam("email") String email
			) {
		Map<String, Object> result = new HashMap<>();
		
		// 비밀번호 해싱(hashing) - mb5 (보안에 취약함)
		password = EncryptUtils.md5(password);
		
		userBO.addUser(loginId, password, name, email);
		
		result.put("code", 1);
		result.put("result", "성공");
		
		return result;
	}
}
