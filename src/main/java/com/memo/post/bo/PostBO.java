package com.memo.post.bo;

import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.memo.common.FileManagerService;
import com.memo.post.dao.PostDAO;
import com.memo.post.model.Post;

@Service
public class PostBO {
	
	//private Logger logger = LoggerFactory.getLogger(PostBO.class);
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	private static final int POST_MAX_SIZE = 3;
	
	@Autowired
	private PostDAO postDAO;
	@Autowired
	private FileManagerService fileManagerService;
	
	// 글 추가
	public int addPost(int userId, String userLoginId, String subject, String content, MultipartFile file) {
		
		// 파일 업로드 (서버) => 경로
		String imagePath = null;
		
		if (file != null) {
			// 파일이 있을때만 업로드 => 이미지 경로를 얻어냄
			imagePath = fileManagerService.saveFile(userLoginId, file);
		}
		
		return postDAO.insertPost(userId, subject, content, imagePath);
	}
	
	// 글 수정
	public void updatePost(int userId, String userLoginId,
			int postId, String subject, String content, MultipartFile file) {
		// 기존 글을 가져온다. (이미지가 교체될때 기존이미지 제거를 위해)
		Post post = getPostByPostidUserId(postId, userId);
		if (post == null) {
			logger.warn("[update post] 수정할 메모가 존재하지 않습니다. postId:{}, userId:{}", postId, userId);
			return;
		}
		
		// 멀티파일이 비어있지 않다면 업로드 후 imagePath -> 업로드가 성공하면 기존 이미지 제거
		String imagePath = null;
		if (file != null) {
			// 업로드
			imagePath = fileManagerService.saveFile(userLoginId, file);

			// 업로드 성공하면 기존 이미지 제거 => 업로드 실패할수 있으므로 업로드가 성공한 후 제거
			// imagePath가 null이 아니고, 기존 글에 imagePath가 null이 아닐경우
			if (imagePath != null && post.getImagePath() != null) {
				// 이미지 제거
				fileManagerService.deleteFile(post.getImagePath());
			}
		}
		
		// DB update
		postDAO.updatePostByPostIdUserId(postId, userId, subject, content, imagePath);
		
	}
	
	// 글 삭제
	public int deletePostByPostIdUserId(int postId, int userId) {
		// 기존 글 가져오기
		Post post = getPostByPostidUserId(postId, userId);
		if (post == null) {
			logger.warn("[글 삭제] post 값이 null이다. postId:{}, userId{}", postId, userId);
			return 0;
		}
		// 업로드된 이미지가 있으면 파일 삭제
		if (post.getImagePath() != null) {
			fileManagerService.deleteFile(post.getImagePath());
		}
		
		// DB delete
		return postDAO.deletePostByPostIdUserId(postId, userId);
	}
	
	public List<Post> getPostListByUserId(int userId, Integer prevId, Integer nextId) {
		// 게시글 번호가 : 10,9,8 | 7,6,5 | 4,3,2 | 1
		// 만약 4 3 2 페이지에 있을때
		// 1) 이전: 정방향 4보다 큰 3개 => 5,6,7 -- List reverse(7,6,5)
		// 2) 다음: 2보다 작은 3개 desc
		// 3) 첫페이지: 이전X 다음X desc limit 3
		
		String direction = null; // 방향
		Integer standardId = null; // 기준 postId
		if (prevId != null) { // 이전
			direction = "prev";
			standardId = prevId;
			
			List<Post> postList = postDAO.selectPostListByUserId(userId, direction, standardId, POST_MAX_SIZE);
			Collections.reverse(postList);
			return postList;
		} else if (nextId != null) { // 다음
			direction = "next";
			standardId = nextId;
		}
 		
		// 첫 페이지일때 (페이징X)  direction, standardId == null
		// 다음일때 standardId, direction != null
		return postDAO.selectPostListByUserId(userId, direction, standardId, POST_MAX_SIZE);
	}

	public boolean isPrevLastPage(int prevId, int userId) {
		int maxPostId = postDAO.selectPostIdByUserIdSort(userId, "DESC");
		return maxPostId == prevId ? true : false;
	}
	
	public boolean isNextLastPage(int nextId, int userId) {
		int minPostId = postDAO.selectPostIdByUserIdSort(userId, "ASC");
		return minPostId == nextId ? true : false;
	}
	
	public Post getPostByPostidUserId(int postId, int userId) {
		return postDAO.selecetPostByPostidUserId(postId, userId);
	}
	
}
