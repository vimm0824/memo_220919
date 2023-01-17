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
import com.memo.user.model.User;

import jakarta.servlet.http.HttpSession;

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
	
	@PostMapping("/sign_in")
	public Map<String, Object> signIn(
			@RequestParam("loginId") String loginId,
			@RequestParam("password") String password,
			HttpSession session) {
		// 비밀번호 해싱
		password = EncryptUtils.md5(password);
		
		Map<String, Object> result = new HashMap<>();
		// DB select
		User user = userBO.getUserByLoginIdPassword(loginId, password);
		
		if (user != null) {
			// 행이 있으면 로그인
			result.put("code", 1);
			result.put("result", "성공");
			
			// 세션에 유저 정보를 담는다. (로그인 상태 유지)
			session.setAttribute("userId", user.getId());
			session.setAttribute("userLoginId", user.getLoginId());
			session.setAttribute("userName", user.getName());
		} else {
			// 행이 없으면 로그인 실패
			result.put("code", 500);
			result.put("errorMessage", "존재하지 않은 사용자입니다.");
		}
		
		return result; 
	}
}
