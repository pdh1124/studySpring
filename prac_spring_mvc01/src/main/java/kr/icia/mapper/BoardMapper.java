package kr.icia.mapper;

import java.util.List;

import kr.icia.domain.BoardVO;

public interface BoardMapper {
	public List<BoardVO> getList();
	// List는 ArrayList 부모 클래스,
	// 가변형 객체 배열 느낌.
	// index를 가지고 있음.
	
	public void insert(BoardVO board); //글쓰기
	//bno 는 시퀀스 자동 생성으로 나머지 값만 입력.
	
	public void insertSelectKey(BoardVO board); //글쓰고 글번호 받기
	// 생성되는 시퀀스 값을 확인하고 나머지 값 입력.
	
	public BoardVO read(Long bno); //읽기
	
	public int delete(Long bno); //삭제
	
	public int update(BoardVO board); //수정
}
