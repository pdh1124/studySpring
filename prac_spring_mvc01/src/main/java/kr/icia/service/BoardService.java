package kr.icia.service;

import java.util.List;

import kr.icia.domain.BoardVO;

public interface BoardService {
	public void register(BoardVO board); //등록.
	
	public BoardVO get(Long bno); //읽기
	
	public boolean modify(BoardVO board); //수정
	
	public boolean remove(Long bno); //삭제
	
	public List<BoardVO> getList(); //목록 
}
