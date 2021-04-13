package kr.icia.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import kr.icia.domain.BoardVO;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {	
	@Setter(onMethod_ = { @Autowired }) //어느테이션에 전달값이 여러개의 배열 형태라면 {}이용
	private BoardService service;
	
	@Test
	public void testRegister() {
		BoardVO board = new BoardVO();
		board.setTitle("새로 작성하는 글 0413");
		board.setContent("새로 작성하는 내용 0413");
		board.setWriter("새로운 작성자 0413");
		
		service.register(board);
		log.info("생성된 게시물 번호 : " + board.getBno());
		
		// 서비스 > 매퍼 > mybatis query
	}
}
