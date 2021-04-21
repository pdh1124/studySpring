package kr.icia.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.icia.domain.Criteria;
import kr.icia.domain.ReplyVO;

public interface ReplyService {
	
	public int register(ReplyVO vo); //글쓰기
	
	public ReplyVO get(Long rno); //글읽기
	
	public int remove(Long rno); //삭제
	
	public int modify(ReplyVO reply); //수정
	
	public List<ReplyVO> getList(@Param("cri") Criteria cri, @Param("bno") Long bno); //목록
	
}
