package kr.icia.service;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.log;

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
public class BoardServiceTests {	
	@Setter(onMethod_ = { @Autowired }) //어느테이션에 전달값이 여러개의 배열 형태라면 {}이용
	private BoardService service;
	
//	@Test
//	public void testRegister() {
//		BoardVO board = new BoardVO();
//		board.setTitle("새로 작성하는 글 0413");
//		board.setContent("새로 작성하는 내용 0413");
//		board.setWriter("새로운 작성자 0413");
//		
//		service.register(board);
//		log.info("생성된 게시물 번호 : " + board.getBno());
//		
//		// 서비스 > 매퍼 > mybatis query
//	}
	
	@Test
	public void testGetList2() {
		service.getList(new Criteria(2, 10)).forEach(board -> log.info(board));
		// 매개변수로 전달할 cri를 코드에서 직접 생성하여 전달하고,
		// getList 처리결과, boardVO의 List 객체 리턴(일종의 객체배열)
		// 요소 하나씩을 board 변수에 대입하고 로그로 출력.
	}
}
