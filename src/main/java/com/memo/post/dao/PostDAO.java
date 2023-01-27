package com.memo.post.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.memo.post.model.Post;

@Repository
public interface PostDAO {

	public int insertPost(
			@Param("userId") int userId,
			@Param("subject") String subject,
			@Param("content") String content,
			@Param("imagePath") String imagePath
			);
	
	public List<Post> selectPostListByUserId(
			@Param("userId") int userId,
			@Param("direction") String direction,
			@Param("standardId") Integer standardId,
			@Param("limit") int limit			
			);
	
	public int selectPostIdByUserIdSort(
			@Param("userId") int userId, 
			@Param("sort") String sort);
	
	public Post selecetPostByPostidUserId(
			@Param("postId") int postId,
			@Param("userId") int userId);
	
	public void updatePostByPostIdUserId(
			@Param("postId") int postId,
			@Param("userId") int userId,
			@Param("subject") String subject,
			@Param("content") String content,
			@Param("imagePath") String imagePath
			);
	
	public int deletePostByPostIdUserId(
			@Param("postId") int postId,
			@Param("userId") int userId);
}
