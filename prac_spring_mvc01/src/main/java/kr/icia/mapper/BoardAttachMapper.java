package kr.icia.mapper;

import java.util.List;

import kr.icia.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public void insert(BoardAttachVO vo); //첨부파일 등록
	public void delete(String uuid); //첨부파일 삭제
	public List<BoardAttachVO> findByBno(Long bno);//첨부파일 목록
	public void deleteAll(Long bno);
	//첨부파일 여러개 한꺼번에 삭제
	public List<BoardAttachVO> getOldFiles();
	// 111.zip 커뮤니티를 사용하는 사용자들은
	// 중복 파일명을 사용할 수도 있음.
	// 시스템은 동일 파일명에 대해서 내부적으로 저장하는 다른 이름을 가짐.
}
