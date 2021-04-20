package kr.icia.mapper;


import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import kr.icia.domain.BoardVO;
import kr.icia.domain.Criteria;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
//	@Test
//	public void testGetList() {
//		mapper.getList().forEach(board -> log.info(board));
//		// 향상된 for : 배열과 배열 1개를 담을 변수
//		// 담다식 : -> 를 기준으로 좌항은 전달값, 우항은 처리
//		// 목록은 게시물 여러개(배열), 그중 1개를 board에 담은 다음에 해당 내용을 로그로 출력. 배열 원소가 끝날때 까지 반복
//		// 기술의 발달로 복잡한 코드가 간단해진 결과로 이해
//	}
	
//	@Test
//	public void testInsert() {
//		BoardVO board = new BoardVO();	
//		board.setTitle("새로 작성하는 글 - 0412");
//		board.setContent("새로 작성하는 내용 - 0412");
//		board.setWriter("새로운 작성자 - 0412");
//		
//		mapper.insert(board);
//		log.info(board);
//		
//	}
	
//	@Test
//	public void testInsertSelectKey() {
//		BoardVO board = new BoardVO();
//		board.setTitle("새로 작성하는 글 SelectKey");
//		board.setContent("새로 작성하는 내용 SelectKey");
//		board.setWriter("새로운 작성자 SelectKey");
//		
//		mapper.insertSelectKey(board);
//		log.info(board);
//	}
	
//	@Test
//	public void testRead() {
//		BoardVO board = mapper.read(9L);
//		// L은 bno가 long 타입이라는 것을 알림
//		
//		log.info(board);
//	}
	
//	@Test
//	public void testDelete() {
//		log.info("delete cnt: " + mapper.delete(7L));
//		//7번 게시물 삭제
//	}
	
//	@Test
//	public void testUpdate() {
//		BoardVO board = new BoardVO();
//		board.setBno(5L);
//		board.setTitle("수정된 제목");
//		board.setContent("수정된 내용");
//		board.setWriter("user0413");
//		
//		int count = mapper.update(board);
//		log.info("update cnt : " + count);
//	}
	
	@Test
	public void testPaging() {
		Criteria cri = new Criteria();
		cri.setPageNum(1);
		cri.setAmount(10);
		
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board.getBno()));
	}
	
}
