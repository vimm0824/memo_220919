package com.memo.common;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component		// 일반적인 스프링빈
public class FileManagerService {

	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	// 실제 이미지가 저장될 경로(서버)
	public static final String FILE_UPLOAD_PATH = "/Users/guyungi/Desktop/spring_project/memo/workspace/images/";
	
	// input: MultipartFile, userLoginId
	// output: image Path
	public String saveFile(String userLoginId, MultipartFile file) {
		// 파일 디렉토리 예) aaaa_162012315/sun.png => 중복방지
		String directoryName = userLoginId + "_" + System.currentTimeMillis() + "/";		// aaaa_162012315/
		String filePath = FILE_UPLOAD_PATH + directoryName;									// /Users/guyungi/Desktop/spring_project/memo/workspace/images/aaaa_162012315/sun.png
		
		File directory = new File(filePath);
		if (directory.mkdir() == false) {
			// 폴더 만드는데 실패시 이미지패스 null
			return null;
		}
		
		// 파일 업로드: byte 단위로 업로드 된다.
		try {
			byte[] bytes = file.getBytes();
			Path path = Paths.get(filePath + file.getOriginalFilename());		// 개인 프로젝트할때는 한글방지하는 로직을 만들어줘야한다.
			// OriginalFilename은 사용자가 올린 파일명
			Files.write(path, bytes);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		
		// 파일 업로드가 성공했으면 이미지 url path를 리턴한다.
		// 예) http://localhost/images/aaaa_162012315/sun.png
		return "/images/" + directoryName + file.getOriginalFilename();
	}
	
	public void deleteFile(String imagePath) {		// imagePath: /images/aaaa_162012315/sun.png
		// imagePath에 있는 겹치는 /images/ 구문 제거
		Path path = Paths.get(FILE_UPLOAD_PATH + imagePath.replace("/images/", ""));
		if (Files.exists(path)) {
			// 이미지 삭제 
			try {
				Files.delete(path);		//이미지 삭제
			} catch (IOException e) {
				logger.error("[이미지 삭제] 이미지 삭제 실패. imagePath:{}", imagePath);
			}
			
			// 디렉토리(폴더) 삭제
			path = path.getParent();
			if (Files.exists(path)) {
				try {
					Files.delete(path);	// 이미지 상위 폴더 삭제
				} catch (IOException e) {
					logger.error("[이미지 삭제] 디렉토리 삭제 실패. imagePath:{}", imagePath);
				}
			}
		}
	}
}
