package kr.icia.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.icia.domain.Criteria;
import kr.icia.domain.ReplyPageDTO;
import kr.icia.domain.ReplyVO;

public interface ReplyService {
	
	public int register(ReplyVO vo); //글쓰기
	
	public ReplyVO get(Long rno); //글읽기
	
	public int remove(Long rno); //삭제
	
	public int modify(ReplyVO reply); //수정
	
	public List<ReplyVO> getList(@Param("cri") Criteria cri, @Param("bno") Long bno); //페이지 정보와 게시물 번호를 전달.
	
	public ReplyPageDTO getListPage(Criteria cri, Long bno); //ReplyPageDTO : 댓글의 목록과 게시물의 갯수.
}
