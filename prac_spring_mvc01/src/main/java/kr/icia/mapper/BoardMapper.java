package kr.icia.mapper;

import java.util.List;

import kr.icia.domain.BoardVO;

public interface BoardMapper {
	public List<BoardVO> getList();
	// List는 ArrayList 부모 클래스,
	// 가변형 객체 배열 느낌.
	// index를 가지고 있음.
}
